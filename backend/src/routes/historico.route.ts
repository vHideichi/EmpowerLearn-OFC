import express from 'express';
import { HistoricoController } from '../controllers/historico.controller';
import asyncHandler from 'express-async-handler';
import { permitir } from '../middlewares/permissao.middleware';

export const historicoRoutes = express.Router();

historicoRoutes.get('/historicos', permitir('aluno', 'professor', 'admin'), asyncHandler(HistoricoController.getAll));
historicoRoutes.get('/historicos/:id', permitir('aluno', 'professor', 'admin'), asyncHandler(HistoricoController.getById));
historicoRoutes.post('/historicos', permitir('aluno', 'professor', 'admin'), asyncHandler(HistoricoController.save));
historicoRoutes.delete('/historicos/:id', permitir('admin'), asyncHandler(HistoricoController.delete));