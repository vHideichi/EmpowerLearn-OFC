import express from "express";
import { authRoutes } from "./auth.route";
import { userRoutes } from "./users.route";
import { professorRoutes } from "./professor.route";
import { instituicaoRoutes } from "./instituicao.route";
import { cursoRoutes } from "./curso.route";
import { materiaRoutes } from "./materia.route";
import { matriculaRoutes } from "./matricula.route";
import { progressoRoutes } from "./progresso_materia.route";
import { tarefaRoutes } from "./tarefa.route";
import { submissaoRoutes } from "./submissao.route";
import { notificacaoRealtimeRoutes } from "./notificacao-realtime.route";
import { postForumRoutes } from "./post_forum.route";
import { comentarioRoutes } from "./comentario.route";
import { planoRoutes } from "./plano.route";
import { assinaturaRoutes } from "./assinatura.route";
import { notificacaoRoutes } from "./notificacao.route";
import { mensagemRoutes } from "./mensagem_chat.route";
import { categoriaRoutes } from "./categoria.route";
import { videoRoutes } from "./video.route";
import { historicoRoutes } from "./historico.route";
import { favoritoRoutes } from "./favorito.route";
import { notaRoutes } from "./nota_aluno.route";
import { refreshTokenRoutes } from "./refresh_token.route";
import { authMiddleware } from "../middlewares/auth.middleware";
import { usuarioRoutes } from "./usuario.route";
import path from 'path';

export const routes = (app: express.Express) => {
    app.use(express.json());

    app.use(authRoutes);

    app.use(authMiddleware);

    app.use('/uploads', express.static(path.join(process.cwd(), 'uploads')));
    app.use(usuarioRoutes);

    app.use(userRoutes);
    app.use(professorRoutes);
    app.use(instituicaoRoutes);
    app.use(cursoRoutes);
    app.use(materiaRoutes);
    app.use(notificacaoRealtimeRoutes);
    app.use(matriculaRoutes);
    app.use(progressoRoutes);
    app.use(tarefaRoutes);
    app.use(submissaoRoutes);
    app.use(postForumRoutes);
    app.use(comentarioRoutes);
    app.use(planoRoutes);
    app.use(assinaturaRoutes);
    app.use(notificacaoRoutes);
    app.use(mensagemRoutes);
    app.use(categoriaRoutes);
    app.use(videoRoutes);
    app.use(historicoRoutes);
    app.use(favoritoRoutes);
    app.use(notaRoutes);
    app.use(refreshTokenRoutes);
};