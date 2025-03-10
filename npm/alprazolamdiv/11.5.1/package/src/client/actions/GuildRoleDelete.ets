// 应用ArkTS约束：
// 1. 使用import代替require（约束60, 61）
// 2. 类属性显式声明（约束18）
// 3. 类型标注（约束1, 10, 23）
// 4. 使用let/const代替var（约束9）
// 5. 使用ES6模块导出（约束60, 61）
// 6. 方法参数和返回值类型声明（约束1, 10）
// 7. 不支持在构造函数参数声明字段（约束18）

import Action from './Action.ets';
import Constants from '../../util/Constants.ets';
import type { Client } from '../../client/Client.ets'; // 假设Client类型定义
import type { Guild } from '../../structures/Guild.ets';
import type { Role } from '../../structures/Role.ets';

interface GuildRoleDeleteData {
  guild_id: string;
  role_id: string;
}

class GuildRoleDeleteAction extends Action {
  // 显式声明类属性（约束18）
  deleted: Map<string, Role> = new Map();

  constructor(client: Client) {
    super(client);
  }

  handle(data: GuildRoleDeleteData): { role: Role | null } {
    const client: Client = this.client;
    const guild: Guild | undefined = client.guilds.get(data.guild_id);
    let role: Role | null = null;

    if (guild) {
      role = guild.roles.get(data.role_id) || null;
      if (role) {
        guild.roles.delete(data.role_id);
        this.deleted.set(guild.id + data.role_id, role);
        this.scheduleForDeletion(guild.id, data.role_id);
        client.emit(Constants.Events.GUILD_ROLE_DELETE, role);
      } else {
        role = this.deleted.get(guild.id + data.role_id) || null;
      }
      if (role) role.deleted = true; // 假设Role类已声明deleted属性
    }

    return { role };
  }

  scheduleForDeletion(guildID: string, roleID: string): void {
    this.client.setTimeout(
      () => this.deleted.delete(guildID + roleID),
      this.client.options.restWsBridgeTimeout
    );
  }
}

/**
 * Emitted whenever a guild role is deleted.
 * @event Client#roleDelete
 * @param {Role} role The role that was deleted
 */
export default GuildRoleDeleteAction;
