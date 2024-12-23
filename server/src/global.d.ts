import { Request } from 'express';
declare namespace NodeJS {
    interface ProcessEnv {
        PORT: string
        DB_PORT: string
        DB_USERNAME: string
        DB_DBNAME: string
        DB_PASSWORD: string
        DB_SCHEMA: string
        PORT: string
        DB_HOST: string,
        JWT_SECRET: string
        JWT_EXPIRATION_IN_HOURS: string
    }
}


declare global {
  namespace Express {
    interface user {
      id: number,
      role_id: number
    }
    interface Request {
      user?: user;
    }
  }
}