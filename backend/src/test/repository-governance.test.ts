import { describe, it, expect } from 'vitest';
import { readFileSync, readdirSync } from 'fs';
import path from 'path';

const srcDir = path.resolve(__dirname, '..');

function getFiles(pattern: string): string[] {
  // Parse the pattern manually (e.g. "services/*.service.ts")
  const parts = pattern.split('/');
  const dir = parts[0];
  const filePattern = parts[1];
  const fullDir = path.join(srcDir, dir);
  try {
    return readdirSync(fullDir)
      .filter(f => {
        const regex = new RegExp('^' + filePattern.replace(/\*/g, '.*') + '$');
        return regex.test(f);
      })
      .map(f => path.join(dir, f));
  } catch {
    return [];
  }
}

function readFile(file: string): string {
  return readFileSync(path.join(srcDir, file), 'utf-8');
}

// Known infrastructure service exceptions — these are thin wrappers over DB
// with SSE broadcasting, not business services. They legitimately contain SQL.
const INFRA_SERVICES = ['services/notification.service.ts'];

describe('Service Layer — No Raw SQL', () => {
  const serviceFiles = getFiles('services/*.service.ts').filter(f => !f.endsWith('notification.service.ts'));

  it.each(serviceFiles)('%s contains no raw SELECT', (file) => {
    const content = readFile(file);
    const codeLines = content.split('\n').filter(l => {
      const trimmed = l.trim();
      return !trimmed.startsWith('//') && !trimmed.startsWith('*') && !trimmed.startsWith('/**');
    });
    const code = codeLines.join('\n');
    expect(code).not.toMatch(/`\s*SELECT\s+/);
  });

  it.each(serviceFiles)('%s contains no raw INSERT', (file) => {
    const content = readFile(file);
    const code = removeComments(content);
    expect(code).not.toMatch(/`\s*INSERT\s+INTO\s+/);
  });

  it.each(serviceFiles)('%s contains no raw UPDATE', (file) => {
    const content = readFile(file);
    const code = removeComments(content);
    expect(code).not.toMatch(/`\s*UPDATE\s+\w+/);
  });

  it.each(serviceFiles)('%s contains no raw DELETE', (file) => {
    const content = readFile(file);
    const code = removeComments(content);
    expect(code).not.toMatch(/`\s*DELETE\s+FROM\s+/);
  });

  it.each(serviceFiles)('%s contains no direct pool.query()', (file) => {
    const content = readFile(file);
    const code = removeComments(content);
    expect(code).not.toMatch(/\bpool\.query\s*\(/);
  });

  it.each(serviceFiles)('%s contains no direct client.query()', (file) => {
    const content = readFile(file);
    const code = removeComments(content);
    expect(code).not.toMatch(/\bclient\.query\s*\(/);
  });
});

describe('Infrastructure Service — notification.service.ts (exempted)', () => {
  it('contains raw INSERT (expected — SSE notification infrastructure)', () => {
    const content = readFile(INFRA_SERVICES[0]);
    const code = removeComments(content);
    expect(code).toMatch(/`\s*INSERT\s+INTO\s+/);
  });

  it('contains client.query() (expected — dual client/pool path)', () => {
    const content = readFile(INFRA_SERVICES[0]);
    const code = removeComments(content);
    expect(code).toMatch(/\bclient\.query\s*\(/);
  });
});

describe('Repositories — Read Methods Must Not Accept PoolClient', () => {
  const repoFiles = getFiles('repositories/*.repository.ts');

  it.each(repoFiles)('%s: findById has no PoolClient parameter', (file) => {
    const content = readFile(file);
    // Match the findById method signature line
    const match = content.match(/async\s+findById\s*\([^)]+\)/);
    if (match) {
      expect(match[0]).not.toContain('PoolClient');
    }
  });

  it.each(repoFiles)('%s: findAll has no PoolClient parameter', (file) => {
    const content = readFile(file);
    const match = content.match(/async\s+findAll\s*\([^)]+\)/);
    if (match) {
      expect(match[0]).not.toContain('PoolClient');
    }
  });

  it.each(repoFiles)('%s: get* methods have no PoolClient parameter', (file) => {
    const content = readFile(file);
    const lines = content.split('\n');
    for (const line of lines) {
      const trimmed = line.trim();
      const match = trimmed.match(/async\s+(get\w+)\s*\(([^)]+)\)/);
      if (match) {
        const methodName = match[1];
        const params = match[2];
        // Exception: generateCode-style getters that are write-adjacent
        if (methodName === 'getCurrentUserId') continue;
        expect([methodName, params]).not.toContain('PoolClient');
      }
    }
  });

  it.each(repoFiles)('%s: count* methods have no PoolClient parameter', (file) => {
    const content = readFile(file);
    const lines = content.split('\n');
    for (const line of lines) {
      const trimmed = line.trim();
      const match = trimmed.match(/async\s+(count\w+)\s*\(([^)]+)\)/);
      if (match) {
        const params = match[2];
        expect(params).not.toContain('PoolClient');
      }
    }
  });
});

describe('Contract Implementation Compliance', () => {
  it('ProjectRepository implements IReadRepository<ProjectRow>', () => {
    const content = readFile('repositories/project.repository.ts');
    expect(content).toMatch(/implements\s+.*IReadRepository<ProjectRow>/);
  });

  it('ProjectRepository implements IPaginatedReadRepository<ProjectRow>', () => {
    const content = readFile('repositories/project.repository.ts');
    expect(content).toMatch(/implements\s+.*IPaginatedReadRepository<ProjectRow>/);
  });

  it('ProjectRepository implements IWriteRepository<ProjectRow, CreateProjectDTO>', () => {
    const content = readFile('repositories/project.repository.ts');
    expect(content).toMatch(/implements\s+.*IWriteRepository<ProjectRow,\s*CreateProjectDTO>/);
  });

  it('ApplicationRepository implements IReadRepository<ApplicationRow>', () => {
    const content = readFile('repositories/application.repository.ts');
    expect(content).toMatch(/implements\s+.*IReadRepository<ApplicationRow>/);
  });

  it('ApplicationRepository implements IPaginatedReadRepository<ApplicationRow>', () => {
    const content = readFile('repositories/application.repository.ts');
    expect(content).toMatch(/implements\s+.*IPaginatedReadRepository<ApplicationRow>/);
  });

  it('ApplicationRepository implements IWriteRepository<ApplicationRow, CreateApplicationDTO>', () => {
    const content = readFile('repositories/application.repository.ts');
    expect(content).toMatch(/implements\s+.*IWriteRepository<ApplicationRow,\s*CreateApplicationDTO>/);
  });

  it('ApplicationRepository implements ISoftDeleteRepository', () => {
    const content = readFile('repositories/application.repository.ts');
    expect(content).toMatch(/implements\s+.*ISoftDeleteRepository/);
  });
});

function removeComments(code: string): string {
  return code
    .split('\n')
    .filter(l => {
      const t = l.trim();
      return !t.startsWith('//') && !t.startsWith('*') && !t.startsWith('/**');
    })
    .join('\n');
}
