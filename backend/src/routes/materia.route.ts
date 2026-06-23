import express from 'express';
import { MateriaController } from '../controllers/materia.controller';
import asyncHandler from 'express-async-handler';
import { permitir } from '../middlewares/permissao.middleware';

export const materiaRoutes = express.Router();

materiaRoutes.get('/materias', permitir('aluno', 'professor', 'admin'), asyncHandler(MateriaController.getAll));
materiaRoutes.get('/materias/:id', permitir('aluno', 'professor', 'admin'), asyncHandler(MateriaController.getById));
materiaRoutes.post('/materias', permitir('professor', 'admin'), asyncHandler(MateriaController.save));
materiaRoutes.put('/materias/:id', permitir('professor', 'admin'), asyncHandler(MateriaController.update));
materiaRoutes.delete('/materias/:id', permitir('admin'), asyncHandler(MateriaController.delete));