import express from 'express';
import { MatriculaController } from '../controllers/matricula.controller';
import asyncHandler from 'express-async-handler';
import { permitir } from '../middlewares/permissao.middleware';

export const matriculaRoutes = express.Router();

matriculaRoutes.get('/matriculas', permitir('aluno', 'professor', 'admin'), asyncHandler(MatriculaController.getAll));
matriculaRoutes.get('/matriculas/:id', permitir('aluno', 'professor', 'admin'), asyncHandler(MatriculaController.getById));
matriculaRoutes.post('/matriculas', permitir('admin'), asyncHandler(MatriculaController.save));
matriculaRoutes.delete('/matriculas/:id', permitir('admin'), asyncHandler(MatriculaController.delete));