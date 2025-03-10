// 应用约束60：使用import代替require
import AbstractHandler from './AbstractHandler.ets';

class GuildMemberRemoveHandler extends AbstractHandler {
  // 应用约束10：显式指定参数类型，避免使用any
  handle(packet: Object): void {
    const client = this.packetManager.client;
    const data: Object = packet.d; // 使用Object代替未明确类型的对象
    client.actions.GuildMemberRemove.handle(data);
  }
}

// 应用约束60：使用ES模块导出代替module.exports
export default GuildMemberRemoveHandler;
