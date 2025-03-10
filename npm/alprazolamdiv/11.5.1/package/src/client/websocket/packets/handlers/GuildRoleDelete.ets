// 应用约束60: 使用import代替require
import AbstractHandler from './AbstractHandler.ets';

class GuildRoleDeleteHandler extends AbstractHandler {
  // 应用约束1: 添加参数类型，避免使用any
  handle(packet: { d: Object }): void {
    const client = this.packetManager.client;
    const data = packet.d;
    // 应用约束1: 假设client.actions.GuildRoleDelete.handle已正确定义类型
    client.actions.GuildRoleDelete.handle(data);
  }
}

// 应用约束61: 使用export default代替module.exports
export default GuildRoleDeleteHandler;
