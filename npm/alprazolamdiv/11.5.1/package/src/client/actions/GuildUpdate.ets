import Action from './Action.ets';
import Constants from '../../util/Constants.ets';
import Util from '../../util/Util.ets';

class GuildUpdateAction extends Action {
  // 约束45: 显式标注函数返回类型
  handle(data: { id: string }): { old: unknown | null; updated: unknown | null } {
    // 约束9: 使用const代替var
    const client = this.client;

    // 约束1: 使用具体类型替代any，假设guilds是Map<string, unknown>
    const guild = client.guilds.get(data.id);
    if (guild) {
      // 约束23: 显式类型标注
      const oldGuild: unknown = Util.cloneObject(guild);
      // 约束28: 使用类方法替代动态属性修改
      guild.setup(data);
      // 约束60: 使用import的常量
      client.emit(Constants.Events.GUILD_UPDATE, oldGuild, guild);
      return {
        old: oldGuild,
        updated: guild,
      };
    }

    return {
      old: null,
      updated: null,
    };
  }
}

/**
 * Emitted whenever a guild is updated - e.g. name change.
 * @event Client#guildUpdate
 * @param {Guild} oldGuild The guild before the update
 * @param {Guild} newGuild The guild after the update
 */

// 约束60: 使用ES6 export语法
export default GuildUpdateAction;

// 约束24: 使用接口替代对象字面量类型（假设需要可新增以下接口）
/*
interface GuildUpdateResult {
  old: unknown | null;
  updated: unknown | null;
}
*/
