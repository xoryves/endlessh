FROM alpine:3.17.1@sha256:93d5a28ff72d288d69b5997b8ba47396d2cbb62a72b5d87cd3351094b5d578a0 as builder
LABEL stage=builder
RUN apk add --no-cache build-base
ARG USER=app
ARG UID=10100
ARG BUILDDIR=/build
RUN addgroup -g $UID -S $USER
RUN adduser -h /data -g '' -G $USER -u $UID -S -H $USER
RUN install -d 0755 -o $USER -g $USER $BUILDDIR

WORKDIR $BUILDDIR
USER app:app
COPY endlessh.c Makefile ./
RUN make

FROM scratch
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
COPY --from=builder /build/endlessh /
USER app:app
EXPOSE 2222/tcp
ENTRYPOINT ["/endlessh"]
CMD ["-v"]
