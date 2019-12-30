---
date: 2019-12-30
title: "JSON serialization for Web Linking"
docname: draft-pot-json-link-00
category: std
author:
 -
    ins: E. Pot
    name: Evert Pot
    email: me@evertpot.com
    uri: https://evertpot.com/
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

--- abstract

This specification defines a serialization of Web Linking {{RFC8288}} in the
JSON {{RFC8259}} format.

--- middle

# Introduction

There are many JSON-based standards and formats that require the need to
express a link. Examples can be found in {{draft-kelly-json-hal}}, {{JSON-API}},
{{WEBTHING}}, {{draft-nottingham-json-home}}, {{COLLECTIONJSON}}, {{SIREN}} 
and many others.

Typically when new formats requiring links are defined, there is no common
reference to build on. This often results in minor differences between
serializations making it difficult to write generic parsers.

This document is an attempt to define a standard JSON serialization for
Web linking. A primary goal is to define a format that's relatively
uncontroversial.

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

If the link appears in a list of links (defined in {{list}}), and the list
contains a link with relation type 'self', the target of the self link MUST
be used as the default link context.

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

A common example of this are documents that have a concept of "embedded
resources". When a representation is a compound document, the default link
context might refer to the URI of the sub-resource that is being embedded.

### Extension Attributes

Similar to {{RFC8288}}, other documents may define new target attributes
for links. Parsers that don't understand any attributes appearing on a link
MUST ignore them.

### Example

This section is non-normative

```json
{
  "href": "https://evertpot.com/",
  "rel": "author",
  "title": "Evert Pot"
}
```

## Lists of links {#list}

A list of links defined as a JSON array of one or more link objects.


### Example

```json
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
```

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

```json
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
```

# IANA considerations

We would like to register the 'application/links+json' media-type for documents
wishing to implement this spec.

TBD?

--- back

# Typescript definitions

TBD

# JSON-SCHEMA definitions

TBD

# Changelog

## Changes since -??
