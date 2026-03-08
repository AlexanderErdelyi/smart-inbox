import type {
  MailProviderAdapter,
  MessagePage,
  ProviderProfile,
  RawMessage,
  ThreadPage,
  WatchHandle,
} from '../../contracts/mail-provider-adapter';

export class GmailAdapter implements MailProviderAdapter {
  async getProfile(_accountId: string): Promise<ProviderProfile> {
    return {
      emailAddress: 'placeholder@gmail.com',
      displayName: 'Gmail User',
    };
  }

  async listMessages(_accountId: string, _cursor?: string): Promise<MessagePage> {
    return { items: [] };
  }

  async getMessage(_accountId: string, externalMessageId: string): Promise<RawMessage> {
    return {
      provider: 'gmail',
      payload: { externalMessageId },
    };
  }

  async listThreads(_accountId: string, _cursor?: string): Promise<ThreadPage> {
    return { items: [] };
  }

  async applyLabels(_accountId: string, _externalMessageId: string, _labels: string[]): Promise<void> {
    return;
  }

  async archiveMessage(_accountId: string, _externalMessageId: string): Promise<void> {
    return;
  }

  async watchMailbox(_accountId: string): Promise<WatchHandle> {
    return {
      id: 'gmail-watch-placeholder',
    };
  }
}
