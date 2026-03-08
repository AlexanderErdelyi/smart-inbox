# Gmail Setup (Placeholder)

1. Create a Google Cloud project.
2. Enable Gmail API.
3. Create OAuth credentials.
4. Set redirect URI to `http://localhost:3001/auth/google/callback`.
5. Add env vars in `apps/api/.env`:
   - `GOOGLE_CLIENT_ID`
   - `GOOGLE_CLIENT_SECRET`

Recommended scopes should stay least-privilege and be documented before production usage.
