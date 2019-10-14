# NMOS API Claim

_Very early thoughts..._

This claim would typically originate from the 'scopes' in a token request. A client will know which of these it could possibly need and will register them with the auth server. When a user logs in, they will additionally be asked to approve the client's use of these claims. As the user in this case isn't the resource owner they are unlikely to care and will just permit it, so it is much more important that these are 'got right' at the client registration stage, where the resource owner gives their permission.

## Notes
Prefix all of the following with the API slug?
A typical client only needs query_read and connection_write (which includes read implicitly)
Perhaps on day 1 read/write is all we define, and subresource permissions can only be added in new versions of specs?
Are there situations where we need CRUD over Read/Write? For Query API that may change how things work. Or would it? You'd actually need query_write to do subscriptions...
Could we wildcard? Defaults being `query_read_*` etc, allowing subtypes to be defined later.
`<api_name>_<r/w/crud>_<* or granular permission with underscore separation>` Allows `connection\_write\_\*\_tx` or `connection\_write\_single\_\*` etc.
Or link directly to API paths...

`connection_read_single_senders`
`connection_write_\*_receivers`

Makes it quite granular with an easy pattern, but is it actually useful, and does it restrict anything people might want to do?

- Are there any cases where we would allow someone to create but not update or vice versa?
- There probably are cases where we'd allow an update but not a delete, but would it always map to HTTP methods, or would it be API specific?
- If the auth server supports more than just NMOS, how do we make sure the scopes are expected and namespaced? Prefix all with nmos_?
- An internal OAuth implementation may return AD groups and user IDs in a token, but won't tell you what they're for. You're expected to have policy to work that out yourself at the resource server.
- A Node is never going to be able to do anything useful (beyond logging) with a user or group ID. A registry may, but it would likely be deployment specific.

## Claim Sketches

IS-04
- read (inc ws create/delete?)
- write

- read_nodes?
- read_all?
- write_rx
- write_reg

IS-05
- read
- write (all)

- read_single_tx
- etc...
- write_single_tx
- write_single_rx
- write_bulk_tx
- write_bulk_rx

IS-06
- read
- write

- read_devices
- read_endpoints
- read_flows
- read_links

- write_endpoints
- write_flows

IS-07
- read
- write (not applicable?)

IS-08
- read
- write

- read_inputs
- read_outputs
- read_io
- read_map

IS-09
- read (potentially not applicable)
- write (not applicable)

IS-10
N/A
