---
name: add-bank-support
description: Use this skill when the user provides one or more SMS samples and asks to add support for a bank or a new message format from an already supported bank.
---

# Add Bank Support

Use this skill when the user provides SMS samples and asks for bank support.

## Rule

Support only the exact sender ID and exact message body pattern provided. Do not guess extra formats.

## Workflow

1. Check whether the sender is already supported in `lib/src/utils/sms_helpers.dart`.
2. Inspect the current extractor style in `lib/src/bank_support/extractors/` and the wiring in `lib/src/shared/providers/sms_providers.dart`.
3. Compare the new sample with the closest existing parser.

## New sender

Add a new sender key, create a new extractor, wire it into `sms_providers.dart`, and add focused tests for the sample.

## Existing sender

Update the existing extractor only. Keep older message formats working and add a regression test for the new sample.

## Implementation rules

- Keep parsing narrow and explicit.
- Do not invent missing fields.
- Fail safely by skipping messages that do not match the provided sample.
