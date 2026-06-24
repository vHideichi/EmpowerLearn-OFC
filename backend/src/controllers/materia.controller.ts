import { Request, Response, NextFunction } from 'express';
import { MateriaService } from '../services/materia.service';
import { parseId } from '../utils/parse-id';

export class MateriaController {
  static async getAll(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const cursoIdQuery = req.query.cursoId;

      let cursoId: number | undefined;

      if (cursoIdQuery !== undefined) {
        const parsedCursoId = Number(cursoIdQuery);

        if (!Number.isInteger(parsedCursoId) || parsedCursoId <= 0) {
          res.status(400).send({
            message: 'cursoId inválido',
          });
          return;
        }

        cursoId = parsedCursoId;
      }

      const materias = await new MateriaService().getAll(cursoId);

      res.send(materias);
    } catch (error) {
      next(error);
    }
  }

  static async getById(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const id = parseId(req);
      const materia = await new MateriaService().getById(id);

      res.send(materia);
    } catch (error) {
      next(error);
    }
  }

  static async save(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const materia = await new MateriaService().save(req.body);

      res.status(201).send(materia);
    } catch (error) {
      next(error);
    }
  }

  static async update(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const id = parseId(req);
      const materia = await new MateriaService().update(id, req.body);

      res.send(materia);
    } catch (error) {
      next(error);
    }
  }

  static async delete(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const id = parseId(req);
      await new MateriaService().delete(id);

      res.status(204).end();
    } catch (error) {
      next(error);
    }
  }
}