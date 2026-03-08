# Contributing

## Local Setup
- Install Node.js 20+
- Run `npm install`
- Start infrastructure with `docker compose up -d`

## Commands
- `npm run dev`
- `npm run lint`
- `npm run typecheck`
- `npm run build`

## Adding a New Provider
1. Implement `MailProviderAdapter` in `packages/provider-sdk/src/adapters/<provider>/`.
2. Register adapter in factory.
3. Add mapping tests for normalized models.
4. Expose capabilities via API before enabling UI features.
