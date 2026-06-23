import express from 'express';
import { VideoController } from '../controllers/video.controller';
import asyncHandler from 'express-async-handler';
import { permitir } from '../middlewares/permissao.middleware';

export const videoRoutes = express.Router();

videoRoutes.get('/videos', permitir('aluno', 'professor', 'admin'), asyncHandler(VideoController.getAll));
videoRoutes.get('/videos/:id', permitir('aluno', 'professor', 'admin'), asyncHandler(VideoController.getById));
videoRoutes.post('/videos', permitir('professor', 'admin'), asyncHandler(VideoController.save));
videoRoutes.put('/videos/:id', permitir('professor', 'admin'), asyncHandler(VideoController.update));
videoRoutes.delete('/videos/:id', permitir('admin'), asyncHandler(VideoController.delete));