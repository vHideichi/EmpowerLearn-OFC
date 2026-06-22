import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class ForumRepository {
    async getAll() {
        return await prisma.postForum.findMany({
            include: {
                autor: { select: { id: true, nome: true, tipo: true } }
            },
            orderBy: { createdAt: 'desc' }
        });
    }

    async getById(id: number) {
        const item = await prisma.postForum.findUnique({
            where: { id },
            include: {
                autor: { select: { id: true, nome: true, tipo: true } },
                comentarios: true
            }
        });
        if (!item) throw new NotFoundError("Post do fórum não encontrado");
        return item;
    }

    async save(data: any) {
        return await prisma.postForum.create({
            data: {
                titulo: data.titulo,
                conteudo: data.conteudo,
                autorId: data.usuarioId || data.autorId,
                cursoId: data.cursoId || null,
            }
        });
    }

    async update(id: number, data: any) {
        return await prisma.postForum.update({ where: { id }, data });
    }

    async delete(id: number) {
        return await prisma.postForum.delete({ where: { id } });
    }
}