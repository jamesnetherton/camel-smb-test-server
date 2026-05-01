# SMB Test Server

⚠️ **WARNING: THIS IS FOR TESTING ONLY** ⚠️

This SMB server is designed **exclusively** for integration testing purposes. It contains hardcoded credentials and **MUST NEVER** be used in production environments.

## Security Notice

⚠️ **REQUIRED**: You **must** provide credentials via environment variables. This container has **no default credentials** for security reasons.

**Required Environment Variables**:
- `SMB_USER` - The SMB username
- `SMB_PASSWORD` - The SMB password

The container will refuse to start without both variables set.

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

**⚠️ IMPORTANT**: You must provide credentials - the container will not start without them.

### Basic Usage

```bash
docker run -d \
  --name smb-test \
  -p 445:445 \
  -p 139:139 \
  -e SMB_USER=testuser \
  -e SMB_PASSWORD=mySecurePassword123 \
  quay.io/jamesnetherton/camel-smb-test-server:latest
```

Connect to shares:
```bash
# List shares
smbclient -L localhost -U testuser%mySecurePassword123

# Access read-write share
smbclient //localhost/data-rw -U testuser%mySecurePassword123

# Access read-only share
smbclient //localhost/data-ro -U testuser%mySecurePassword123
```

### Environment Variables (Required)

- `SMB_USER`: SMB username (no default - **required**)
- `SMB_PASSWORD`: SMB password (no default - **required**)

**Note**: Both variables must be set or the container will exit with an error.

### Generate Secure Password

```bash
# Generate a random password
PASSWORD=$(openssl rand -base64 16)

# Run with generated password
docker run -d \
  -e SMB_USER=testuser \
  -e SMB_PASSWORD=$PASSWORD \
  -p 445:445 -p 139:139 \
  quay.io/jamesnetherton/camel-smb-test-server:latest

echo "Password: $PASSWORD"
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
