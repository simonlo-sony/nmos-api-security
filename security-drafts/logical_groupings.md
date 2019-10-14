# Logical Node Groupings in NMOS for Security

## Introduction

There may be a need for a mechanism by which NMOS Resources, typically Nodes and Devices, acquire
information regarding the logical "group" or "area" that they belongs to. This information should be
acquired in an automatic way, such that the resource limits the requirement of being manually
configured.

The addition for such a mechanism would allow resources to be placed within logical groups to limit
the use of Access Tokens against a given Node or Device within a broadcast environment. Specifically,
it would enable a Resource Server (such as a Device or Node) to validate the `aud` claim within a
JSON Web Token, when a Client, such as a Broadcast Controller (BC), performs an API request against
it. If the contents of the `aud` claim in the access token does not contain a value that the resource
itself identifies with, the resource server rejects the API request.

## Identifying a Resource

The `aud` claim of a JWT:

"Identifies the recipients that the JWT is intended for. Each principal intended to process the JWT
must identify itself with a value in the audience claim. If the principal
processing the claim does not identify itself with a value in the `aud` claim when this claim is
present, then the JWT must be rejected."

In order for a resource server to identify itself with the claim, it must first be aware of its own
identity. This could take various forms such as:
- The UUID of the resource - this is the unique identifier for that given resource (Node, Device,  
  Sender, etc.). This is the most granular definition.
- The FQDN of the device - this is the hostname and domain in which the hardware device can be found.
- A wild-carded FQDN or UUID - this is the same as above, but makes use of wild-carding (e.g.
  `*.broadcastcentre.com` or `52358e38-cba1-11e8-*`) in order to target all devices within a
  sub-domain or a specific subset of UUID's.
- IP addresses / subnets - whilst this negates the need for DNS, due to the reliance of TLS on
  hostnames and the requirement of OAuth over HTTPS/TLS, this option will not be discussed in this
  document due to the dynamic assignment of addresses recommended via the use of DHCP.
- The name of a group - this is a string that corresponds with a group that the resource is a part
  of. The assignment of such groups is detailed below.

## Grouping Concepts

