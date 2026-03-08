import { runMailSyncJob } from './jobs/mail-sync.job';

const queueName = process.env.QUEUE_NAME || 'mail-sync';

console.log(`[worker] smart inbox worker booted for queue: ${queueName}`);
runMailSyncJob('bootstrap-check');
