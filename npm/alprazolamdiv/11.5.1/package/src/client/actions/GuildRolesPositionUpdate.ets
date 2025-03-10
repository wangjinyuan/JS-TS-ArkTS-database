// 应用约束60: 使用import代替require
import Action from './Action.ets';

class GuildRolesPositionUpdate extends Action {
  // 应用约束10: 为参数添加具体类型（假设Data类型已定义）
  handle(data: { guild_id: string; roles: Array<{ id: string; position: number }>}): { guild: any } {
    const client = this.client;

    // 应用约束21: 使用Map的标准访问方式
    const guild = client.guilds.get(data.guild_id);
    if (guild) {
      for (const partialRole of data.roles) {
        const role = guild.roles.get(partialRole.id);
        if (role) role.position = partialRole.position;
      }
    }

    return { guild };
  }
}

// 应用约束60: 使用export default代替module.exports
export default GuildRolesPositionUpdate;

// 假设以下类型在相关文件中已定义（根据实际需要补充）：
// interface Client {
//   guilds: Map<string, Guild>;
// }
// 
// class Guild {
//   roles: Map<string, Role>;
// }
// 
// class Role {
//   position: number = 0;
// }
