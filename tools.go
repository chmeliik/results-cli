//go:build tools

package main

import (
	_ "github.com/sigstore/cosign/v2/cmd/cosign"
	_ "github.com/google/go-containerregistry/cmd/crane"
)
