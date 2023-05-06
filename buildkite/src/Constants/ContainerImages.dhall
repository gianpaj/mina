-- TODO: Automatically push, tag, and update images #4862
-- NOTE: minaToolchain is the default image for various jobs, set to minaToolchainBullseye
-- NOTE: minaToolchainBullseye is also used for building Ubuntu Focal packages in CI
-- NOTE: minaToolchainBookworm is also used for building Ubuntu Jammy packages in CI
{
  toolchainBase = "codaprotocol/ci-toolchain-base:v3",
  minaToolchainBuster = "gcr.io/o1labs-192920/mina-toolchain@sha256:64f12992a69e6dc008a0277b9f2fc1fde30b28be6e6e9cd1c130b2e745c4abe3",
  minaToolchainBullseye = "gcr.io/o1labs-192920/mina-toolchain@sha256:9b94203db3162e7168c6680f4eed4a6e02bff0ad5785dbd4317f3d5cd11291fd",
  minaToolchainBookworm = "gcr.io/o1labs-192920/mina-toolchain@sha256:1e2feaebd47c330e990fe3c4e0681d16ad42bfa642937c4c5142793da06c890b",
  minaToolchain = "gcr.io/o1labs-192920/mina-toolchain@sha256:9b94203db3162e7168c6680f4eed4a6e02bff0ad5785dbd4317f3d5cd11291fd",
  delegationBackendToolchain = "gcr.io/o1labs-192920/delegation-backend-production@sha256:8ca5880845514ef56a36bf766a0f9de96e6200d61b51f80d9f684a0ec9c031f4",
  elixirToolchain = "elixir:1.10-alpine",
  nodeToolchain = "node:14.13.1-stretch-slim",
  ubuntu2004 = "ubuntu:20.04",
  xrefcheck = "serokell/xrefcheck@sha256:8fbb35a909abc353364f1bd3148614a1160ef3c111c0c4ae84e58fdf16019eeb"
}
