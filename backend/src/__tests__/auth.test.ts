import request from 'supertest';
import express from 'express';

process.env.JWT_SECRET = 'test_secret';
process.env.JWT_REFRESH_SECRET = 'test_refresh_secret';

const mockRegister = jest.fn();
const mockLogin = jest.fn();
const mockRefreshToken = jest.fn();

jest.mock('../services/auth.service', () => ({
    AuthService: jest.fn().mockImplementation(() => ({
        register: mockRegister,
        login: mockLogin,
        refreshToken: mockRefreshToken,
    }))
}));

jest.mock('../config/prisma', () => ({
    __esModule: true,
    default: {
        usuario: { findUnique: jest.fn(), create: jest.fn(), findMany: jest.fn() },
        refreshToken: { create: jest.fn(), findUnique: jest.fn() },
        tarefa: { create: jest.fn(), findMany: jest.fn(), findUnique: jest.fn() },
        curso: { create: jest.fn(), findMany: jest.fn(), findUnique: jest.fn() },
    }
}));

import { ValidationError } from '../errors/validation.error';
import { routes } from '../routes/index';
import { errorHandler } from '../middlewares/error-handler.middleware';
import { pageNotFoundHandler } from '../middlewares/page-not-found.middleware';

const app = express();
routes(app);
pageNotFoundHandler(app);
errorHandler(app);

describe('Auth', () => {

    beforeEach(() => {
        mockRegister.mockReset();
        mockLogin.mockReset();
        mockRefreshToken.mockReset();
    });

    it('POST /auth/register — deve cadastrar um usuario', async () => {
        mockRegister.mockResolvedValue({ id: 1, nome: 'Teste', email: 'teste@test.com' });

        const res = await request(app)
            .post('/auth/register')
            .send({ nome: 'Teste', email: 'teste@test.com', senha: 'senha123', tipo: 'aluno' });

        expect(res.status).toBe(201);
        expect(res.body.message).toBe('Usuário cadastrado com sucesso');
    });

    it('POST /auth/register — email duplicado deve retornar 400', async () => {
        mockRegister.mockRejectedValue(new ValidationError('Email já cadastrado'));

        const res = await request(app)
            .post('/auth/register')
            .send({ nome: 'Duplicado', email: 'duplicado@test.com', senha: 'senha123', tipo: 'aluno' });

        expect(res.status).toBe(400);
        expect(res.body.message).toBe('Email já cadastrado');
    });

    it('POST /auth/login — credenciais corretas devem retornar token', async () => {
        mockLogin.mockResolvedValue({
            token: 'fake_jwt_token',
            refreshToken: 'fake_refresh_token',
            usuario: { id: 1, nome: 'Teste', email: 'teste@test.com', tipo: 'aluno' }
        });

        const res = await request(app)
            .post('/auth/login')
            .send({ email: 'teste@test.com', senha: 'senha123' });

        expect(res.status).toBe(200);
        expect(res.body.token).toBeDefined();
        expect(res.body.refreshToken).toBeDefined();
    });

    it('POST /auth/login — senha errada deve retornar 500', async () => {
        mockLogin.mockRejectedValue(new Error('Credenciais inválidas'));

        const res = await request(app)
            .post('/auth/login')
            .send({ email: 'teste@test.com', senha: 'senhaerrada' });

        expect(res.status).toBe(500);
    });

    it('GET /cursos — sem token deve retornar 401', async () => {
        const res = await request(app).get('/cursos');
        expect(res.status).toBe(401);
    });

    it('POST /tarefas — aluno deve receber 403', async () => {
        const token = require('jsonwebtoken').sign(
            { userId: 1, tipo: 'aluno' },
            'test_secret',
            { expiresIn: '1h' }
        );

        const res = await request(app)
            .post('/tarefas')
            .set('Authorization', `Bearer ${token}`)
            .send({ titulo: 'Tarefa teste' });

        expect(res.status).toBe(403);
        expect(res.body.message).toBe('Acesso negado');
    });

});