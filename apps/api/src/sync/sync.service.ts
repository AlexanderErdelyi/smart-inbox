import { Injectable } from '@nestjs/common';

@Injectable()
export class SyncService {
  async triggerInitialSync(accountId: string) {
    return { accountId, status: 'queued' };
  }
}
