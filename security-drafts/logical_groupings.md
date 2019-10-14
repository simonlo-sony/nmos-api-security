# Logical Node Groupings in NMOS for Security

## Introduction

There may be a need for a mechanism by which NMOS Resources, typically Nodes and Devices, acquire
information regarding the logical "group" or "area" that they belong to. This information should be
acquired in an automatic way.

The addition of such a mechanism would allow resources to be placed within logical groups to limit
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

This may be defined as a single string or an array of strings. Typically these involve FQDNs, but this is not mandated.

In order for a resource server to identify itself with the claim, it must first be aware of its own
identity. This could take various forms such as:
- The UUID of the resource - this is the unique identifier for that given resource (Node, Device,
  Sender, etc.). This allows granular claims, but depends upon the resource in question using a UUID, and could result
  in very large tokens.
- The FQDN of the device - this is the hostname and domain in which the hardware device can be found.
- IP addresses / subnets - whilst this negates the need for DNS, due to the reliance of TLS on
  hostnames and the requirement of OAuth over HTTPS/TLS, this option will not be discussed in this
  document.
- The name of a group - this is a string that corresponds with a group that the resource is a part
  of. Potential mechanisms to assign such groups are detailed below.
- A wildcard - this could be applied to any of the above, but makes use of wild-carding (e.g.
  `*.broadcastcentre.com` or `172.29.*`) in order to target all devices within an area.

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
- Use of the IS-04 native fields, specifically `tags`.

Each of these methods has associated pros and cons, including the granularity of permission which they may permit, and
whether this can be intra-Node as well as inter-Node.

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
corresponding to that device, each of which defining the various areas corresponding to that device. This does however
require that the access management system (potentially a broadcast controller) and the DNS server share a strong
relationship, and adds a processing time to any token based request to allow for any DNS queries to be performed.

DNS based grouping only provides the ability to associate tokens at the Node level. Whilst a Node could appear in
several groups enabling its access from multiple production areas, it could not be restricted in a more granular
fashion such as restricting access to specific Senders or Receivers.

### Grouping API

A generic grouping API would provide the means to manage a Node and its sub-resources in a very flexible way. This is
similar to the DNS mechanism above, but has the potential to allow for intra-Node access management and avoids the
potential need for DNSSec or DNS over HTTPS. The disadvantages of this approach include the need to define a new API,
and the round trip time for resource servers to identify what a token is permitted to do. We have already noted out
intention to avoid the latter issue in the use of JWTs including claims rather than opaque tokens.

### Using Native NMOS fields

The `tags` field within IS-04 allows "NMOS resources to expose supplemental information without changing current
IS-04 specification while maintaining backward compatibility."
Due to the presence of the `tags` field in all NMOS resources, this allows for granularity down to the sender and
receiver level, even if resources share a common network address.

By defining a known tag name such as 'urn:x-nmos:tag:auth', the corresponding array could then consist of a list of the
logical areas to which that resource belongs. These areas could be assigned to the resource upon creation by the user,
via the use of a UI, or assigned dynamically by a control system, however such a mechanism for updating the Node API is
currently not defined and would need to be managed in a vendor-specific way. A work around for this may be to identify
the list of potential areas via DNS / reverse-DNS means as described above, with the associated security requirements.

One disadvantage of using API fields is that particularly mobile Nodes may be harder to manage, thus rendering them
inoperable until modified or re-provisioned with appropriate tags when moved from one area to another. A further
potential issue in this distributed mechanism of managing security is that tags could be accidentally left set to
permissive values, leaving them open to use by larger user groups than intended.

It should also be noted that `tags` are strongly tied to IS-04, and whilst they could easily be mapped onto APIs like
IS-05 given their common resource types, it may be harder to use them with APIs like IS-08 where resources like
'inputs' and 'outputs' have no similar concept.

## Grouping Pitfalls

As noted above, there are a number of potential pitfalls associated with each of these mechanisms for determining a
relevant audience (`aud`) claim:

1) When a given Node or device contains several independent resources that belong to different logical groups, more
granularity may be required to separate the resources beyond an FQDN or Node ID. There is a question over whether
this should be resolved at this layer, or whether it should be left up to higher level control systems.

2) When moving of a Node from one logical area to a different one. There is a balance between
security and flexibility that needs to be considered.

3) Finally, the basis of using access tokens alongside refresh tokens is that access tokens are short-lived, whilst
refresh tokens are used to gain continued access tokens upon their expiration. If very fine grained permissions are set
in the `aud` claim, they are more likely to need to change frequently. When these claims need to change, a refresh
token may be insufficient and the user could be asked to re-authenticate in order to gain an access token with modified
claims. This could become frustrating, or worse could happen at a critical moment during a production.
