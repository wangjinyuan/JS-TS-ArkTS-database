// 应用约束60：使用import代替require，并修改文件后缀为.ets
import AbstractHandler from './AbstractHandler.ets';

// 应用约束28：只有接口可以被implements，但此处是类继承，符合ArkTS规范
class MessageReactionRemoveAll extends AbstractHandler {
  // 应用约束1：为函数参数添加显式类型声明（假设Packet类型已定义）
  handle(packet: { d: unknown }): void {
    const client = this.packetManager.client;
    // 应用约束1：使用具体类型代替any，假设d的类型为unknown
    const data: unknown = packet.d;
    
    // 应用约束1：确保actions对象结构已正确定义
    client.actions.MessageReactionRemoveAll.handle(data);
  }
}

// 应用约束61：使用export default代替module.exports
export default MessageReactionRemoveAll;

// 注意：需要确保以下类型在相关文件中已正确定义：
// 1. AbstractHandler基类的正确定义
// 2. PacketManager和Client类型及其属性结构
// 3. client.actions.MessageReactionRemoveAll.handle方法的类型声明
