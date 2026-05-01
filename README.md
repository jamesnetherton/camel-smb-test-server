# SMB Test Server

⚠️ **WARNING: THIS IS FOR TESTING ONLY** ⚠️

This SMB server is designed **exclusively** for integration testing purposes. It contains hardcoded credentials and **MUST NEVER** be used in production environments.

## Security Notice

- **Username**: `camel`
- **Password**: `camelTester123`

These credentials are **publicly visible** in this repository and **hardcoded** in the container. Anyone with network access to this server can authenticate using these credentials.

### ❌ DO NOT:
- Deploy this to production
- Expose this server to the internet
- Store sensitive data on this server
- Use this in any untrusted network
- Leave this running indefinitely

### ✅ Safe Usage:
- CI/CD testing pipelines (isolated)
- Local development/testing
- Temporary integration test environments
- Network-isolated test labs

## Purpose

This container provides an SMB/CIFS server for testing Apache Camel SMB component integration. It includes:
- Two test shares: `data-rw` (read-write) and `data-ro` (read-only)
- Pre-populated test files
- Simple authentication for automated testing

## Usage

```bash
docker run -d \
  --name smb-test \
  -p 445:445 \
  -p 139:139 \
  quay.io/jamesnetherton/camel-smb-test-server:latest
```

Connect to shares:
```bash
# List shares
smbclient -L localhost -U camel%camelTester123

# Access read-write share
smbclient //localhost/data-rw -U camel%camelTester123

# Access read-only share
smbclient //localhost/data-ro -U camel%camelTester123
```

## Shares

- **data-rw**: Read-write share with 100 pre-created test files
- **data-ro**: Read-only share with 100 pre-created test files

## Building

```bash
docker build -t smb-test-server .
```

## License

Apache License 2.0
