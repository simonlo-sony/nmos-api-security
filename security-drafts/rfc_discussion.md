# RFCs for Discussion

* **JSON Web Key:** https://tools.ietf.org/html/rfc7517
  * This appears to form a better structure for our /certs endpoint
  * TBC: Do we need to define some key names? In our internal implementation they require resource servers to cache keys for a period even if they change so they can validate two generations of tokens, but would that be sufficient for us if a new resource server came online whilst old tokens were still valid? Discuss.
* **Distributed OAuth:** https://tools.ietf.org/html/draft-ietf-oauth-distributed-01
  * An alternative to our _nmos-auth._tcp advert in some systems. Harder in our system as we want the resource servers to dynamically discover the auth server too.
* **Resource Indicators for OAuth 2.0:** https://tools.ietf.org/html/draft-ietf-oauth-resource-indicators-08
  * Provides the means to suggest how the 'aud' claim should be populated when requesting a token. Very interesting, but the limitations around use of absolute URIs may prevent use of wildcards (querying with the author).
* **OAuth 2.0 Authorization Server Metadata:** https://tools.ietf.org/html/rfc8414
  * Very interesting as this could open up the possibility to use a range of existing Authorization Server implementations with modifications only to how tokens are populated. Quite a change to the spec, but potentially very beneficial. May remove the need for an IS and take us back to just a BCP?
* **JWT Profile for OAuth 2.0 Access Tokens:** https://tools.ietf.org/html/draft-ietf-oauth-access-token-jwt-02
  * We should likely just adopt these recommendations. The client_id in particular may be useful for audit logging if nothing else.
* **OAuth 2.0 Mutual TLS Client Authentication and Certificate-Bound Access Tokens:** https://tools.ietf.org/html/draft-ietf-oauth-mtls-17
  * Potentially of interest for Nodes acting as clients in order to avoid complex user interactions with the Authorisation Server. Particularly if we can resolve automated certificate deployment. Does re-raise the question of whether we should *just* use certificates for this transaction, but OAuth does help to provide much finer grained control, restricting damage if a rogue party breached one device and obtained its certs/tokens.

Equally, https://oauth.xyz/ / https://mailarchive.ietf.org/arch/msg/oauth/v8TdkruCzwH43FMKS598IC2Sheo and discussions on it are of interest, but not yet mature enough for our consideration.

* **Others of interest:**
 * https://datatracker.ietf.org/doc/draft-ietf-oauth-jwt-bcp/
 * https://datatracker.ietf.org/doc/draft-ietf-oauth-security-topics/
