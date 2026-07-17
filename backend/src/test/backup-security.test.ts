import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest';
import { execFile } from 'child_process';
import path from 'path';
import fs from 'fs';

const mockBackupDir = vi.hoisted(() => 'C:\\test\\backups');
const mockExistsSync = vi.hoisted(() => vi.fn());
const mockStatSync = vi.hoisted(() => vi.fn());
const mockUnlinkSync = vi.hoisted(() => vi.fn());
const mockRealpathSync = vi.hoisted(() => vi.fn());
const mockList = vi.hoisted(() => vi.fn());
const mockStore = vi.hoisted(() => vi.fn());
const mockDelete = vi.hoisted(() => vi.fn());
const mockGetStream = vi.hoisted(() => vi.fn());
const mockGetPath = vi.hoisted(() => vi.fn());

vi.mock('child_process', () => ({
  execFile: vi.fn(),
}));

vi.mock('../config/env', () => ({
  env: {
    DB_HOST: 'localhost',
    DB_PORT: 5432,
    DB_NAME: 'ethics_db',
    DB_USER: 'ethics_app',
    DB_PASSWORD: 'postgres',
    BACKUP_DIR: mockBackupDir,
    PG_BIN_PATH: '',
    DATABASE_URL: '',
  },
}));

vi.mock('../config/logger', () => ({
  logger: {
    info: vi.fn(),
    warn: vi.fn(),
    error: vi.fn(),
  },
}));

vi.mock('../services/backup-destination', () => ({
  createBackupDestination: () => ({
    list: mockList,
    store: mockStore,
    retrieve: vi.fn(),
    delete: mockDelete,
    getStream: mockGetStream,
    getPath: mockGetPath,
  }),
  BackupFile: {} as any,
}));

vi.mock('fs', () => {
  const mockFn = () => vi.fn();
  const mocks = {
    existsSync: mockExistsSync,
    statSync: mockStatSync,
    unlinkSync: mockUnlinkSync,
    readdirSync: mockFn(),
    copyFileSync: mockFn(),
    createReadStream: mockFn(),
    mkdirSync: mockFn(),
    realpathSync: mockRealpathSync,
  };
  return { ...mocks, default: mocks };
});

import { BackupService, ValidationError, FileNotFoundError, ExecutionError, TimeoutError, BackupIntegrityError, PermissionError } from '../services/backup.service';

function makeMockExecFile(exitCode = 0, stdout = '', stderr = '') {
  vi.mocked(execFile).mockImplementation(((_cmd: string, _args: readonly string[], _options: any, callback?: any) => {
    if (callback) {
      if (exitCode !== 0) {
        const err: any = new Error(stderr || `Exit code ${exitCode}`);
        err.code = exitCode;
        err.stdout = stdout;
        err.stderr = stderr;
        callback(err, stdout, stderr);
      } else {
        callback(null, stdout, stderr);
      }
    }
    return { on: vi.fn(), killed: false, signal: null } as any;
  }) as any);
}

function makeTimeoutExecFile() {
  vi.mocked(execFile).mockImplementation(((_cmd: string, _args: readonly string[], _options: any, callback?: any) => {
    if (callback) {
      const err: any = new Error('Command timed out');
      err.killed = true;
      err.signal = 'SIGTERM';
      err.code = null;
      err.stdout = '';
      err.stderr = 'timeout occurred';
      callback(err, '', 'timeout occurred');
    }
    return { on: vi.fn(), killed: true, signal: 'SIGTERM' } as any;
  }) as any);
}

function makeEnoentExecFile() {
  vi.mocked(execFile).mockImplementation(((_cmd: string, _args: readonly string[], _options: any, callback?: any) => {
    if (callback) {
      const err: any = new Error('ENOENT');
      err.code = 'ENOENT';
      err.stdout = '';
      err.stderr = '';
      callback(err, '', '');
    }
    return { on: vi.fn(), killed: false, signal: null } as any;
  }) as any);
}

function makeEaccesExecFile() {
  vi.mocked(execFile).mockImplementation(((_cmd: string, _args: readonly string[], _options: any, callback?: any) => {
    if (callback) {
      const err: any = new Error('EACCES');
      err.code = 'EACCES';
      err.stdout = '';
      err.stderr = '';
      callback(err, '', '');
    }
    return { on: vi.fn(), killed: false, signal: null } as any;
  }) as any);
}

