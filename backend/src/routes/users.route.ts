import express from "express";
import { UsersController } from "../controllers/users.controller";
import asyncHandler from "express-async-handler";
import { celebrate, Segments } from "celebrate";
import { userSchema } from "../models/users.model";
import { permitir } from '../middlewares/permissao.middleware';

export const userRoutes = express.Router();

userRoutes.get("/users", permitir('aluno', 'admin'), asyncHandler(UsersController.getAll));
userRoutes.get("/users/:id", permitir('admin'), asyncHandler(UsersController.getById));
userRoutes.post("/users", permitir('admin'), celebrate({ [Segments.BODY]: userSchema }), asyncHandler(UsersController.save));
userRoutes.put("/users/:id", permitir('aluno', 'admin'), celebrate({ [Segments.BODY]: userSchema }), asyncHandler(UsersController.update));
userRoutes.delete("/users/:id", permitir('aluno', 'admin'), asyncHandler(UsersController.delete));