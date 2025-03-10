// 应用约束60: 使用import代替require
import { AbstractHandler } from './AbstractHandler.ets';

class GuildEmojisUpdate extends AbstractHandler {
  handle(packet: { d: Object }): void { // 应用约束1: 禁止使用any类型，使用Object代替
    const client = this.packetManager.client;
    const data: Object = packet.d;
    client.actions.GuildEmojisUpdate.handle(data);
  }
}

// 应用约束61: 使用export代替module.exports
export default GuildEmojisUpdate;
