# Smart Inbox

Provider-agnostic AI-powered mail organizer. The first provider is Gmail, but the architecture is designed to support Outlook and IMAP-based providers without rewriting core logic.

## Tech Baseline

- Language: TypeScript (frontend, backend, shared packages)
- Frontend: React + Next.js
- API: NestJS
- Worker: Node.js TypeScript process
- Data: PostgreSQL
- Queues: Redis

## Repository Structure

- `apps/web`: Next.js frontend
- `apps/api`: NestJS API
- `apps/worker`: background jobs
- `packages/domain`: normalized mail domain models
- `packages/provider-sdk`: provider adapter contracts + adapters
- `packages/ai`: AI abstraction layer
- `packages/config`: shared config exports
- `docs`: architecture and setup docs

## Local Setup

1. Install dependencies:

```bash
npm install
```

2. Start local infra:

```bash
docker compose up -d
```

3. Start all apps:

```bash
npm run dev
```

## Current Status

This is a scaffold baseline with:
- provider-agnostic contracts
- Gmail adapter skeleton
- API module boundaries
- worker bootstrap
- CI starter workflow

Next implementation milestone: wire real Google OAuth + Gmail sync pipeline.
