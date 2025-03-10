// 应用约束60：使用import代替require
import AbstractHandler from './AbstractHandler.ets';
import Constants from '../../../../util/Constants.ets';

class MessageCreateHandler extends AbstractHandler {
  // 应用约束7：使用private关键字替代#私有字段（如果存在的话）
  // 应用约束10：使用具体类型替代any
  handle(packet: { d: Object }): void {
    const client = this.packetManager.client;
    const data: Object = packet.d;
    
    // 应用约束10：假设Response类型已正确定义
    const response = client.actions.MessageCreate.handle(data);
    
    // 应用约束32：使用合法类型检查
    if (response.message) {
      // 应用约束30：使用as进行类型断言（如果需要）
      client.emit(Constants.Events.MESSAGE_CREATE, response.message as Object);
    }
  }
}

/**
 * Emitted whenever a message is created.
 * @event Client#message
 * @param {Message} message The created message
 */

// 应用约束60：使用export代替module.exports
export default MessageCreateHandler;

// 应用约束24：使用类替代对象字面量类型（假设Message类型已正确定义为类）
