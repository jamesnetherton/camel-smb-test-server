# SMB Test Server

⚠️ **WARNING: THIS IS FOR TESTING ONLY** ⚠️

This SMB server is designed **exclusively** for integration testing purposes. It contains hardcoded credentials and **MUST NEVER** be used in production environments.

## Security Notice

**Default Credentials** (if not overridden):
- **Username**: `camel`
- **Password**: `camelTester123`

⚠️ **IMPORTANT**: The default credentials are publicly known. For any deployment (even test environments), you should **set custom credentials** using environment variables.

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

### With Custom Credentials (Recommended)

```bash
docker run -d \
  --name smb-test \
  -p 445:445 \
  -p 139:139 \
  -e SMB_USER=myuser \
  -e SMB_PASSWORD=mySecurePassword123 \
  quay.io/jamesnetherton/camel-smb-test-server:latest
```

Connect to shares:
```bash
# List shares
smbclient -L localhost -U myuser%mySecurePassword123

# Access read-write share
smbclient //localhost/data-rw -U myuser%mySecurePassword123

# Access read-only share
smbclient //localhost/data-ro -U myuser%mySecurePassword123
```

### With Default Credentials (Quick Testing Only)

```bash
docker run -d \
  --name smb-test \
  -p 445:445 \
  -p 139:139 \
  quay.io/jamesnetherton/camel-smb-test-server:latest
```

Connect with default credentials:
```bash
smbclient -L localhost -U camel%camelTester123
```

### Environment Variables

- `SMB_USER`: SMB username (default: `camel`)
- `SMB_PASSWORD`: SMB password (default: `camelTester123`)

**Note**: Set both or neither. If you only set one, the behavior is undefined.

## Shares

- **data-rw**: Read-write share with 100 pre-created test files
- **data-ro**: Read-only share with 100 pre-created test files

## Building

```bash
docker build -t smb-test-server .
```

## License

Apache License 2.0
