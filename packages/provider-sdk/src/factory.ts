import type { ProviderName } from '@smart-inbox/domain';
import type { MailProviderAdapter } from './contracts/mail-provider-adapter';
import { GmailAdapter } from './adapters/gmail/gmail.adapter';

export function createProviderAdapter(provider: ProviderName): MailProviderAdapter {
  switch (provider) {
    case 'gmail':
      return new GmailAdapter();
    default:
      throw new Error(`Provider not implemented: ${provider}`);
  }
}
