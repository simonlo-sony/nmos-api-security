# General Recommendations

## Introduction

For an OAuth 2.0 security specification to be adopted by the wider industry, a complex solution that covers every
possible use-case is not practical. The granularity of every claim such that it limits the access of a user to a
very specific set of devices would not only be complex to implement and configure, but
also have the potential to inhibit the flexibility of migrating production areas and hinder engineering operations.

As well designed as a security system may be, a large basis for a lot of broadcast centre security relies on the
trust it places in it's employees. If the understanding is that employees of a Broadcast Facility are already trusted
actors, any negative interference caused may be assumed to be non-intentional. To
prevent unintentional and unwanted control of devices, the combination of the Authorization System in conjunction
with the various protections imposed by the Broadcast Controller, such as Access Control, Single-Sign-On systems,
etc, should be sufficient to limit the scope of access.

In the rare case of intentional harm, the presence of an authorization system would not be sufficient on its own to
prevent them causing significant damage, assuming they have physical access to the majority of systems. Equally, in
the case of a malicious device, provisions such as certificate-provisioning, the presence of TLS, firewalls and
registration systems would all need to be by-passed.

## Security Measures

A combination of the following security methods should provide sufficient coverage to limit a user from performing an 
unauthorised action on a given device on a broadcast network:
- **OAuth 2.0 Client Registration** - The act of using a client that has been registered with the Authorization Server.
  This initial process must be authenticated by some means to prevent spurious devices from trivially being able to
  register as a client, with some means of protection against potential DDOS attacks. This initial registration may
  be subject to the presentation of a:
  - **Operator Confirmation** - registration of a given device is subject to confirmation by an authorized member of 
  production staff. Confirmation would likely take the form of approval via a protected Web GUI.
  - **Valid Server TLS Certificate** - the only requirement is the successful TLS handshake that precedes the
  HTTPS interaction. The provisioning of such a certificate if beyond the scope of this document but may be governed by a 
  central certificate management system or manually provisioned.
  - **Initial JWT** - this would be a specific token used purely for the registering of OAuth2 clients.
  - **Valid Client TLS Certificate** - a specific client certificate installed on the registering device in order to
  authenticate the interaction.
  - **User Credentials** - this may be access credentials to just the Auth Server itself, or more likely the
  authorization service would sit behind a company-wide single sign-on (SSO) service.
- **Ability to Gain a Token** - The ability to gain an access token and be authenticated by an OAuth 2.0 
  system. This would involve making a secure HTTPS connection using TLS, providing user credentials to log in to 
  the Authorization Server, providing user permission for the requested scopes, and accessing a protected resource 
  for which that token applied.
- **Aud Claim** - The limiting of a rough production area via the use of DNS wild-carding, with the option of
  introducing UUID wild-carding in the event that an external party requires access to a given device.
- **Private `x-nmos` Claim** - The limiting of a given user to specific paths of the requested APIs. API's are
  defined within the `scope` parameter during the OAuth2 authentication process. The `x-nmos` claim is subsequently populated 
  using both the scopes in the request and a back-end authentication system used to deduce access to the respective APIs.
