import express from 'express';
import { CursoController } from '../controllers/curso.controller';
import asyncHandler from 'express-async-handler';
import { permitir } from '../middlewares/permissao.middleware';

export const cursoRoutes = express.Router();

cursoRoutes.get('/cursos', permitir('aluno', 'professor', 'admin'), asyncHandler(CursoController.getAll));
cursoRoutes.get('/cursos/:id', permitir('aluno', 'professor', 'admin'), asyncHandler(CursoController.getById));
cursoRoutes.post('/cursos', permitir('professor', 'admin'), asyncHandler(CursoController.save));
cursoRoutes.put('/cursos/:id', permitir('professor', 'admin'), asyncHandler(CursoController.update));
cursoRoutes.delete('/cursos/:id', permitir('admin'), asyncHandler(CursoController.delete));