The concept of logical grouping in the instance of this document is separate from the concept of Natural Grouping
as outlined in [BCP-002-01](https://amwa-tv.github.io/nmos-grouping/best-practice-natural-grouping.html) which
covers resources that are bound together naturally by a device.
A group, or an area, in this document defines a technical or physical area, such as a studio, but may
also refer to a production or a collection of similar resources, be they virtual or physical.

## Methods of Grouping

The key methods of gaining information to signify the groups/areas that a resource belongs can be divided into:
- The use of DNS Naming Conventions and wildcards.
- The use of Reverse DNS lookups and PTR records.
- Access to a common Grouping API.
- Use of the IS-04 native fields, specifically the `tags` and possibly `label` fields.

### DNS

The primary information available to a network-connected device upon connection are the network information given
to it via DHCP, namely hostname and domain, DNS Server address, IP address, etc. Due to the reliance of TLS/HTTPS
on hostnames and not IP addresses for certificate validation, DNS resolution forms the basis of allowing secure
transport between devices. The given fully qualified domain name (e.g. `camera1.studio1.broadcastcentre.tv`) could
be validated against an access token with the use of wild-carding (e.g. `*.studio1.broadcastcentre.tv`) to
logically group devices based on sub-domains. It should be noted that it may be necessary to implement DNSSec or
DNS-over-HTTPS in order to validate DNS requests to protect against spoofing the DNS server.

A solution may include the use of reverse-DNS lookups using PTR records. If several PTR records are produced in the
DNS server for a given hardware device, a reverse-DNS lookup on the device could render a list of possible URIs
corresponding to that device, each of which defining the various areas corresponding to that device.

Another solution may be to combine the use of DNS entries with the use of native fields within the IS-04 API.

### Grouping API

TBC

### Using Native NMOS fields

#### The `Tags` field
The `tags` field within IS-04 allows "NMOS resources to expose supplemental information without changing current
IS-04 specification while maintaining backward compatibility."
Due to the presence of the `tags` field in all NMOS resources, this allows for granularity down to the sender and
receiver level, even if resources share a common network address.

The tags field is a JSON object, and could therefore be an array consisting of a list of the logical areas to which
that resource belongs. These areas could be assigned to the resource upon creation by the user, via the use of a
UI, or assigned dynamically by a control system, however such a mechanism for updating the Node API is currently
not defined. The list of potential areas could be inferred by DNS / reverse-DNS means as described above.

One disadvantage of using API fields is that resources could be removed from one logical area and placed into
another without the `tags` field being edited in some way, thus rendering them inoperable until modified or
re-provisioned.

#### A `user` field
One concept that occurs within the domain of OAuth 2.0 that does not exist within NMOS is the concept of a `user`.
Such a field could be added to the APIs of resources upon instantiation, and may be linked to the OS's user profile
that is currently logged in to the device. This however would not help with the assignment of logical groups beyond
grouping resources by their given user.

## Grouping Pitfalls

A concern is when a given Node or device contains several resources (a Multi-Viewer, for instance, with several
receivers) that belong to different logical groups.
Due to the device having a single IP address and FQDN, more granularity is required to separate the resources. All
resources within a given Node would also correspond to a given Node UUID, and share all node-level information.

A second concern is the moving of a Node from one logical area to a different one. There is a balance between
security and interoperability that needs to be considered.
Applying a range of operating areas to a Node's tags (detailed below), or providing very widely scoped
wild-carding, allows for interoperability and the moving of Nodes between operating areas, at the risk of having
Nodes susceptible to control by an unauthorised party.

Finally, the basis of using access tokens alongside refresh tokens is that access tokens are short-lived, whilst
refresh tokens are used to gain further access tokens upon their expiration. If a specific set of UUIDs / hostnames
are used to populate the `aud` claim, it is likely that any changes would not be detected until a new access token
was requested. This would likely result in a fresh access token needing to be requested upon every change for a
given user. Equally, if an access token is requested at the beginning of every API request, this would allow very
granular `aud` claims, but would add significant network overhead, and require several tokens to be cached within
the Broadcast Controller.

## Use Cases

### Single Broadcast Controller (BC) and Authorization Server (AS) in single logical area

#### Situation
In this use case, a single Authorization Server and Broadcast Controller operate over a single logical group or
area. In such a case, all devices will exist on a shared sub-domain and thus limiting a token based on DNS domain
wouldn't provide any further restrictions, except hijacking a token for use in a different domain.

#### Populating the `aud` Claim
The use of DNS wild-carding within a single domain could then only limit the access to devices with common
hostnames. For instance, `camera-*.broadcastcentre.tv`. If there is any logic regarding allocation of UUID's to
Nodes, wild-carding of UUID's may also be of benefit.

In this use-case, the population of the `aud` claim could be dependant on the user requesting the token. The
Authorization Server may contain, or have access to, via some form of LDAP system, a list of domains, productions,
etc, that the user is authorized to access, and the claim populated with relevant domains or UUIDs, or the names of
logical groups.

#### Validating the claim
In the case of a wild-carded host-names, Nodes are capable of validating the contents of the claim against their
own host-name. Equally, in the case of a UUID, Nodes are capable of checking this against the UUID stored on the
device.

For a list of productions, this would likely be checked against the `tags` field of the relevant resources API.

### Single BC and AS with multiple logical areas

#### Situation
In this use case, a single Authorization Server and Broadcast Controller operate over multiple logical groups or
areas. In such a case, it is assumed each of the areas operate within their own sub-domain and on their own subnet.

#### Populating the `aud` Claim
With a single BC and AS, there is a lack of information available to the Auth Server from the controller to
populate the `aud` claim with anything other than an all-encompassing wildcard claim for all available domains
(e.g. `*.broadcastcentre.com`). The access control is then reliant on the user operating the BC, the information of
which would likely populate the `x-nmos` claim.

For further granularity, the BC would need to request tokens with added data regarding the type of interaction it
is expecting to make e.g. reading API in Area 1. This shift of authorization towards the BC and away from the AS
undermines having a distinct, separate authorization service.

The BC could alternatively request a token from the Auth Server before each API call, with the access token limited
to the audience of the given Node. This however would incur significant overhead with calls constantly made to the
Auth Server, would remove the advantage of using Refresh Tokens and would likely worsen the user experience with
repeated user-validation requests required.

#### Validating the Claim
The claim would likely be validated against the Node or Devices UUID if the token was populated with each request.

### Single BC and AS with Nodes spread between multiple operating areas

#### Situation
In this use case, a single Authorization Server and Broadcast Controller operate over multiple logical groups or
areas. In such a case, a Node contains several resources (senders / receivers) that reside in different logical
areas (e.g. Area 1 and Area 2.) It is assumed in this instance that the individual resources are managed over a
single network interface and therefore the hardware device has a single IP address and domain name.

#### Populating the `aud` Claim
In this instance, populating the `aud` claim with a sub-domain would result in a user being able to control all the
resources on the device. In order to apply finer granularity, population of the `tags` field for each sender and
receiver would allow the individual resource to validate the token against its own API.

#### Validating the Claim
The contents of the claim would be validated against the `tags` field within the resource's API. This in turn could
be populated via a DNS reverse lookup. A DNS server could contain multiple PTR records for a given device used
across multiple areas. A reverse DNS lookup against that device could then result in multiple records being
returned that detailed the groups to which that device belongs. However, whilst that would detail the groups to
which that device belonged, there would still be no way of linking individual resources to any given group.

## Conclusion

Implementing a grouping mechanism by means of adding labels or tags to NMOS APIs moves significant effort into the
hands of users, in the form of adding groups uniformly into GUIs when creating resources, or into the hands of
network engineers, by adding PTR records and updating NMOS API's by some mechanism not yet defined.

With the example of a device containing resources belonging to different operating areas, this is likely going to
be a case in which a device hosts shared resources, such as transcoders, converters, etc, or special hardware. In
this case, the implementation must balance interoperability and security.
An interoperable means of grouping a subset of NMOS resources might be to implement a means of bulk editing of
resources - an operation that in itself would require a means of authorization and an operation not yet supported by
NMOS APIs. In this instance it is likely that all resources on the device will be controllable from the given
domain's Auth Server. As such, an emphasis should be placed on a Broadcast Controller's ability to
communicate with various Auth Server's from different logical areas, rather than how to group individual resources.
As virtualisation and private cloud solutions are adopted more in the future, this case is likely to exist less and
less, with the concept of creating functionality on the fly, to meet changing demand, increasing.

The mechanism of using DNS records with wildcarding provides a simple mechanism by which to group several devices
inside a common sub-domain. It would be easy to implement and makes use of network, and not NMOS-specific,
technologies. Whilst this puts a heavy reliance on DNS systems, and would probably require the
implementation of DNS Security (DNSSec), the spoofing of a device inside the DNS system should only render a
specific device uncontrollable, due to the protection provided by HTTPS/TLS, as opposed to having a malicious actor
be able to control a spoofed device. Due to the requirement of DNS systems within a fully-IP, "zero-configuration" broadcast centre, and its definiton within the JT-NM TR1001 document, the use of DNS naming conventions would likely lend itself well to the top-level grouping of devices without adding extra layers of complexity that may inhibit uptake by the industry.
