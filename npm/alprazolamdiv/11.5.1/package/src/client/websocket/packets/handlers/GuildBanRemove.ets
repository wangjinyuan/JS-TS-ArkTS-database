// 应用约束60：使用import代替require
import AbstractHandler from './AbstractHandler.ets';

class GuildBanRemoveHandler extends AbstractHandler {
  // 应用约束18：在类中声明字段，但本例中没有需要声明的字段
  handle(packet: { d: Object }): void { // 应用约束1：显式标注类型，避免any
    const client = this.packetManager.client;
    const data: Object = packet.d; // 应用约束10：使用具体类型代替any
    client.actions.GuildBanRemove.handle(data);
  }
}

/**
 * Emitted whenever a member is unbanned from a guild.
 * @event Client#guildBanRemove
 * @param {Guild} guild The guild that the unban occurred in
 * @param {User} user The user that was unbanned
 */

// 应用约束61：使用export default代替module.exports
export default GuildBanRemoveHandler;
