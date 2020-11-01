---
date: 2020-11-01
title: "JSON serialization for Web Linking"
docname: draft-pot-json-link-02
category: std
author:
 -
    ins: E. Pot
    name: Evert Pot
    email: me@evertpot.com
    uri: https://evertpot.com/
 -
    ins: G. Sullice
    name: Gabriel Sullice
    email: gabriel@sullice.com
    uri: https://sullice.com
    organization: Acquia, Inc.
normative:
  RFC8288:
  RFC8259:
informative:
  draft-nottingham-json-home:
    target: https://tools.ietf.org/html/draft-nottingham-json-home
    title: Home Documents for HTTP APIs
    author:
      ins: "M. Nottingham"
  draft-kelly-json-hal:
    target: https://tools.ietf.org/html/draft-kelly-json-hal
    title: JSON Hypertext A:wpplication Language
    author:
      ins: M. Kelly
      org: Stateless
  JSON-API:
    target: https://jsonapi.org/format/
    title: "JSON:API"
  WEBTHING:
    target: https://iot.mozilla.org/wot/
    title: "Web Thing API"
    author: 
      ins: Ben Francis
      org: Mozilla Corporation
  COLLECTIONJSON:
    target: http://amundsen.com/media-types/collection/format/
    title: "Collection+JSON"
    author:
      ins: Mike Amundsen
  SIREN:
    target: https://github.com/kevinswiber/siren
    title: "Siren: a hypermedia specification for representing entities"
    author:
      ins: Kevin Swiber
pi:
  toc: yes
  tocindent: yes
  sortrefs: yes
  symrefs: yes
  strict: yes
  compact: yes
  comments: yes
  inline: yes
  tocdepth: 3

--- abstract

This specification defines a serialization of Web Linking {{RFC8288}} in the
JSON {{RFC8259}} format.

--- middle

# Introduction

There are many JSON-based standards and formats that require the need to
express a link. Examples can be found in {{draft-kelly-json-hal}}, {{JSON-API}},
{{WEBTHING}}, {{draft-nottingham-json-home}}, {{COLLECTIONJSON}}, {{SIREN}} 
and many others.

Because there hasn't been an accepted reference for serializing Web Links in
JSON, it's typical for authors of new formats to invent their own. This has
resulted in many minor differences between serializations, making it difficult
to write generic parsers.

This document is an attempt to define a standard JSON serialization for
Web linking. A primary goal is to define a format that's relatively
uncontroversial and similar to existing serializations.

Furthermore, this specification defines an optional format for groups
of links and a recommendation for defining document-wide links.

# Format

## The link object.

A link will be encoded as a JSON {{RFC8259}} object. The object might support
the properties from the following chapters, but only `rel` and `href` are
required.

### rel

The `rel` property refers to Section 3.3 of {{RFC8288}}. The `rel` property
must be a string.

There is no support to encode multiple relation types for a single link. To
encode multiple relation types, the link must appear multiple times in the
document.

### href

The `href` property refers to the Link Target, defined in Section 3.1 of
{{RFC8288}}.

The property is required and must be specified as a string.

### anchor

The `anchor` attribute is defined in Section 3.2 of {{RFC8288}}. This
specification alters the behavior of anchor. By default, if anchor is not
specified the link context is considered to be the URL of the representation
it is associated with.

If the link appears alongside a link with the 'self' relation type
(for example in {{list}} of links, the target of the self link MUST be used
as the default link context, unless the anchor attribute is defined.

If the link is not part of a list of links that has a link relation of type
'self', the default behavior is to use the URL of the representation it's
associated with.

However, implementors of this specification MAY override this. Because JSON
links may have deeper contextual meaning depending on where it appears in
the document.

### Other attributes

The link object may also encode the `hreflang`, `media`, `type`
attributes. These properties are all defined in Section 3.4.1 of {{RFC8288}}.
In their JSON serialization they are all optional, and must be encoded
as a string.

Section 3.4.1 also defines a `title*` attribute, which may contain an
alternative encoding for the `title` attribute.

JSON only supports UTF-8 encoding. As such, it is not needed to make this
distinction. The link title is always encoded using the `title` property.

### Extension Attributes

Similar to {{RFC8288}}, other documents may define new target attributes
for links. Parsers that don't understand any attributes appearing on a link
MUST ignore them.

### Example

This section is non-normative.

~~~ json
{
  "href": "https://evertpot.com/",
  "rel": "author",
  "title": "Evert Pot"
}
~~~

## Lists of links {#list}

Authors that wish to encode a set of links in a document, SHOULD use an array
of links.


### Example

This section is non-normative.

~~~ json
[
  {
    "href": "https://evertpot.com/",
    "rel": "author",
    "title": "Evert Pot"
  },
  {
    "href": "https://test.example/",
    "rel": "self"
  }
}
~~~

## Document-level links

If a JSON representation wants to define document-level links, implementors
of this specification SHOULD use a top-level "links" property to define
these.

The "links" property contains a list of links.

The links appearing in this list are considered semantically equivalent to
the links appear in the `Link` header, as defined in Section 3.5 of
{{RFC8288}}.

Implementors of this specification MAY  make an effort to expose links from
the HTTP Link header and the document-level links via a unified interface.

### Example

This section is non-normative.

~~~ json
{
  "links": [ 
    {
      "href": "https://evertpot.com/",
      "rel": "author",
      "title": "Evert Pot"
    },
    {
      "href": "https://test.example/",
      "rel": "self"
    }
  ]
}
~~~

# IANA considerations

We would like to register the 'application/links+json' media-type for documents
wishing to implement this spec.

TBD?

--- back

# Typescript definitions

~~~ typescript
type Link = {
  href: string,
  rel: string,
  anchor?: string,
  hreflang?: string,
  media?: string,
  type?: string,
}

type LinkSet = Link[];

type DocumentLinks = {
  links: LinkSet
}
~~~


# JSON-SCHEMA definitions

## Link

~~~ json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "...",
  "type": "object",
  "additionalProperties": true,
  "required": [
    "href",
    "rel"
  ],
  "properties": {
    "href": {
      "type": "string",
      "format":"uri-reference"
    },
    "rel": {
      "type": "string",
    },
    "title": {
      "type": "string"
    },
    "type": {
      "type": "string"
    },
    "hreflang": {
      "type": "string",
    },
    "media": {
      "type": "string"
    }
  }
}
~~~


# Changelog

## Changes since -??
