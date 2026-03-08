export type ProviderName = 'gmail' | 'outlook' | 'imap';

export interface MailboxAccount {
  id: string;
  userId: string;
  provider: ProviderName;
  providerAccountId: string;
  emailAddress: string;
  connectedAt: string;
}

export interface Message {
  id: string;
  mailboxAccountId: string;
  externalMessageId: string;
  externalThreadId?: string;
  subject: string;
  from: string;
  to: string[];
  snippet?: string;
  textBody?: string;
  htmlBody?: string;
  sentAt: string;
  receivedAt: string;
  tags: string[];
  folder?: string;
}

export interface Thread {
  id: string;
  mailboxAccountId: string;
  externalThreadId: string;
  subject?: string;
  messageIds: string[];
}

export interface Label {
  id: string;
  mailboxAccountId: string;
  externalLabelId?: string;
  name: string;
  color?: string;
}

export interface SyncCursor {
  mailboxAccountId: string;
  cursor: string;
  syncedAt: string;
}

export type ClassificationCategory =
  | 'important'
  | 'newsletter'
  | 'promotion'
  | 'personal'
  | 'other';

export interface Classification {
  messageId: string;
  category: ClassificationCategory;
  confidence: number;
  reasons: string[];
}

export interface SuggestedAction {
  messageId: string;
  action: 'label' | 'archive' | 'mark_read' | 'draft_reply';
  payload: Record<string, string | number | boolean>;
  confidence: number;
}
