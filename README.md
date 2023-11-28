# results-cli

**Upload a file to an OCI repository:**

You need to log in to the registry first, e.g. with `podman login`, `skopeo login`
or any other container tool that has a login command.

```shell
$ export OCI_RESULTS_REPOSITORY=quay.io/acmiel-test/test
$ ./oci-results set -f README.md -o /dev/null
Uploading file from [README.md] to [quay.io/acmiel-test/test:result-sha256-ac082eab4233ead189479c2b109193cfc30f178330df444117e60b11d6c0fba9] with media type [text/plain]
File [README.md] is available directly at [quay.io/v2/acmiel-test/test/blobs/sha256:ac082eab4233ead189479c2b109193cfc30f178330df444117e60b11d6c0fba9]
Uploaded image to:
quay.io/acmiel-test/test@sha256:4a972c6ceb550c796287f25d91177d6de47c0bbd296ed31d3429e1da8c907b07
```

The image gets a unique tag based on the sha256 checksum of the uploaded file. The
digest-based image reference can be written to a file with the `-o` option.

```shell
$ ./oci-results set -f README.md -o /tmp/readme
$ cat /tmp/readme
quay.io/acmiel-test/test@sha256:4a972c6ceb550c796287f25d91177d6de47c0bbd296ed31d3429e1da8c907b07
```

**Download a file from an OCI repository:**

```shell
$ ./oci-results get "$(cat /tmp/readme)" -o /tmp/README.md
$ cat /tmp/README.md
<this doc>
```

**Upload/download multiple results:**

```shell
$ mkdir /tmp/my-results
$ for name in foo bar baz; do echo "Hi $name" > /tmp/my-results/"$name"; done

$ ./oci-results set-all /tmp/my-results --output-references=/tmp/result-refs

$ for f in /tmp/result-refs/*; do echo "$f"; cat "$f"; done
/tmp/result-refs/bar
quay.io/acmiel-test/test@sha256:61953dfa624378f931e23468e5800f6790f88f369683572e9dcd685ed5775745
/tmp/result-refs/baz
quay.io/acmiel-test/test@sha256:22d73a7c53f4d718e4fb36570f44a666773457673fd423f242865e7c890132bc
/tmp/result-refs/foo
quay.io/acmiel-test/test@sha256:430e06dc69d99f8f0701496c503a0e07e2059874ba1b246c3d5a4b4f8ae7f13e
```

```shell
$ ./oci-results get-all \
    foo="$(cat /tmp/result-refs/foo)" \
    bar="$(cat /tmp/result-refs/bar)" \
    baz="$(cat /tmp/result-refs/baz)" \
    --output-results=/tmp/downloaded-results

getting /tmp/downloaded-results/foo <- quay.io/acmiel-test/test@sha256:430e06dc69d99f8f0701496c503a0e07e2059874ba1b246c3d5a4b4f8ae7f13e
getting /tmp/downloaded-results/bar <- quay.io/acmiel-test/test@sha256:61953dfa624378f931e23468e5800f6790f88f369683572e9dcd685ed5775745
getting /tmp/downloaded-results/baz <- quay.io/acmiel-test/test@sha256:22d73a7c53f4d718e4fb36570f44a666773457673fd423f242865e7c890132bc

$ for f in /tmp/downloaded-results/*; do echo "$f"; cat "$f"; done
/tmp/downloaded-results/bar
Hi bar
/tmp/downloaded-results/baz
Hi baz
/tmp/downloaded-results/foo
Hi foo
```

## Usage with Tekton

See the [example PipelineRun](./ppr-oci-results.yaml).
