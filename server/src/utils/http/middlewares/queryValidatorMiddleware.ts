import { ProblemDetails } from '@products/types';
import { NextFunction, Request, Response } from 'express';
import z, { ZodSchema } from 'zod';

// Define the validation middleware
const queryValidatorMiddleware = <T>(schema: ZodSchema<T>) => {
  type schemaType = z.infer<typeof schema>;
  return function (req: Request<any, any, any, schemaType>, res: Response, next: NextFunction) {
    const { error, data } = schema.safeParse(req.query);

    if (error) {
      const mapped = error.issues.flatMap(e => {
        const entries = e.path.map(p => {
          return [`${p}`, e.message ?? ''];
        });
        return entries;
      });
      // If validation fails, send a 400 Bad Request response with validation errors
      const problem : ProblemDetails  = {
        title: "Invalid query params",
        detail: "Check validations properties of response",
        validations: Object.fromEntries(mapped)
      }  
      res.status(400).json(problem);
      return
    }

    // If validation passes, attach the validated values to req.query
    req.query = data;

    // Proceed to the next middleware or route handler
    next();
  };
};

export { queryValidatorMiddleware }


