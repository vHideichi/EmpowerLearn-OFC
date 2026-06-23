import express from 'express';
import { NotificacaoController } from '../controllers/notificacao.controller';
import asyncHandler from 'express-async-handler';
import { permitir } from '../middlewares/permissao.middleware';

export const notificacaoRoutes = express.Router();

notificacaoRoutes.get('/notificacoes', permitir('aluno', 'professor', 'admin'), asyncHandler(NotificacaoController.getAll));
notificacaoRoutes.get('/notificacoes/:id', permitir('aluno', 'professor', 'admin'), asyncHandler(NotificacaoController.getById));
notificacaoRoutes.post('/notificacoes', permitir('professor', 'admin'), asyncHandler(NotificacaoController.save));
notificacaoRoutes.put('/notificacoes/:id', permitir('admin'), asyncHandler(NotificacaoController.update));
notificacaoRoutes.delete('/notificacoes/:id', permitir('admin'), asyncHandler(NotificacaoController.delete));