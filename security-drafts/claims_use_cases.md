# JWT Claims - Use Cases

## Introduction

### Interactions

The two primary use-cases in which JSON Web Tokens are expected to be used as a means of authorization inside a Broadcast Centre are:

- Broadcast Controllers -> IS-04 / IS-05 API's - Broadcast Controllers querying a Registry and connecting senders and recievers on Nodes via the Connection Management API.
- Nodes -> IS-04 Registration API - Nodes Registering with a Registry.

### Actors

The primary actors considered in this document will include:
- An admin user (typically a Senior Systems / Broadcast Engineer) - this user will likely have complete authorization to perform any given action.
- A standard user (typically a Broadcast Operator) -  this user will be limited to a specific operating area.
- An external / untrusted user (freelancer, contractor, separate broadcaster) - this user will be limited to a pre-defined set of actions.

### Claims

The claims of interest of us, and that may differ from the standard way in which OAuth 2.0 is used over the web, are:
- The `aud` claim - this specifies the audience that the token is intended for (the consumer of the token.)
- The `sub` claim - this specifies the universal identifier of the user to which the authorization token was granted.
- The `x-nmos-api` private claim - this is an NMOS specific claim and outlines the endpoints of a given NMOS API the user is permitted to access.

# Use Case 1 - Interaction between Broadcast Controller and IS-04 / IS-05 API's

## Admin User

An admin user is likely to be granted authorization to perform most actions, albeit there are some that may be restricted, such as the deletion of all devices from a registry. It is still recommended that the `aud` claim be specified for a given sub-domain, in order that any compromised tokens be minimised to a single location.

#### Example JWT Claims

```json
{
  "x-nmos-api": {
    "register": {
      "create": ["*"],
      "read": ["*"],
      "update": ["*"],
      "delete" : ["*"]
    },
    "query": {
      "create": ["*"],
      "read": ["*"],
      "update": ["*"],
      "delete" : ["*"]
    },
    "connection": {
      "create": ["*"],
      "read": ["*"],
      "update": ["*"],
      "delete" : ["*"]
    }
  },
  "aud": ["*.studio1.broadcastcentre.org"],
  "sub": "admin_user@broadcastcentre.org"
}
```

#### Mitigation

- If this token were to be acquired my a malicious actor, severe disruption could be caused to a broadcast area, with a heavy reliance on access / refresh token revocation or key rotation to invalidate the token. See Notes (3) below for ways in which to limit a token to editing only resources created by the user that the token was granted to.
- Alternatively, token binding to a client's private key (also termed Proof of Possession) could be implemented to bind tokens to the intended client.

## Standard User

A standard user is likely to be granted a token that authorizes them to make a set of changes on devices within a specific sub-domain, and be permitted to make connection between specific senders and receivers, and "read" resources from those devices. They would likely not be permitted to delete resources from a registry.

#### Example JWT Claims

```json
{
  "x-nmos-api": {
    "register": {
      "create": ["*/resource", "*/health/nodes/*"],
      "read": ["*"],
      "update": [],
      "delete" : []
    },
    "query": {
      "create": ["*/subscriptions"],
      "read": ["*"],
      "update": [],
      "delete" : ["*/subscriptions/*"]
    },
    "connection": {
      "create": ["*/bulk/*"],
      "read": ["*"],
      "update": ["*/single/*/*/staged"],
      "delete" : []
    }
  },
  "aud": ["*.studio1.broadcastcentre.org"],
  "sub": "standard_user@broadcastcentre.org"
}
```

## Untrusted / External User

An external user is one in which we inherently assign no explicit trust. Primary actions permitted to such a user are "read" actions, with the ability to POSt to WebSocket `/subscriptions` endpoints and heartbeat endpoints.

#### Example JWT Claims

```json
{
  "x-nmos-api": {
    "register": {
      "create": ["*/health/nodes/*"],
      "read": ["*"],
      "update": [],
      "delete" : []
    },
    "query": {
      "create": ["*/subscriptions"],
      "read": ["*"],
      "update": [],
      "delete" : []
    },
    "connection": {
      "create": [],
      "read": ["*"],
      "update": [],
      "delete" : []
    }
  },
  "aud": ["*.studio1.broadcastcentre.org"],
  "sub": "untrusted_user@broadcastcentre.org"
}
```

## Use Case 2 - Interaction between Nodes and IS-04 API

TBC

## Notes

1. Whilst a `PATCH` HTTP verb is synonymous with editing an existing resource and therefore safely is assumed to be an "update" request, the distinction between a `POST` and `PUT` on whether they are updating or creating a resource is less clear. A `POST` to `/resource` in IS-04 for instance can be either an update or a create request, depending on the existence of the resource.
2. If a `POST` to the `/subscriptions` endpoint in the Query API is the mechanism for reading from a WebSocket endpoint, should a standard user be permitted to delete subscriptions? Is there a risk they could inadvertently terminate valid subscriptions from other devices?
3. When a resource is registered with an NMOS API, the corresponding OAuth `client_id` used in the JWT that is performing the registration could be logged alongside each resource, along with the user form the `sub` claim. This could safeguard against a compromised token being used to delete lots of resources, by only authorising tokens to delete resources created by the same client or user.

## Conclusion

- Mostly binary - 0 = [], 1 = [" * "]
- Create and Update actions are blurred - RESTful applications usually use `POST` as a method for creating resources and `PUT` to replace/create resources. Due to the frequent use of `POST`, it can sometimes not be clear whether a resource is being created or updated. `PATCH` is the only verb assumed to exclusively update.
- WebSocket subscriptions appear to be the primary outlier (a HTTP `POST` is needed to set up the WebSocket subscription.)
