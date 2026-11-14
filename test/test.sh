#!/usr/bin/env bash
# Builds the image from ../Dockerfile and checks that it works.
#
#   test/test.sh                       # native architecture
#   PLATFORM=linux/arm64 test/test.sh  # another one (needs QEMU if not native)
#
# Environment:
#   PLATFORM    docker --platform value (default: the Docker host's own)
#   IMAGE       tag to build            (default: aws-emulator:test)
#   PORT        host/emulator port      (default: 9297)
#   BUILD_OPTS  extra `docker build` options, word-split
#   SKIP_BUILD  set to 1 to test an already built $IMAGE
set -euo pipefail

cd "$(dirname "$0")/.."

IMAGE=${IMAGE:-aws-emulator:test}
PORT=${PORT:-9297}
PLATFORM=${PLATFORM:-}
NAME="aws-emulator-test-$$"
WORK=$(mktemp -d)
platform_opt=()
[ -n "$PLATFORM" ] && platform_opt=(--platform "$PLATFORM")

failures=0
pass() { echo "ok   - $1"; }
fail() { echo "FAIL - $1"; failures=$((failures + 1)); }
check() { # check <description> <actual> <expected>
    if [ "$2" = "$3" ]; then pass "$1"; else fail "$1 (expected '$3', got '$2')"; fi
}

cleanup() {
    docker rm -f "$NAME" >/dev/null 2>&1 || true
    # The emulator's files may belong to another uid; remove them from a container.
    docker run --rm "${platform_opt[@]}" --user 0 --entrypoint rm -v "$WORK:/work" \
        "$IMAGE" -rf /work/emulator >/dev/null 2>&1 || true
    rm -rf "$WORK"
}
trap cleanup EXIT

# --- build -----------------------------------------------------------------
if [ "${SKIP_BUILD:-0}" != 1 ]; then
    # shellcheck disable=SC2086
    docker build "${platform_opt[@]}" ${BUILD_OPTS:-} -t "$IMAGE" .
fi
pass "image builds"

# --- image metadata ----------------------------------------------------------
if [ -n "$PLATFORM" ]; then
    docker_arch=${PLATFORM#*/}; docker_arch=${docker_arch%%/*}
else
    docker_arch=$(docker version --format '{{.Server.Arch}}')
fi
case "$docker_arch" in
    amd64) rpm_arch=x86_64 ;;
    arm64) rpm_arch=aarch64 ;;
    *) echo "Unsupported architecture: $docker_arch" >&2; exit 1 ;;
esac

inspect() { docker image inspect "${platform_opt[@]}" --format "$1" "$IMAGE"; }
check "image architecture" "$(inspect '{{.Architecture}}')" "$docker_arch"
check "runs as uid 1000" "$(inspect '{{.Config.User}}')" "1000"
check "exposes port 9297" "$(inspect '{{json .Config.ExposedPorts}}')" '{"9297/tcp":{}}'
check "entrypoint" "$(inspect '{{json .Config.Entrypoint}}')" '["aws-emulator","-b","0.0.0.0"]'

run() { docker run --rm "${platform_opt[@]}" "$@"; }
check "installed RPM architecture" \
    "$(run --entrypoint rpm "$IMAGE" -q --qf '%{ARCH}' aws-emulator)" "$rpm_arch"
check "RPM download is cleaned up" \
    "$(run --entrypoint sh "$IMAGE" -c 'ls /tmp/aws-emulator.rpm 2>/dev/null | wc -l')" "0"
if run "$IMAGE" --version; then pass "aws-emulator --version"; else fail "aws-emulator --version"; fi

# --- run it the way the README does -----------------------------------------
mkdir -p "$WORK/emulator"
docker run -d --name "$NAME" "${platform_opt[@]}" --user "$(id -u):$(id -g)" \
    --memory=2g --memory-swap=2g -p "127.0.0.1:$PORT:$PORT" \
    -e HOME="$WORK" -v "$WORK/emulator:$WORK/.aws/emulator" \
    "$IMAGE" -p "$PORT" -t off >/dev/null

ca="$WORK/emulator/$PORT/ca.pem"
url="https://127.0.0.1:$PORT/__admin/health"
status=000
for _ in $(seq 60); do
    if [ -z "$(docker ps -q -f "name=$NAME")" ]; then break; fi
    if [ -s "$ca" ]; then
        status=$(curl -s -o /dev/null -w '%{http_code}' --noproxy '*' --cacert "$ca" "$url" || true)
        [ "$status" = 200 ] && break
    fi
    sleep 1
done
check "health endpoint over HTTPS with the emulator's CA" "$status" "200"
if [ -s "$WORK/emulator/$PORT/emulator_credentials" ]; then
    pass "credentials file is written to the mounted directory"
else
    fail "credentials file is written to the mounted directory"
fi
check "files in the mounted directory belong to the caller" \
    "$(stat -c %u "$ca" 2>/dev/null || stat -f %u "$ca" 2>/dev/null || echo missing)" "$(id -u)"

if [ "$failures" -ne 0 ]; then
    echo "--- container logs ---"; docker logs "$NAME" 2>&1 | tail -n 50 || true
    echo "$failures check(s) failed"; exit 1
fi
echo "All checks passed ($docker_arch / $rpm_arch)"
