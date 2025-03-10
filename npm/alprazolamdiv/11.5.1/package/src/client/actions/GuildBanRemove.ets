// 应用约束60：使用import代替require
import Action from './Action.ets';
import Constants from '../../util/Constants.ets';

class GuildBanRemove extends Action {
  // 应用约束10：显式声明参数类型（使用Object代替any）
  handle(data: Object): void {
    const client = this.client;
    // 应用约束21：使用Map的get方法进行属性访问
    const guild = client.guilds.get(data['guild_id']);
    // 应用约束21：使用Map的get方法进行属性访问
    const user = client.dataManager.newUser(data['user']);
    if (guild && user) {
      // 应用约束21：使用字符串常量访问属性
      client.emit(Constants.Events.GUILD_BAN_REMOVE, guild, user);
    }
  }
}

// 应用约束61：使用export default代替module.exports
export default GuildBanRemove;
