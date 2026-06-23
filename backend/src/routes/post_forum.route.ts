import express from 'express';
import { PostForumController } from '../controllers/post_forum.controller';
import asyncHandler from 'express-async-handler';
import { permitir } from '../middlewares/permissao.middleware';

export const postForumRoutes = express.Router();

postForumRoutes.get('/forum', permitir('aluno', 'professor', 'admin'), asyncHandler(PostForumController.getAll));
postForumRoutes.get('/forum/:id', permitir('aluno', 'professor', 'admin'), asyncHandler(PostForumController.getById));
postForumRoutes.post('/forum', permitir('aluno', 'professor', 'admin'), asyncHandler(PostForumController.save));
postForumRoutes.put('/forum/:id', permitir('aluno', 'professor', 'admin'), asyncHandler(PostForumController.update));
postForumRoutes.delete('/forum/:id', permitir('aluno', 'professor', 'admin'), asyncHandler(PostForumController.delete));