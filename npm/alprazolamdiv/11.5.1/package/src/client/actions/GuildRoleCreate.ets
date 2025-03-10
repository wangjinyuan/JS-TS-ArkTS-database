import Action from './Action.ets';
import Constants from '../../util/Constants.ets';
import Role from '../../structures/Role.ets';

class GuildRoleCreate extends Action {
  handle(data: { guild_id: string; role: { id: string } }): { role: Role | undefined } {
    // 应用约束1: 使用具体类型替代any
    const client = this.client;
    // 应用约束24: 使用类替代对象字面量类型
    const guild = client.guilds.get(data.guild_id);
    let role: Role | undefined;
    
    if (guild) {
      // 应用约束21: 使用Map的标准访问方式
      const already = guild.roles.has(data.role.id);
      // 应用约束12: 使用具体构造方式
      role = new Role(guild, data.role);
      guild.roles.set(role.id, role);
      
      // 应用约束21: 使用点操作符访问属性
      if (!already) {
        // 应用约束30: 使用as进行类型转换
        client.emit(Constants.Events.GUILD_ROLE_CREATE as string, role);
      }
    }
    return { role };
  }
}

/**
 * Emitted whenever a role is created.
 * @event Client#roleCreate
 * @param {Role} role The role that was created
 */

// 应用约束60: 使用ES模块导出
export default GuildRoleCreate;
