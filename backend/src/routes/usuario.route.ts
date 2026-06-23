import express from 'express';
import multer from 'multer';
import path from 'path';
import fs from 'fs';
import asyncHandler from 'express-async-handler';
import { permitir } from '../middlewares/permissao.middleware';
import { UserService } from '../services/user.service';
import { parseId } from '../utils/parse-id';

export const usuarioRoutes = express.Router();

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const dir = path.join(process.cwd(), 'uploads');
    if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
    cb(null, dir);
  },
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    cb(null, `usuario_${Date.now()}${ext}`);
  },
});

const upload = multer({ storage });

usuarioRoutes.get(
  '/usuarios/:id',
  permitir('aluno', 'professor', 'admin'),
  asyncHandler(async (req, res) => {
    const id = parseId(req);
    const usuario = await new UserService().getById(id);
    res.send(usuario);
  })
);

usuarioRoutes.post(
  '/usuarios/:id/upload-foto',
  permitir('aluno', 'professor', 'admin'),
  upload.single('file'),
  asyncHandler(async (req, res) => {
    const id = parseId(req);
    if (!req.file) {
      res.status(400).send({ message: 'Nenhum arquivo enviado' });
      return;
    }
    const fotoUrl = `/uploads/${req.file.filename}`;
    await new UserService().update(id, { fotoUrl });
    res.send({ fotoUrl });
  })
);

usuarioRoutes.put(
  '/usuarios/:id',
  permitir('aluno', 'professor', 'admin'),
  asyncHandler(async (req, res) => {
    const id = parseId(req);
    await new UserService().update(id, req.body);
    res.send({ message: 'Usuário atualizado com sucesso' });
  })
);