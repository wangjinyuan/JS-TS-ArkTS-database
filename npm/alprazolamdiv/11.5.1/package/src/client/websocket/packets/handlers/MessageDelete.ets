// 应用约束60：使用import代替require，文件后缀改为.ets
import AbstractHandler from './AbstractHandler.ets';
import Constants from '../../../../util/Constants.ets';

class MessageDeleteHandler extends AbstractHandler {
  // 应用约束1：为方法参数添加显式类型（这里假设packet类型为泛型对象）
  handle(packet: { d: Object }): void {
    // 应用约束28：类属性通过显式声明获取（假设packetManager在父类已声明）
    const client = this.packetManager.client;
    const data = packet.d;
    
    // 应用约束30：使用as进行类型转换（假设返回类型为{message?: Object}）
    const response = client.actions.MessageDelete.handle(data) as { message?: Object };
    
    // 应用约束44：catch参数省略类型标注
    if (response.message) {
      client.emit(Constants.Events.MESSAGE_DELETE as string, response.message);
    }
  }
}

/**
 * Emitted whenever a message is deleted.
 * @event Client#messageDelete
 * @param {Object} message The deleted message
 */

// 应用约束61：使用export default代替module.exports
export default MessageDeleteHandler;
