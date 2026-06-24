import { Server } from 'socket.io';

let ioInstance: Server | null = null;

export function setSocketServer(io: Server): void {
  ioInstance = io;
}

export function getSocketServer(): Server | null {
  return ioInstance;
}

export function emitToUser(
  usuarioId: number,
  event: string,
  payload: unknown
): void {
  if (!ioInstance) {
    return;
  }

  ioInstance.to(`usuario_${usuarioId}`).emit(event, payload);
}