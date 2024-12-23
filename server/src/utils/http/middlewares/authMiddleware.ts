import jwt from 'jsonwebtoken'

import { Request, Response, NextFunction } from 'express'


export const validateToken = (req: Request, res: Response, next: NextFunction) => {
    const authHeader = req.headers.authorization;

    if (authHeader) {
        const token = authHeader.split(' ')[1]; // Bearer <token>
        const secretKey = process.env.JWT_SECRET ?? "claveSuperSecreta";
        jwt.verify(token, secretKey, (err, payload) => {
            if (err) {
                return res.status(403).json({
                    success: false,
                    message: 'Invalid token',
                });
            } else {
                console.log(payload)
                req.user = payload as typeof req.user;
                return next();
            }
        });
    } else {
        res.status(401).json({
            success: false,
            message: 'Token is not provided',
        });
    }
};
