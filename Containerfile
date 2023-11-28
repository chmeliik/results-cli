FROM registry.access.redhat.com/ubi8/go-toolset:1.20.10-3 AS build

COPY go.mod go.sum tools.go .
RUN go install \
        github.com/sigstore/cosign/v2/cmd/cosign \
        github.com/google/go-containerregistry/cmd/crane

RUN cp "$(go env GOPATH)/bin/cosign" /tmp/cosign
RUN cp "$(go env GOPATH)/bin/crane" /tmp/crane

FROM registry.access.redhat.com/ubi9/python-311:1-34.1699551735

COPY --from=build /tmp/cosign /usr/local/bin/cosign
COPY --from=build /tmp/crane /usr/local/bin/crane

COPY oci_results.py /usr/local/bin/oci-results
