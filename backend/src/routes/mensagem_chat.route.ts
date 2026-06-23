import express from 'express';
import { MensagemChatController } from '../controllers/mensagem_chat.controller';
import asyncHandler from 'express-async-handler';
import { permitir } from '../middlewares/permissao.middleware';

export const mensagemRoutes = express.Router();

mensagemRoutes.get('/mensagens', permitir('aluno', 'professor', 'admin'), asyncHandler(MensagemChatController.getAll));
mensagemRoutes.get('/mensagens/:id', permitir('aluno', 'professor', 'admin'), asyncHandler(MensagemChatController.getById));
mensagemRoutes.post('/mensagens', permitir('aluno', 'professor', 'admin'), asyncHandler(MensagemChatController.save));
mensagemRoutes.put('/mensagens/:id', permitir('aluno', 'professor', 'admin'), asyncHandler(MensagemChatController.update));
mensagemRoutes.delete('/mensagens/:id', permitir('aluno', 'professor', 'admin'), asyncHandler(MensagemChatController.delete));