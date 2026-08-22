# 8. Compliance statements

| Field | Value |
|---|---|
| Document type | User manual, Clause 8 |
| Part of | [Index](index.md) |

## 8.1 Statement level

IDERM is not represented by this manual as certified to an IEEE, IEC, ISO, or
other management or product standard. The software is not represented as CE
marked. Standards-style language and document structure do not constitute
certification or regulatory conformity.

## 8.2 Referenced formats

The VCD reader targets selected syntax associated with IEEE 1364 and IEEE
1800. It is a partial operational reader, not a certified standards-conformance
implementation. The analog CSV format is a project convention, not a claimed
complete RFC 4180 implementation.

## 8.3 Data processing

Core performs local project scanning. It does not implement telemetry. It does
not initiate network access during startup or normal local operation.

External commands may access the network. This includes user-declared tasks,
LSP servers, editors, capture bridges, and the command named by
`.iderm/ai.toml`. Their data processing is outside Core's control.

## 8.4 Licensing

Core uses the SPDX expression `MIT OR Apache-2.0`. Dependency and plugin terms
remain independent. Clause 10 specifies license locations and scope.

## 8.5 Regulated use

The user shall perform the validation required by the applicable domain before
using IDERM output in regulated engineering, safety, medical, automotive,
aerospace, industrial-control, or compliance decisions.

Doctor findings, parser output, visualizations, and AI explanations are aids.
They are not approvals, certificates, calibration results, or legal opinions.

## 8.6 Publication placeholders

The following evidence is not yet part of this manual:

- [PLACEHOLDER: software bill of materials for a named release]
- [PLACEHOLDER: signed release provenance]
- [PLACEHOLDER: formal data protection assessment, if distribution requires it]

Vulnerability disclosure contact and response policy: see `SECURITY.md` at
the project root.
