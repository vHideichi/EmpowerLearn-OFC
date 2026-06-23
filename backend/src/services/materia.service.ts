import { MateriaRepository } from '../repositories/materia.repository';

export class MateriaService {
  private repo = new MateriaRepository();

  async getAll(cursoId?: number) {
    return this.repo.getAll(cursoId);
  }

  async getById(id: number) {
    return this.repo.getById(id);
  }

  async save(data: any) {
    return this.repo.save(data);
  }

  async update(id: number, data: any) {
    return this.repo.update(id, data);
  }

  async delete(id: number) {
    return this.repo.delete(id);
  }
}