describe('BackupService', () => {
  let service: BackupService;

  beforeEach(() => {
    vi.clearAllMocks();
    mockGetPath.mockImplementation((name: string) => {
      if (!name.endsWith('.dump')) throw new Error('Invalid backup file (must be .dump)');
      return path.join(mockBackupDir, name);
    });
    mockList.mockResolvedValue([]);
    mockStore.mockResolvedValue('stored');
    mockExistsSync.mockReturnValue(true);
    mockStatSync.mockReturnValue({ size: 1024, mtime: new Date() } as any);
    mockRealpathSync.mockImplementation(((p: any) => p) as any);
    mockDelete.mockResolvedValue(undefined);
    mockGetStream.mockReturnValue({ pipe: vi.fn() } as any);
    service = new BackupService();
  });

  afterEach(() => {
    vi.resetAllMocks();
  });

  describe('1. Backup name validation', () => {
    it('accepts valid backup name', () => {
      expect(() => (service as any).validateName('test_backup-2026-07-13.dump')).not.toThrow();
    });

    it('rejects empty name', () => {
      expect(() => (service as any).validateName('')).toThrow(ValidationError);
    });

    it('rejects null name', () => {
      expect(() => (service as any).validateName(null as any)).toThrow(ValidationError);
    });

    it('rejects name without .dump extension', () => {
      expect(() => (service as any).validateName('test.txt')).toThrow(ValidationError);
    });

    it('rejects name with spaces', () => {
      expect(() => (service as any).validateName('test backup.dump')).toThrow(ValidationError);
    });

    it('rejects name with semicolon injection', () => {
      expect(() => (service as any).validateName('test; rm -rf /.dump')).toThrow(ValidationError);
    });

    it('rejects name with backtick injection', () => {
      expect(() => (service as any).validateName('test`whoami`.dump')).toThrow(ValidationError);
    });

    it('rejects name with $() command substitution', () => {
      expect(() => (service as any).validateName('test$(calc.exe).dump')).toThrow(ValidationError);
    });

    it('rejects name with pipe injection', () => {
      expect(() => (service as any).validateName('test|whoami.dump')).toThrow(ValidationError);
    });

    it('rejects name with redirect injection', () => {
      expect(() => (service as any).validateName('test>out.dump')).toThrow(ValidationError);
    });

    it('rejects name with path traversal', () => {
      expect(() => (service as any).validateName('..\\..\\etc\\passwd.dump')).toThrow(ValidationError);
    });

    it('rejects name with ampersand', () => {
      expect(() => (service as any).validateName('test&&whoami.dump')).toThrow(ValidationError);
    });

    it('rejects name with newline', () => {
      expect(() => (service as any).validateName("test\nwhoami.dump")).toThrow(ValidationError);
    });

    it('rejects name longer than 128 chars', () => {
      const longName = 'a'.repeat(129) + '.dump';
      expect(() => (service as any).validateName(longName)).toThrow(ValidationError);
    });

    it('accepts name exactly 128 chars', () => {
      const exactName = 'a'.repeat(123) + '.dump';
      expect(() => (service as any).validateName(exactName)).not.toThrow();
    });

    it('rejects name with forward slash', () => {
      expect(() => (service as any).validateName('sub/dir/backup.dump')).toThrow(ValidationError);
    });

    it('rejects name with backslash', () => {
      expect(() => (service as any).validateName('sub\\dir\\backup.dump')).toThrow(ValidationError);
    });
  });

  describe('2. Structured errors', () => {
    it('ValidationError has correct code', () => {
      const err = new ValidationError('test');
      expect(err.code).toBe('VALIDATION_ERROR');
      expect(err.name).toBe('ValidationError');
    });

    it('ExecutionError has correct code', () => {
      const err = new ExecutionError('failed');
      expect(err.code).toBe('EXECUTION_ERROR');
    });

    it('TimeoutError has correct code', () => {
      const err = new TimeoutError('timed out');
      expect(err.code).toBe('TIMEOUT_ERROR');
    });

    it('FileNotFoundError has correct code', () => {
      const err = new FileNotFoundError('not found');
      expect(err.code).toBe('FILE_NOT_FOUND');
    });

    it('BackupIntegrityError has correct code', () => {
      const err = new BackupIntegrityError('integrity issue');
      expect(err.code).toBe('BACKUP_INTEGRITY_ERROR');
    });

    it('PermissionError has correct code', () => {
      const err = new PermissionError('permission');
      expect(err.code).toBe('PERMISSION_ERROR');
    });
  });

  describe('3. execFile replaces exec', () => {
    it('create() uses execFile with proper args', async () => {
      makeMockExecFile(0, '');
      const result = await service.create('test-label');
      expect(result).toBeDefined();
      expect(result.name).toContain('test-label');
      expect(vi.mocked(execFile)).toHaveBeenCalled();
      const callArgs = vi.mocked(execFile).mock.calls[0];
      expect(callArgs[0]).toBe('pg_dump');
      expect(Array.isArray(callArgs[1])).toBe(true);
      expect(callArgs[1]).toContain('-Fc');
      expect(callArgs[1]).toContain('-f');
    });

    it('list() does not call execFile (uses destination)', async () => {
      mockList.mockResolvedValue([{ name: 'test.dump', size: 1024, created_at: new Date().toISOString() }]);
      const result = await service.list();
      expect(result).toHaveLength(1);
      expect(vi.mocked(execFile)).not.toHaveBeenCalled();
    });

    it('delete() calls validateName before destination delete', async () => {
      await service.delete('test.dump');
      expect(mockDelete).toHaveBeenCalledWith('test.dump');
    });

    it('delete() rejects injection name', async () => {
      await expect(service.delete('test; rm -rf /.dump')).rejects.toThrow(ValidationError);
      expect(mockDelete).not.toHaveBeenCalled();
    });
  });

  describe('4. Credential masking', () => {
    it('maskCredentials hides password in text', () => {
      const masked = (service as any).maskCredentials('Error: password "postgres" failed');
      expect(masked).not.toContain('postgres');
      expect(masked).toContain('***');
    });

    it('maskCredentials handles null input', () => {
      expect((service as any).maskCredentials(null)).toBeNull();
    });

    it('maskCredentials handles undefined input', () => {
      expect((service as any).maskCredentials(undefined)).toBeUndefined();
    });

    it('maskCredentials handles empty string', () => {
      expect((service as any).maskCredentials('')).toBe('');
    });
  });

  describe('5. Temporary file cleanup', () => {
    it('cleanupTempFile removes file if exists', () => {
      mockExistsSync.mockReturnValue(true);
      (service as any).cleanupTempFile('/tmp/test.dump');
      expect(mockUnlinkSync).toHaveBeenCalledWith('/tmp/test.dump');
    });

    it('cleanupTempFile does not throw if file not found', () => {
      mockExistsSync.mockReturnValue(false);
      expect(() => (service as any).cleanupTempFile('/tmp/test.dump')).not.toThrow();
      expect(mockUnlinkSync).not.toHaveBeenCalled();
    });
  });

  describe('6. Service methods validate name before any operation', () => {
    it('restore rejects injection name before pre-backup dump', async () => {
      await expect(service.restore('test$(calc).dump')).rejects.toThrow(ValidationError);
      expect(vi.mocked(execFile)).not.toHaveBeenCalled();
    });

    it('verify rejects injection name', async () => {
      await expect(service.verify('test; whoami.dump')).rejects.toThrow(ValidationError);
      expect(vi.mocked(execFile)).not.toHaveBeenCalled();
    });

    it('getStream rejects injection name', () => {
      expect(() => service.getStream('test`id`.dump')).toThrow(ValidationError);
    });
  });

  describe('7. rotate() does not use execFile', () => {
    it('rotate with empty list', async () => {
      mockList.mockResolvedValue([]);
      const result = await service.rotate();
      expect(vi.mocked(execFile)).not.toHaveBeenCalled();
      expect(result.deleted).toEqual([]);
      expect(result.kept).toEqual([]);
    });
  });

  describe('8. Error mapping — run() throws typed errors', () => {
    it('throws TimeoutError on killed process', async () => {
      mockGetPath.mockReturnValue(path.join(mockBackupDir, 'test.dump'));
      makeTimeoutExecFile();
      const promise = service.verify('test.dump');
      await expect(promise).rejects.toThrow(TimeoutError);
    });

    it('throws FileNotFoundError when backup file missing', async () => {
      mockGetPath.mockReturnValue(path.join(mockBackupDir, 'test.dump'));
      mockExistsSync.mockReturnValue(false);
      try {
        await service.verify('test.dump');
        expect.unreachable('should have thrown');
      } catch (err: any) {
        expect(err.code).toBe('FILE_NOT_FOUND');
      }
    });

    it('throws FileNotFoundError on ENOENT from execFile', async () => {
      mockGetPath.mockReturnValue(path.join(mockBackupDir, 'test.dump'));
      mockExistsSync.mockReturnValue(true);
      makeEnoentExecFile();
      await expect(service.verify('test.dump')).rejects.toThrow(FileNotFoundError);
    });

    it('throws PermissionError on EACCES', async () => {
      mockGetPath.mockReturnValue(path.join(mockBackupDir, 'test.dump'));
      makeEaccesExecFile();
      const promise = service.verify('test.dump');
      await expect(promise).rejects.toThrow(PermissionError);
    });
  });
});

describe('Backup name route validation schema', () => {
  it('validates backup name at route level', async () => {
    const mod = await import('../modules/admin/backup.routes');
    expect(mod.backupNameSchema.parse('valid_backup-1.dump')).toBe('valid_backup-1.dump');
    expect(() => mod.backupNameSchema.parse('test;rm.dump')).toThrow();
    expect(() => mod.backupNameSchema.parse('test$(ls).dump')).toThrow();
    expect(() => mod.backupNameSchema.parse('test`id`.dump')).toThrow();
    expect(() => mod.backupNameSchema.parse('')).toThrow();
    expect(() => mod.backupNameSchema.parse('a'.repeat(200))).toThrow();
  });
});
