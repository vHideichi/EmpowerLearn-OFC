import { Request, Response, NextFunction } from 'express';
import { ValidationError } from '../errors/validation.error';

export function permitir(...tipos: string[]) {
    return (req: Request, res: Response, next: NextFunction) => {
        const userTipo = (req as any).userTipo;
        if (!tipos.includes(userTipo)) {
            return res.status(403).send({ message: 'Acesso negado' });
        }
        next();
    };
}