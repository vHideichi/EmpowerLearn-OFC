import prisma from '../config/prisma';
import { NotFoundError } from '../errors/not-found.error';

export class MateriaRepository {
  async getAll(cursoId?: number) {
    return prisma.materia.findMany({
      where: cursoId ? { cursoId } : undefined,
      orderBy: [
        { ordem: 'asc' },
        { id: 'asc' },
      ],
    });
  }

  async getById(id: number) {
    const item = await prisma.materia.findUnique({
      where: { id },
    });

    if (!item) {
      throw new NotFoundError('Matéria não encontrada');
    }

    return item;
  }

  async save(data: any) {
    const payload = {
      cursoId: Number(data.cursoId),
      professorId: Number(data.professorId),
      titulo: data.titulo,
      conteudo: data.conteudo ?? '',
      ordem: data.ordem !== undefined ? Number(data.ordem) : 1,
    };

    return prisma.materia.create({
      data: payload,
    });
  }

  async update(id: number, data: any) {
    const payload: any = {};

    if (data.cursoId !== undefined) {
      payload.cursoId = Number(data.cursoId);
    }

    if (data.professorId !== undefined) {
      payload.professorId = Number(data.professorId);
    }

    if (data.titulo !== undefined) {
      payload.titulo = data.titulo;
    }

    if (data.conteudo !== undefined) {
      payload.conteudo = data.conteudo;
    }

    if (data.ordem !== undefined) {
      payload.ordem = Number(data.ordem);
    }

    return prisma.materia.update({
      where: { id },
      data: payload,
    });
  }

  async delete(id: number) {
    return prisma.materia.delete({
      where: { id },
    });
  }
}