import express from "express";
import { createServer } from "http";
import { Server } from "socket.io";
import { routes } from "./routes/index";
import { errorHandler } from "./middlewares/error-handler.middleware";
import { pageNotFoundHandler } from "./middlewares/page-not-found.middleware";

const app = express();

app.use((req, res, next) => {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Authorization");
    if (req.method === "OPTIONS") {
        return res.sendStatus(200);
    }
    next();
});

const httpServer = createServer(app);

export const io = new Server(httpServer, {
    cors: {
        origin: "*",
        methods: ["GET", "POST"]
    }
});

io.on("connection", (socket) => {
    console.log(`Cliente conectado: ${socket.id}`);

    socket.on("registrar", (usuarioId: number) => {
        socket.join(`usuario_${usuarioId}`);
        console.log(`Usuário ${usuarioId} registrado na sala usuario_${usuarioId}`);
    });

    socket.on("disconnect", () => {
        console.log(`Cliente desconectado: ${socket.id}`);
    });
});

app.use(express.json());
routes(app);
pageNotFoundHandler(app);
errorHandler(app);

const PORT = process.env.PORT || 3000;
httpServer.listen(PORT, () => {
    console.log(`Servidor rodando em http://localhost:${PORT}`);
});