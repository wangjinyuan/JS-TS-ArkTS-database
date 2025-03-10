// 应用约束：1. 强制使用静态类型，2. 使用let/const替代var，9. 使用let而非var，18. 在class中声明字段，26. 使用箭头函数
import * as Constants from '../util/Constants.ets';
import * as WebSocketConnection from './websocket/WebSocketConnection.ets';

// 假设Client接口已定义
interface Client {
  emit(event: string, message: string): void;
  token: string | null;
  setTimeout(callback: () => void, ms: number): number;
  clearTimeout(timeoutId: number): void;
  rest: {
    destroy(): void;
    methods: {
      getGateway(): Promise<{ url: string }>;
      logout(): Promise<void>;
    };
  };
  ws: {
    connect(gateway: string): void;
    connection: {
      once(event: string, callback: (event?: any) => void): void;
    };
    destroy(): void;
  };
  user?: {
    bot: boolean;
  };
}

class ClientManager {
  // 应用约束18：在class中声明字段
  client: Client;
  heartbeatInterval: number | null = null;

  // 应用约束1：参数添加类型注解
  constructor(client: Client) {
    this.client = client;
  }

  // 应用约束1：添加返回类型注解
  get status(): number {
    return this.client.ws.connection ? Constants.Status.IDLE : Constants.Status.IDLE;
  }

  // 应用约束1：参数添加类型注解
  connectToWebSocket(token: string, resolve: (value: string) => void, reject: (reason: any) => void): void {
    this.client.emit(Constants.Events.DEBUG, `Authenticated using token ${token}`);
    this.client.token = token;
    
    // 应用约束26：使用箭头函数
    const timeout = this.client.setTimeout(() => reject(new Error(Constants.Errors.TOOK_TOO_LONG)), 1000 * 300);
    
    this.client.rest.methods.getGateway().then((res: { url: string }) => {
      const protocolVersion = Constants.DefaultOptions.ws.version;
      const gateway = `${res.url}/?v=${protocolVersion}&encoding=${WebSocketConnection.ENCODING}`;
      
      this.client.emit(Constants.Events.DEBUG, `Using gateway ${gateway}`);
      this.client.ws.connect(gateway);
      
      this.client.ws.connection.once('error', reject);
      
      this.client.ws.connection.once('close', (event: { code: number }) => {
        if (event.code === 4004) reject(new Error(Constants.Errors.BAD_LOGIN));
        if (event.code === 4010) reject(new Error(Constants.Errors.INVALID_SHARD));
        if (event.code === 4011) reject(new Error(Constants.Errors.SHARDING_REQUIRED));
      });
      
      this.client.once(Constants.Events.READY, () => {
        resolve(token);
        this.client.clearTimeout(timeout);
      });
    }, reject);
  }

  // 应用约束1：添加返回类型注解
  destroy(): Promise<void> {
    this.client.ws.destroy();
    this.client.rest.destroy();
    
    if (!this.client.user) return Promise.resolve();
    
    if (this.client.user.bot) {
      this.client.token = null;
      return Promise.resolve();
    } else {
      return this.client.rest.methods.logout().then(() => {
        this.client.token = null;
      });
    }
  }
}

// 应用约束60：使用ES模块导出
export default ClientManager;
