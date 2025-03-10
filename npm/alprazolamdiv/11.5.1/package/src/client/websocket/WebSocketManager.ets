// 应用ArkTS约束：
// 1. 使用import代替require（约束60）
// 2. 显式类型声明（约束1,10）
// 3. 使用let/const代替var（约束9）
// 4. 类属性需要在类中声明（约束18）
// 5. 方法参数和返回类型需要显式标注（约束45）
// 6. 使用ES模块导出（约束60,61）

import EventEmitter from 'events';
import Constants from '../../util/Constants.ets';
import WebSocketConnection from './WebSocketConnection.ets';

/**
 * WebSocket Manager of the client.
 * @private
 */
class WebSocketManager extends EventEmitter {
  // 显式声明类属性（约束18）
  client: Client;
  connection: WebSocketConnection | null = null;

  constructor(client: Client) {
    super();
    this.client = client;
  }

  /**
   * Sends a heartbeat on the available connection.
   */
  heartbeat(): void {
    if (!this.connection) return this.debug('No connection to heartbeat');
    this.connection.heartbeat();
  }

  /**
   * Emits a debug event.
   * @param message Debug message
   */
  debug(message: string): void {
    this.client.emit('debug', `[ws] ${message}`);
  }

  /**
   * Destroy the client.
   * @returns Whether or not destruction was successful
   */
  destroy(): boolean {
    if (!this.connection) {
      this.debug('Attempted to destroy WebSocket but no connection exists!');
      return false;
    }
    return this.connection.destroy();
  }

  /**
   * Send a packet on the available WebSocket.
   * @param packet Packet to send
   */
  send(packet: Object): void {
    if (!this.connection) {
      this.debug('No connection to websocket');
      return;
    }
    this.connection.send(packet);
  }

  /**
   * Connects the client to a gateway.
   * @param gateway The gateway to connect to
   */
  connect(gateway: string): boolean {
    if (!this.connection) {
      this.connection = new WebSocketConnection(this, gateway);
      return true;
    }
    switch (this.connection.status) {
      case Constants.Status.IDLE:
      case Constants.Status.DISCONNECTED:
        this.connection.connect(gateway, 5500);
        return true;
      default:
        this.debug(`Couldn't connect to ${gateway} as the websocket is at state ${this.connection.status}`);
        return false;
    }
  }
}

export default WebSocketManager;

// 注意：需要确保以下类型在相关模块中正确定义：
// 1. Client类/接口需要包含emit方法的定义
// 2. WebSocketConnection类需要明确定义status属性和相关方法
// 3. Constants.Status枚举需要正确定义
