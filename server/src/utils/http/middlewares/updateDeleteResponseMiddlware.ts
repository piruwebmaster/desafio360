import { ProblemDetails } from '@products/types';
import { NextFunction, Request, Response } from 'express';

export const updateDeleteResponseMiddleware = function (_req: Request, res: Response, next: NextFunction) {
    const originalJson = res.json;
    res.json = (body: any)=>{
      console.log({body : body});
      if(body instanceof Object && 'success' in body){
        console.log(body.success)
        if(body.success === true){
          const res2 = res.status(204)
          return originalJson.call(res2)
        }
        else{
          const res2 = res.status(400)
          const { errorMsg } = body
          const problem: ProblemDetails ={
              title: "Error",
              detail: errorMsg
          }
          return originalJson.call(res2, problem as object)
        } 
      }
      return originalJson.call(res, body)
    }
  
    next();
  };
  