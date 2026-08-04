/*
 * Composition root — wires resolvers and providers into a single engine. This
 * is the only place that knows about concrete providers. The engine itself
 * stays agnostic; adding a future artifact type only touches this file.
 */
import { VerificationEngine } from './engine';
import { ReferenceResolver } from './resolver';
import { DocumentVerificationProvider } from './providers/document-provider';
import { CertificateVerificationProvider } from './providers/certificate-provider';

export function createVerificationEngine(): VerificationEngine {
  return new VerificationEngine(
    [new ReferenceResolver()],
    [new DocumentVerificationProvider(), new CertificateVerificationProvider()]
  );
}
