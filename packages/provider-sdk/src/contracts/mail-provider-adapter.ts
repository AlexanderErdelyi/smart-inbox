import type { Message, Thread } from '@smart-inbox/domain';

export interface ProviderProfile {
  emailAddress: string;
  displayName?: string;
}

export interface MessagePage {
  items: Message[];
  nextCursor?: string;
}

export interface ThreadPage {
  items: Thread[];
  nextCursor?: string;
}

export interface RawMessage {
  provider: string;
  payload: unknown;
}

export interface WatchHandle {
  id: string;
  expiresAt?: string;
}

export interface MailProviderAdapter {
  getProfile(accountId: string): Promise<ProviderProfile>;
  listMessages(accountId: string, cursor?: string): Promise<MessagePage>;
  getMessage(accountId: string, externalMessageId: string): Promise<RawMessage>;
  listThreads(accountId: string, cursor?: string): Promise<ThreadPage>;
  applyLabels(accountId: string, externalMessageId: string, labels: string[]): Promise<void>;
  archiveMessage(accountId: string, externalMessageId: string): Promise<void>;
  watchMailbox(accountId: string): Promise<WatchHandle>;
}
