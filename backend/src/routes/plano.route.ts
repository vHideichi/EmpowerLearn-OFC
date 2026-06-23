import express from 'express';
import { PlanoController } from '../controllers/plano.controller';
import asyncHandler from 'express-async-handler';
import { permitir } from '../middlewares/permissao.middleware';

export const planoRoutes = express.Router();

planoRoutes.get('/planos', permitir('aluno', 'professor', 'admin'), asyncHandler(PlanoController.getAll));
planoRoutes.get('/planos/:id', permitir('aluno', 'professor', 'admin'), asyncHandler(PlanoController.getById));
planoRoutes.post('/planos', permitir('admin'), asyncHandler(PlanoController.save));
planoRoutes.put('/planos/:id', permitir('admin'), asyncHandler(PlanoController.update));
planoRoutes.delete('/planos/:id', permitir('admin'), asyncHandler(PlanoController.delete));