---
published: true
layout: post
title: JWT for service-to-service auth
---

Microservice architecture has been around for years now, and I thing it's here to stay.
While the approach has many advantages, it brings some challenges along the way, one of which is authentication/authorization.

Authentication and authorization are two very distinct concerns that are often treated together, expecially if the information used to verify them is the same (namely a username or a session identifier). From now on we will refer to both terms together as "auth".

In this little essay we consider a web-facing application with a microservice architecture, we assume we have a cluster where internal connectivity is not exposed, and we also have one or more services that are exposedon the internet as part of their responsibility.

In this context one would think that auth is handled by the outermost services and then the auth problem "disappears" within the context of the private microservice network. This would translate in inner services having no auth, meaning integration would be very easy, but it would let everyone within the network to access data and invoke procedures without any check. This scenario can work, but it assumes good intentions, meaning a misconfigured process or a bad actor could access/delete/modify data from within the company.

One way to partially deal with the unlimited access is acting at the network level by either firewall rules, network policies in kubernetes, or by solutions like a service mesh.
Another approach would be to authenticate each and every request even _within_ the cluster. And here is where JWT shines!

[JWT](https://jwt.io/) - or JSON Web Token - is a [not-so-new standard](https://tools.ietf.org/html/rfc7519)  that is used to represent (or be) auth. It consists in a [JSON](https://www.json.org) object with conventions on fields and also customizable fields, which is then encoded in a standard way. The encoding happens to be compatible with HTTP headers, which is convenient because it will be the way we use it. JWT is also optionally signed (JWS - JWT signed) and/or encrypted (JWE - JWT encrypted).

More in depth, a JWT is composed of two or three JSON objects:
- a header object which describes the token type and optional sign and encryption algorithms
- a payload object containing data
- an optional signature object

The payload object has standard fields called "claims" for common concepts:
- unique identifiers
- validity timestamps and validity limits
- audience specification for the token
- token issuer specification
- the subject of the token, i.e. who is the verified user/person/service authorized with this token

The payload can be freely extended with custom claims, as long as they are represented with standard JSON. A possible use of this is mapping capabilities of the authenticated entity, or carrying user information if JWT is used to represent a session.

So what does all of this bring to the context of microservices?
Consider an extension of the original scenario: if the outermost service is verifying the auth of the caller, it can also create a JWT representing the authorized caller in the form of metadata. Pair that with a signature (JWS) and you get a verifiable token that can be used to auth the request within all the internal calls inside the microservice architecture.

Other services should accept the call only if they:
- verify the signature of the token
- check whether they trust the issuer ("iss" claim in the payload)
- check whether they are part of the audience for the token. That is, if their name is in the "aud" list in the payload.
- check if token is still valid according to timestamp limits ("exp", "nbf" claims, see RFC)

This is nothing new but the biggest advantages of JWT/JWS is that all of these verifications can happen without calling other services, in other words, **properly crafted JWTs provide stateless authentication/authorization**.

There are added benefits of JWT:
- you can pass JWT along the next service in chained calls
- you can carry contextual information like transaction id, or user data
- for HTTP services you only add a header, so you get to keep a clean API
- testing can be enabled by ignoring JWT signature or by configuring a trusted issuer, no fancy setup is needed
- format is standard and uses formats and encodings that are easy to decode and debug
- it is becoming pretty common so it's easy to find API gateways and framework libraries that support it


Limitations:
- you need to configure your gateway (or web-facing server) to create the JWT
- you need an infrastructure to handle certificates, altough with solutions like letsencrypt this is becoming easier to do
- any process that initiate calls to JWT-protected services from within the cluster has to either pass through an API gateway or have a mean to create a trusted JWS by itself

I would also add that JWT are not limited to a microservice environment. The standard is agnostic and has been successfully used:
- as a soft replacement for HTTP session in frontend-backend communication
- 