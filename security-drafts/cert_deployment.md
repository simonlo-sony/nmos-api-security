# Certificate Deployment

_Very early thoughts..._

## Requirements
- Deployment of CA certificates
- Deployment of server certificates (and private keys)
- Potential deployment of client certificates (and private keys)
- Automated renewal

## Methods
- CMC/CMP - Not widely adopted, despite originating with the IETF
- SCEP - Widely adopted, but has limitations. Only RSA, not ECDSA. An RFC is now being written as an informational piece given its high level of usage. Implementations may not all be perfectly compatible given the original lack of a standard document.
- EST - Newer, and gaining implementations in commercial CA software.
- ACME - Internet friendly, but intended for server certs only. Won't deal with CA cert deployment (see https://smallstep.com/blog/private-acme-server/) or client certs at this time (see https://tools.ietf.org/html/draft-moriarty-acme-client-02).

Some ACME vs. EST comparison: https://tools.ietf.org/html/draft-moriarty-acme-client-00#section-4

## Commercial Implementations
* GlobalSign: SCEP, ACME
* EJBCA: SCEP, CMP, EST (Enterprise version), ACME (Enterprise version)
* Nexus Certificate Manager: EST, SCEP, CMP, ACME (Planned)
* Windows Server: SCEP (plus extensions like https://github.com/jfigus/ms-est)

## Notes
No matter which mechanism or mechanisms are used, some means for establishing initial trust of the CA is required. Typically for ACME this involves the use of pre-installed CA certificates, but for EST in a private setting this may require a more manual installation of a placeholder certificate or credentials to enable trust of the EST server. Once this step is complete, renewal can be completely automated (assuming certificates are not allowed to expire).

EST permits additional mechanisms to verify the client beyond the ownership of a given DNS name or web server. This includes the potential to check that a factory installed certificate matches a particular CA's public key, which may have been provided by the manufacturer.

Some means of discovery (assuming it is not already part of the standard) would be required for the CA's automation mechanism. This may be manual in the simplest case.

## Other Links
https://www.thalesesecurity.com/about-us/information-security-research/blogs/est-the-forgotten-standard
https://tools.ietf.org/html/rfc8555
https://tools.ietf.org/html/rfc7030
https://www.nexusgroup.com/blog/support-certificate-enrollment-protocol-est/
