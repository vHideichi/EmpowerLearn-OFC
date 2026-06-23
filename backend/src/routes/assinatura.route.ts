import express from 'express';
import { AssinaturaController } from '../controllers/assinatura.controller';
import asyncHandler from 'express-async-handler';
import { permitir } from '../middlewares/permissao.middleware';

export const assinaturaRoutes = express.Router();

assinaturaRoutes.get('/assinaturas', permitir('aluno', 'admin'), asyncHandler(AssinaturaController.getAll));
assinaturaRoutes.get('/assinaturas/:id', permitir('aluno', 'admin'), asyncHandler(AssinaturaController.getById));
assinaturaRoutes.post('/assinaturas', permitir('aluno', 'admin'), asyncHandler(AssinaturaController.save));
assinaturaRoutes.put('/assinaturas/:id', permitir('admin'), asyncHandler(AssinaturaController.update));
assinaturaRoutes.delete('/assinaturas/:id', permitir('admin'), asyncHandler(AssinaturaController.delete));