import prisma from '../config/prisma';
import { emitToUser } from '../config/socket';

export class NotificacaoRealtimeService {
  async enviar(
    usuarioId: number,
    titulo: string,
    mensagem: string,
    tipo: string
  ): Promise<void> {
    await prisma.notificacao.create({
      data: {
        usuarioId,
        titulo,
        mensagem,
        tipo,
        lida: false,
      },
    });

    emitToUser(usuarioId, 'notificacao', {
      titulo,
      mensagem,
      tipo,
      criadoEm: new Date(),
    });
  }
}