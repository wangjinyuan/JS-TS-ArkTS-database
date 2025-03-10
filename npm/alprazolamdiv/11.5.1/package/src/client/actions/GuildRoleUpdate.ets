// 应用ArkTS约束：
// 1. 使用import代替require (约束60, 61)
// 2. 使用let/const代替var (约束9)
// 3. 添加类型注解 (约束1, 10)
// 4. 使用箭头函数 (约束26)
// 5. 显式类型声明 (约束23)
// 6. 模块导出语法 (约束60, 61)

import Action from './Action.ets';
import Constants from '../../util/Constants.ets';
import Util from '../../util/Util.ets';

// 假设已定义的接口和类
interface GuildData {
    guild_id: string;
    role: RoleData;
}

interface RoleData {
    id: string;
    // 其他角色属性
}

class Role {
    id: string = '';
    
    setup(data: RoleData): void {
        this.id = data.id;
        // 其他属性设置
    }
}

class Guild {
    roles: Map<string, Role> = new Map();
}

class Client {
    guilds: Map<string, Guild> = new Map();
    emit(event: string, ...args: any[]): void {}
}

class GuildRoleUpdateAction extends Action {
    handle(data: GuildData): { old: Role | null; updated: Role | null } {
        const client = this.client as Client;
        const guild = client.guilds.get(data.guild_id);

        if (guild) {
            const roleData = data.role;
            let oldRole: Role | null = null;

            const role = guild.roles.get(roleData.id);
            if (role) {
                oldRole = Util.cloneObject(role) as Role;
                role.setup(roleData);
                client.emit(Constants.Events.GUILD_ROLE_UPDATE, oldRole, role);
            }

            return {
                old: oldRole,
                updated: role || null,
            };
        }

        return {
            old: null,
            updated: null,
        };
    }
}

/**
 * Emitted whenever a guild role is updated.
 * @event Client#roleUpdate
 * @param {Role} oldRole The role before the update
 * @param {Role} newRole The role after the update
 */

export default GuildRoleUpdateAction;
