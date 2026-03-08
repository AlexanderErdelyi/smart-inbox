import { Injectable } from '@nestjs/common';

@Injectable()
export class ProvidersService {
  listSupportedProviders(): string[] {
    return ['gmail'];
  }
}
