import express from "express";
import { InstituicaoController } from "../controllers/instituicao.controller";
import asyncHandler from "express-async-handler";
import { celebrate, Segments } from "celebrate";
import { instituicaoSchema } from "../models/instituicao.model";
import { permitir } from '../middlewares/permissao.middleware';

export const instituicaoRoutes = express.Router();

instituicaoRoutes.get("/instituicoes", permitir('admin'), asyncHandler(InstituicaoController.getAll));
instituicaoRoutes.get("/instituicoes/:id", permitir('admin'), asyncHandler(InstituicaoController.getById));
instituicaoRoutes.post("/instituicoes", permitir('admin'), celebrate({ [Segments.BODY]: instituicaoSchema }), asyncHandler(InstituicaoController.save));
instituicaoRoutes.put("/instituicoes/:id", permitir('admin'), celebrate({ [Segments.BODY]: instituicaoSchema }), asyncHandler(InstituicaoController.update));
instituicaoRoutes.delete("/instituicoes/:id", permitir('admin'), asyncHandler(InstituicaoController.delete));