// 应用约束60：使用import代替require
import AbstractHandler from './AbstractHandler.ets';

class GuildRoleCreateHandler extends AbstractHandler {
  // 应用约束1：为packet参数添加具体类型，假设Packet类型已定义
  handle(packet: { d: Object }): void {
    // 应用约束1：client属性需要具体类型，假设已正确定义
    const client = this.packetManager.client;
    const data = packet.d;
    // 应用约束1：确保actions结构已正确定义类型
    client.actions.GuildRoleCreate.handle(data);
  }
}

// 应用约束61：使用export default代替module.exports
export default GuildRoleCreateHandler;
