FROM public.ecr.aws/amazonlinux/amazonlinux:2023-minimal

# Set automatically by BuildKit (amd64 / arm64); picks the matching RPM.
ARG TARGETARCH
RUN case "${TARGETARCH:-$(uname -m)}" in \
        amd64|x86_64)  RPM_ARCH=x86_64 ;; \
        arm64|aarch64) RPM_ARCH=aarch64 ;; \
        *) echo "Unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; \
    esac \
    && curl -fsSL -o /tmp/aws-emulator.rpm \
        "https://downloads.aws.com/aws-emulator/packages/aws-emulator/LTS/latest/aws-emulator-${RPM_ARCH}.rpm" \
    && rpm -i /tmp/aws-emulator.rpm && rm /tmp/aws-emulator.rpm \
    && mkdir -p /home/emulator && chown 1000 /home/emulator

USER 1000
ENV HOME=/home/emulator
EXPOSE 9297
ENTRYPOINT ["aws-emulator", "-b", "0.0.0.0"]
