export interface AiMessage {
  role: 'system' | 'user' | 'assistant';
  content: string;
}

export interface AiService {
  complete(messages: AiMessage[]): Promise<string>;
}

export class StubAiService implements AiService {
  async complete(messages: AiMessage[]): Promise<string> {
    const latest = messages[messages.length - 1]?.content || '';
    return `stub-response:${latest.slice(0, 80)}`;
  }
}
