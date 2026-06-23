import express from 'express';
import { ProgressoMateriaController } from '../controllers/progresso_materia.controller';
import asyncHandler from 'express-async-handler';
import { permitir } from '../middlewares/permissao.middleware';

export const progressoRoutes = express.Router();

progressoRoutes.get('/progressos', permitir('aluno', 'professor', 'admin'), asyncHandler(ProgressoMateriaController.getAll));
progressoRoutes.get('/progressos/:id', permitir('aluno', 'professor', 'admin'), asyncHandler(ProgressoMateriaController.getById));
progressoRoutes.post('/progressos', permitir('aluno'), asyncHandler(ProgressoMateriaController.save));
progressoRoutes.delete('/progressos/:id', permitir('admin'), asyncHandler(ProgressoMateriaController.delete));