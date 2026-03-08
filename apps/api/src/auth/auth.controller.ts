import { Controller, Get } from '@nestjs/common';

@Controller('auth')
export class AuthController {
  @Get('google/start')
  startGoogleOAuth() {
    return { message: 'Google OAuth start endpoint placeholder' };
  }
}
