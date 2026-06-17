import { randomBytes, createHash } from 'crypto';
const token = randomBytes(32).toString('hex');
const tokenHash = createHash('sha256').update(token).digest('hex');
console.log('token=' + token);
console.log('tokenHash=' + tokenHash);
