// 应用ArkTS约束：
// 1. 使用import代替require（约束60,61）
// 2. 使用export default代替module.exports（约束60,61）
// 3. 添加参数类型注解（约束1,10）
// 4. 转换.js/.ts文件引用为.ets后缀（约束78）

import AbstractHandler from './AbstractHandler.ets';

class MessageReactionAddHandler extends AbstractHandler {
  handle(packet: { d: Object }): void {
    const client = this.packetManager.client;
    const data: Object = packet.d;
    client.actions.MessageReactionAdd.handle(data);
  }
}

export default MessageReactionAddHandler;
