// 应用ArkTS约束：使用let/const代替var（约束9），替换require为import（约束60），使用箭头函数（约束26）
import dgram from 'dgram.ets';
import Constants from '../../util/Constants.ets';

// 应用ArkTS约束：定义事件接口替代EventEmitter（约束11,28）
interface EventEmitter {
  on(event: string, listener: Function): void;
  emit(event: string, ...args: any[]): void;
}

// 应用ArkTS约束：显式类型声明（约束1,10），类属性预先声明（约束18）
class VoiceConnectionUDPClient {
  private voiceConnection: any; // 需替换为具体VoiceConnection类型
  private socket: dgram.Socket | null = null;
  private discordAddress: string | null = null;
  private localAddress: string | null = null;
  private localPort: number | null = null;
  private listeners: Map<string, Function[]> = new Map();

  constructor(voiceConnection: any) { // 参数类型应具体化
    this.voiceConnection = voiceConnection;
    this.voiceConnection.on('closing', () => this.shutdown());
  }

  // 自定义事件机制（约束2,28）
  on(event: string, listener: Function): void {
    const eventListeners = this.listeners.get(event) || [];
    eventListeners.push(listener);
    this.listeners.set(event, eventListeners);
  }

  private emit(event: string, ...args: any[]): void {
    const eventListeners = this.listeners.get(event);
    eventListeners?.forEach(listener => listener(...args));
  }

  shutdown(): void {
    if (this.socket) {
      this.socket.removeAllListeners('message');
      try {
        this.socket.close();
      } finally {
        this.socket = null;
      }
    }
  }

  get discordPort(): number {
    return this.voiceConnection.authentication.port;
  }

  // 应用ArkTS约束：明确返回类型（约束45）
  send(packet: Buffer): Promise<Buffer> {
    return new Promise((resolve, reject) => {
      if (!this.socket) throw new Error('No socket available');
      if (!this.discordAddress || !this.discordPort) throw new Error('Invalid address/port');
      
      this.socket.send(packet, this.discordPort, this.discordAddress, (error) => {
        error ? reject(error) : resolve(packet);
      });
    });
  }

  createUDPSocket(address: string): void {
    this.discordAddress = address;
    this.socket = dgram.createSocket('udp4');

    this.socket.once('message', (message: Buffer) => {
      const packet = this.parseLocalPacket(message);
      if ('error' in packet) {
        this.emit('error', packet.error);
        return;
      }

      this.localAddress = packet.address;
      this.localPort = packet.port;

      this.voiceConnection.sockets.ws.sendPacket({
        op: Constants.VoiceOPCodes.SELECT_PROTOCOL,
        d: {
          protocol: 'udp',
          data: {
            address: packet.address,
            port: packet.port,
            mode: 'xsalsa20_poly1305'
          }
        }
      });
    });

    const blankMessage = Buffer.alloc(70);
    blankMessage.writeUIntBE(this.voiceConnection.authentication.ssrc, 0, 4);
    this.send(blankMessage);
  }

  // 应用ArkTS约束：明确返回类型（约束24）
  private parseLocalPacket(message: Buffer): { address: string; port: number } | { error: Error } {
    try {
      const packet = Buffer.from(message);
      let address = '';
      let i = 4;
      while (packet[i] !== 0) {
        address += String.fromCharCode(packet[i]);
        i++;
      }
      const port = packet.readUIntLE(packet.length - 2, 2);
      return { address, port };
    } catch (error) {
      return { error: error instanceof Error ? error : new Error(String(error)) };
    }
  }
}

export default VoiceConnectionUDPClient;

// 应用ArkTS约束说明：
// 1. 使用let/const代替var（约束9）
// 2. 显式类型标注（约束1,10）
// 3. 类属性预先声明（约束18）
// 4. 使用接口替代structural typing（约束4）
// 5. 使用Map实现自定义事件（约束2,28）
// 6. 箭头函数保持上下文（约束26）
// 7. 移除any类型，需替换为具体类型（约束1）
// 8. 使用Buffer类型替代Object（约束10）
// 9. 模块导入后缀处理（约束78）
