# [WIP] AMWA BCP-003-02: Authorization Best Practices in NMOS APIs

_(c) AMWA 2019, CC Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)_

## Scope

## Use of Normative Language

## Documentation

- Knowledge of NMOS, JT-NM, etc.
- Recommend BCP-003-01
- Extension / Pre-requisite to IS-10

## Introduction

- Motives
- Technologies

## OAuth Aggregation Sites

https://tools.ietf.org/wg/oauth/

https://datatracker.ietf.org/wg/oauth/documents/

https://oauth.net/2/

https://www.oauth.com/oauth2-servers/map-oauth-2-0-specs/

## Authorization Flow (Informative)

- Top Level Description
- Diagrams

## Oauth 2.0 (Informative)

### Client Types

- Confidential vs Public
- Server-side Apps
- Native - OAuth 2.0 for Native Apps - RFC 6749
- SPA - OAuth 2.0 for Browser-Based Apps -  draft-ietf-oauth-browser-based-apps-04
- Explain Client Credentials - RFC 6749

### Grant Types

- Authorization Code Grant - RFC 6749
- PKCE - RFC 7636
- Device Authorization Grant - RFC 8628
- Explain deprecation and recommendations - OAuth 2.0 Security Best Current Practice - draft-ietf-oauth-security-topics-13

## Client Registration

### Endpoint Discovery

- OAuth 2.0 Authorization Server Metadata - RFC 8414

  Discover endpoints dynamically

### Client Authentication

- Manual registration
- Use of TLS/HTTPS as authentication
- Possible use of Client side certs (see Mutual TLS below)
- Approval by authorized Admin, to validate client's scopes, etc.

### Storage of Client Credentials

- Need to keep secret confidential for confidential (server-side) clients
- Storage in non-volatile location

## Public Keys

- Use of JSON Web Keys (JWK) - RFC 7517

  Key Type ("kty") - "RSA", Use ("use") - "sig", Key Operations ("key_ops") - "verify", Algorithm ("alg") - "RS512, Key ID("kid") - TBC

- JWK Sets

  Keys param ("keys") - array of JWK's

- Cycling Keys, Key changeovers, Key ID's, persisting keys till tokens expire

## Requesting Tokens

- Resource Indicators for OAuth 2.0 - draft-ietf-oauth-resource-indicators-08

  Passing of `resource` parameter to indicate value of `aud` claim (would go in IS-10)

## Token Contents

### Public Claims

- JSON Web Token (JWT) Profile for OAuth 2.0 Access Tokens - draft-ietf-oauth-access-token-jwt-02

  Population of Client ID inside claims

### Private Claims

- OAuth 2.0 Rich Authorization Requests - draft-lodderstedt-oauth-rar-02
- General format of `x-nmos-api` claim

## Ensuring Security

### Best Common Practices

- OAuth 2.0 Security Best Current Practice - draft-ietf-oauth-security-topics-13
- JSON Web Token Best Current Practices - draft-ietf-oauth-jwt-bcp-06

### Sender Constrained Access Tokens

- OAuth 2.0 Mutual-TLS Client Authentication and Certificate-Bound Access Tokens - draft-ietf-oauth-mtls-17
- OAuth 2.0 Demonstration of Proof-of-Possession (PoP) at the Application Layer - draft-fett-oauth-dpop-02
