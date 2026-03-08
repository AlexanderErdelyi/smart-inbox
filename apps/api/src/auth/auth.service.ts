import { Injectable } from '@nestjs/common';

@Injectable()
export class AuthService {
  getStatus() {
    return { provider: 'google', status: 'not-configured' };
  }
}
