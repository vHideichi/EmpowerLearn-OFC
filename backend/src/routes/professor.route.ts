import express from "express";
import { ProfessorControler } from "../controllers/professor.controller";
import asyncHandler from "express-async-handler";
import { permitir } from '../middlewares/permissao.middleware';

export const professorRoutes = express.Router();

professorRoutes.get("/professores", permitir('professor', 'admin'), asyncHandler(ProfessorControler.getAll));
professorRoutes.get("/professores/:id", permitir('admin'), asyncHandler(ProfessorControler.getById));
professorRoutes.post("/professores", permitir('admin'), asyncHandler(ProfessorControler.save));
professorRoutes.put("/professores/:id", permitir('professor', 'admin'), asyncHandler(ProfessorControler.update));
professorRoutes.delete("/professores/:id", permitir('professor', 'admin'), asyncHandler(ProfessorControler.delete));