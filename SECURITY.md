# Security Policy

## ⚠️ This is a TEST-ONLY Container ⚠️

This SMB server contains **hardcoded credentials** and is designed **exclusively for testing**. It should **NEVER** be deployed in production or exposed to untrusted networks.

## Known Security Issues (By Design)

1. **Hardcoded Credentials**
   - Username: `camel`
   - Password: `camelTester123`
   - These are publicly visible in the source code

2. **No Authentication Strength**
   - Basic NTLM authentication
   - No certificate validation
   - No encryption beyond SMB3 defaults

3. **No Access Controls**
   - Anyone with network access can authenticate
   - No rate limiting
   - No audit logging

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

1. **Network Isolation**: Run in isolated Docker networks or private VLANs
2. **Firewall Rules**: Block ports 139 and 445 from external access
3. **Temporary Deployment**: Spin up for tests, tear down immediately after
4. **No Sensitive Data**: Never use real data with this server
5. **Monitor Usage**: If running in a shared environment, monitor for unauthorized access

## Alternative for Production

If you need a production SMB server, consider:
- Properly configured Samba with strong credentials
- Active Directory integration
- TLS/SSL certificates
- Audit logging and monitoring
- Regular security updates
