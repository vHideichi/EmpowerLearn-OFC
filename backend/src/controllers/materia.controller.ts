import { Request, Response, NextFunction } from 'express';
import { MateriaService } from '../services/materia.service';
import { parseId } from '../utils/parse-id';

export class MateriaController {
  static async getAll(req: Request, res: Response, next: NextFunction) {
    try {
      const cursoIdQuery = req.query.cursoId;

      let cursoId: number | undefined;

      if (cursoIdQuery !== undefined) {
        const parsedCursoId = Number(cursoIdQuery);

        if (!Number.isInteger(parsedCursoId) || parsedCursoId <= 0) {
          return res.status(400).send({
            message: 'cursoId inválido',
          });
        }

        cursoId = parsedCursoId;
      }

      const materias = await new MateriaService().getAll(cursoId);

      return res.send(materias);
    } catch (error) {
      return next(error);
    }
  }

  static async getById(req: Request, res: Response, next: NextFunction) {
    try {
      const id = parseId(req);
      const materia = await new MateriaService().getById(id);

      return res.send(materia);
    } catch (error) {
      return next(error);
    }
  }

  static async save(req: Request, res: Response, next: NextFunction) {
    try {
      const materia = await new MateriaService().save(req.body);

      return res.status(201).send(materia);
    } catch (error) {
      return next(error);
    }
  }

  static async update(req: Request, res: Response, next: NextFunction) {
    try {
      const id = parseId(req);
      const materia = await new MateriaService().update(id, req.body);

      return res.send(materia);
    } catch (error) {
      return next(error);
    }
  }

  static async delete(req: Request, res: Response, next: NextFunction) {
    try {
      const id = parseId(req);
      await new MateriaService().delete(id);

      return res.status(204).end();
    } catch (error) {
      return next(error);
    }
  }
}