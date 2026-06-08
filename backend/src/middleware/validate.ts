import { Request, Response, NextFunction } from 'express';
import { ZodSchema, ZodError } from 'zod';
import { errorResponse } from '../shared/utils';

export function validate(schema: ZodSchema, source: 'body' | 'query' | 'params' = 'body') {
  return (req: Request, res: Response, next: NextFunction): void => {
    try {
      const data = schema.parse(req[source]);
      req[source] = data;
      next();
    } catch (err) {
      if (err instanceof ZodError) {
        const messages = err.issues.map((e: any) => `${e.path.join('.')}: ${e.message}`).join('; ');
        res.status(400).json(errorResponse(messages));
        return;
      }
      next(err);
    }
  };
}
