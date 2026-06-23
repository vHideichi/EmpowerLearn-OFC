import express from 'express';
import { NotaAlunoController } from '../controllers/nota_aluno.controller';
import asyncHandler from 'express-async-handler';
import { permitir } from '../middlewares/permissao.middleware';

export const notaRoutes = express.Router();

notaRoutes.get('/notas', permitir('aluno', 'professor', 'admin'), asyncHandler(NotaAlunoController.getAll));
notaRoutes.get('/notas/:id', permitir('aluno', 'professor', 'admin'), asyncHandler(NotaAlunoController.getById));
notaRoutes.post('/notas', permitir('professor', 'admin'), asyncHandler(NotaAlunoController.save));
notaRoutes.put('/notas/:id', permitir('professor', 'admin'), asyncHandler(NotaAlunoController.update));
notaRoutes.delete('/notas/:id', permitir('admin'), asyncHandler(NotaAlunoController.delete));