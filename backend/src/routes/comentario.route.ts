import express from 'express';
import { ComentarioController } from '../controllers/comentario.controller';
import asyncHandler from 'express-async-handler';
import { permitir } from '../middlewares/permissao.middleware';

export const comentarioRoutes = express.Router();

comentarioRoutes.get('/comentarios', permitir('aluno', 'professor', 'admin'), asyncHandler(ComentarioController.getAll));
comentarioRoutes.get('/comentarios/:id', permitir('aluno', 'professor', 'admin'), asyncHandler(ComentarioController.getById));
comentarioRoutes.post('/comentarios', permitir('aluno', 'professor', 'admin'), asyncHandler(ComentarioController.save));
comentarioRoutes.put('/comentarios/:id', permitir('aluno', 'professor', 'admin'), asyncHandler(ComentarioController.update));
comentarioRoutes.delete('/comentarios/:id', permitir('aluno', 'professor', 'admin'), asyncHandler(ComentarioController.delete));