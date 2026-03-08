import { Injectable } from '@nestjs/common';

@Injectable()
export class IntelligenceService {
  classifyPreview(_messageBody: string) {
    return {
      category: 'other',
      confidence: 0,
    };
  }
}
