# Architecture

Smart Inbox is Gmail-first but provider-agnostic.

Core flow:
Provider Adapter -> Normalized Domain Model -> Intelligence Engine -> Suggested/Executed Actions

Boundaries:
- Provider-specific code belongs only in `packages/provider-sdk/src/adapters/*`.
- API modules consume adapter contracts, never provider SDKs directly.
- Shared entity contracts belong in `packages/domain`.
