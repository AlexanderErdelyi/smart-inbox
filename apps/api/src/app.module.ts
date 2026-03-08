import { Module } from '@nestjs/common';
import { HealthModule } from './health/health.module';
import { AuthModule } from './auth/auth.module';
import { ProvidersModule } from './providers/providers.module';
import { EmailsModule } from './emails/emails.module';
import { SyncModule } from './sync/sync.module';
import { IntelligenceModule } from './intelligence/intelligence.module';

@Module({
  imports: [HealthModule, AuthModule, ProvidersModule, EmailsModule, SyncModule, IntelligenceModule],
})
export class AppModule {}
