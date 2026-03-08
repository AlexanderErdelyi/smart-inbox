import { Injectable } from '@nestjs/common';

@Injectable()
export class EmailsService {
  getInboxSnapshot() {
    return {
      items: [],
      note: 'Inbox API placeholder wired for adapter-based implementation',
    };
  }
}
