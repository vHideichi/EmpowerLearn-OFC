import express from 'express';
import { FavoritoController } from '../controllers/favorito.controller';
import asyncHandler from 'express-async-handler';
import { permitir } from '../middlewares/permissao.middleware';

export const favoritoRoutes = express.Router();

favoritoRoutes.get('/favoritos', permitir('aluno', 'professor', 'admin'), asyncHandler(FavoritoController.getAll));
favoritoRoutes.get('/favoritos/:id', permitir('aluno', 'professor', 'admin'), asyncHandler(FavoritoController.getById));
favoritoRoutes.post('/favoritos', permitir('aluno', 'professor', 'admin'), asyncHandler(FavoritoController.save));
favoritoRoutes.delete('/favoritos/:id', permitir('aluno', 'professor', 'admin'), asyncHandler(FavoritoController.delete));