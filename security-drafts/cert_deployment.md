# Certificate Deployment

_Very early thoughts..._

## Methods
- CMC/CMP - Not widely adopted, despite originating with the IETF
- SCEP - Adopted, but has limitations. Only RSA, not ECDSA. An RFC is being written as an informational piece given its high level of usage.
- EST - New, perhaps a good choice?
- ACME - Internet friendly, but can it be used internally? Will it deploy CA certs?

## Requirements
- Deployment of CA certificates
- Deployment of server certificates (and private keys)
- Potential deployment of client certificates (and private keys)
- Automated renewal

Some ACME vs. EST comparison: https://tools.ietf.org/html/draft-moriarty-acme-client-00#section-4

ACME doesn't appear to be intended to deal with CA cert deployment.
