import express from 'express';
import { SubmissaoController } from '../controllers/submissao.controller';
import asyncHandler from 'express-async-handler';
import { permitir } from '../middlewares/permissao.middleware';

export const submissaoRoutes = express.Router();

submissaoRoutes.get('/submissoes', permitir('professor', 'admin'), asyncHandler(SubmissaoController.getAll));
submissaoRoutes.get('/submissoes/:id', permitir('aluno', 'professor', 'admin'), asyncHandler(SubmissaoController.getById));
submissaoRoutes.post('/submissoes', permitir('aluno'), asyncHandler(SubmissaoController.save));
submissaoRoutes.put('/submissoes/:id', permitir('professor', 'admin'), asyncHandler(SubmissaoController.update));
submissaoRoutes.delete('/submissoes/:id', permitir('admin'), asyncHandler(SubmissaoController.delete));