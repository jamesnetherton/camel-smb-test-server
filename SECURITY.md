# Security Policy

## ⚠️ This is a TEST-ONLY Container ⚠️

This SMB server contains **hardcoded credentials** and is designed **exclusively for testing**. It should **NEVER** be deployed in production or exposed to untrusted networks.

## Known Security Issues (By Design)

1. **No Default Credentials (Security Feature)**
   - ✅ This container **requires** credentials to be provided
   - ✅ No publicly known default credentials
   - Container will refuse to start without `SMB_USER` and `SMB_PASSWORD` set
   - Users must explicitly choose credentials for their environment

2. **No Authentication Strength**
   - Basic NTLM authentication
   - No certificate validation
   - No encryption beyond SMB3 defaults
   - No multi-factor authentication
   - No password complexity requirements

3. **No Access Controls**
   - Anyone with valid credentials can authenticate
   - No rate limiting
   - No audit logging
   - No IP allowlisting
   - Single user only (the configured SMB_USER)

## Intended Use Cases

- ✅ CI/CD testing pipelines
- ✅ Local development
- ✅ Automated integration tests
- ✅ Network-isolated test environments

## Prohibited Use Cases

- ❌ Production deployments
- ❌ Internet-facing deployments
- ❌ Storing sensitive data
- ❌ Long-running test environments
- ❌ Shared/multi-tenant environments

## Reporting Security Issues

Since this is a test-only container with intentionally weak security, traditional security vulnerability reports are not applicable. However, if you discover:

- A way this container could be misused that we haven't documented
- A security issue that affects users **even in isolated test environments**
- Suggestions for making the warnings clearer

Please open an issue in the GitHub repository.

## Recommendations for Safe Testing

1. **Use Strong Credentials**: Generate random passwords for each deployment
   ```bash
   docker run \
     -e SMB_USER=testuser \
     -e SMB_PASSWORD=$(openssl rand -base64 16) \
     ...
   ```

2. **Network Isolation**: Run in isolated Docker networks or private VLANs
   ```bash
   docker network create smb-test-net
   docker run --network smb-test-net ...
   ```

3. **Firewall Rules**: Block ports 139 and 445 from external access

4. **Temporary Deployment**: Spin up for tests, tear down immediately after
   ```bash
   docker run --rm ...  # Auto-remove on exit
   ```

5. **No Sensitive Data**: Never use real data with this server

6. **Monitor Usage**: If running in a shared environment, monitor for unauthorized access

7. **Use Secrets Management**: In CI/CD, store credentials in secrets
   ```yaml
   env:
     SMB_USER: ${{ secrets.SMB_TEST_USER }}
     SMB_PASSWORD: ${{ secrets.SMB_TEST_PASSWORD }}
   ```

## Alternative for Production

If you need a production SMB server, consider:
- Properly configured Samba with strong credentials
- Active Directory integration
- TLS/SSL certificates
- Audit logging and monitoring
- Regular security updates
