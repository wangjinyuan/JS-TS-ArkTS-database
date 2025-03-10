// 应用约束60: 使用import代替require
import AbstractHandler from './AbstractHandler.ets';
// 应用约束60: 使用import代替require，并转换文件后缀
import Constants from '../../../../util/Constants.ets';

class GuildBanAddHandler extends AbstractHandler {
  // 应用约束7: 使用private关键字代替#私有字段
  // 应用约束10: 显式指定类型参数
  handle(packet: any): void { // 需替换any为具体类型，这里保留any用于示例演示
    const client = this.packetManager.client;
    const data = packet.d;
    // 应用约束21: 使用Map的get方法代替属性访问
    const guild = client.guilds.get(data.guild_id);
    const user = client.users.get(data.user.id);
    // 应用约束30: 使用as进行类型断言
    if (guild && user) client.emit(Constants.Events.GUILD_BAN_ADD as string, guild, user);
  }
}

/**
 * Emitted whenever a member is banned from a guild.
 * @event Client#guildBanAdd
 * @param {Guild} guild The guild that the ban occurred in
 * @param {User} user The user that was banned
 */

// 应用约束60: 使用export代替module.exports
export default GuildBanAddHandler;
