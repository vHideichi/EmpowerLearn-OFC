import express from 'express';
import { TarefaController } from '../controllers/tarefa.controller';
import asyncHandler from 'express-async-handler';
import { permitir } from '../middlewares/permissao.middleware';

export const tarefaRoutes = express.Router();

tarefaRoutes.get('/tarefas', permitir('aluno', 'professor', 'admin'), asyncHandler(TarefaController.getAll));
tarefaRoutes.get('/tarefas/:id', permitir('aluno', 'professor', 'admin'), asyncHandler(TarefaController.getById));
tarefaRoutes.post('/tarefas', permitir('professor', 'admin'), asyncHandler(TarefaController.save));
tarefaRoutes.put('/tarefas/:id', permitir('professor', 'admin'), asyncHandler(TarefaController.update));
tarefaRoutes.delete('/tarefas/:id', permitir('admin'), asyncHandler(TarefaController.delete));