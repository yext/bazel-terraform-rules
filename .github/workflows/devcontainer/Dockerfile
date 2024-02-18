FROM mcr.microsoft.com/devcontainers/go:1.20

# Set up bazel
RUN go install github.com/bazelbuild/bazelisk@v1.18.0 && \
    go install github.com/bazelbuild/buildtools/buildifier@v0.0.0-20230908120336-046e1686ec6f && \
    echo 'alias bazel="bazelisk"' >> /home/vscode/.bashrc