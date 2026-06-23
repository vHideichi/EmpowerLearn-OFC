import express from 'express';
import { CategoriaController } from '../controllers/categoria.controller';
import asyncHandler from 'express-async-handler';
import { permitir } from '../middlewares/permissao.middleware';

export const categoriaRoutes = express.Router();

categoriaRoutes.get('/categorias',permitir ('user', 'professor','admin'), asyncHandler(CategoriaController.getAll));
categoriaRoutes.get('/categorias/:id',permitir ('user', 'professor','admin'), asyncHandler(CategoriaController.getById));
categoriaRoutes.post('/categorias',permitir ('admin'), asyncHandler(CategoriaController.save));
categoriaRoutes.put('/categorias/:id',permitir ('admin'), asyncHandler(CategoriaController.update));
categoriaRoutes.delete('/categorias/:id',permitir ('admin'), asyncHandler(CategoriaController.delete));