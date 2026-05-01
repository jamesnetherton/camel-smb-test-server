# SMB Test Server

⚠️ **WARNING: THIS IS FOR TESTING ONLY** ⚠️

This SMB server is designed **exclusively** for integration testing purposes. It contains hardcoded credentials and **MUST NEVER** be used in production environments.

## Security Notice

⚠️ **REQUIRED**: You **must** provide credentials via environment variables. This container has **no default credentials** for security reasons.

**Required Environment Variables**:
- `SMB_USER` - The SMB username
- `SMB_PASSWORD` - The SMB password

The container will refuse to start without both variables set.

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
