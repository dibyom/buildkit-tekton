ARG GOLANG_IMAGE=golang:1.17.5-alpine@sha256:4918412049183afe42f1ecaf8f5c2a88917c2eab153ce5ecf4bf2d55c1507b74

FROM ${GOLANG_IMAGE} AS build
WORKDIR /src
ENV CGO_ENABLED=0
RUN --mount=target=. --mount=target=/root/.cache,type=cache --mount=target=/go/pkg,type=cache \
  go build -trimpath -ldflags "-s -w" -o /out/buildkit-tekton ./cmd/buildkit-tekton

FROM scratch
COPY --from=build /out/ /
LABEL moby.buildkit.frontend.network.none="true"
ENTRYPOINT ["/buildkit-tekton", "frontend"]
