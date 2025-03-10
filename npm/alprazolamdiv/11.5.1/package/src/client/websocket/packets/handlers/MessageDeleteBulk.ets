// 应用约束60：使用import代替require
import AbstractHandler from './AbstractHandler.ets';

class MessageDeleteBulkHandler extends AbstractHandler {
  // 应用约束1：添加参数类型声明，使用Object代替any
  handle(packet: { d: Object }): void {
    // 应用约束1：添加client类型声明（假设Client类型已定义）
    const client: Client = this.packetManager.client;
    // 应用约束1：添加data类型声明
    const data: Object = packet.d;
    client.actions.MessageDeleteBulk.handle(data);
  }
}

/**
 * Emitted whenever messages are deleted in bulk.
 * @event Client#messageDeleteBulk
 * @param {Collection<Snowflake, Message>} messages The deleted messages, mapped by their ID
 */

// 应用约束60：使用ES模块导出语法
export default MessageDeleteBulkHandler;

// 应用约束24：使用类代替对象字面量类型（假设需要定义相关类型）
class Client {
  actions = new class {
    MessageDeleteBulk = new class {
      handle(data: Object): void {}
    }
  }
}

// 应用约束8：保持类型命名唯一（示例类型定义）
class Snowflake {}
class Message {}
class Collection<K, V> {}
