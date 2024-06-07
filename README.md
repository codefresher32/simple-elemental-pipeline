# Simple Elemental Video
Deploy a simple aws video pipeline

# Cloudformation Docs

[MediaPackage](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/AWS_MediaPackage.html)

# Prerequisites
- [Docker](https://www.docker.com/get-started)
- [Aws Cli](https://aws.amazon.com/cli)
- Make

# Login to Your Aws Account
You can set the environment variables manually or

```sh
eu-north-1-nonprod
export set CREDENTIAL_DIR=/Users/polok/.aws
```

Export a region
```sh
export AWS_REGION=eu-north-1
```

# Run Everything at Once

Run the following command from the terminal
```sh
make deploy
```

# Destroy Everything
Run the following command from the terminal
```sh
make destroy
```
