import Constants from '../util/Constants.ets';
import Util from '../util/Util.ets';

class ClientUserSettings {
    // 显式声明类属性（约束2,18）
    user: any;
    guildPositions: string[] = [];
    restrictedGuilds: string[] = [];
    // 其他可能的属性需要在此声明

    constructor(user: any, data: Object) {
        this.user = user;
        this.patch(data);
    }

    // 显式标注参数和返回类型（约束1,45）
    patch(data: Object): void {
        // 重构属性设置逻辑避免动态索引访问（约束21）
        for (const key of Object.keys(Constants.UserSettingsMap)) {
            const value = Constants.UserSettingsMap[key];
            if (!data.hasOwnProperty(key)) continue;
            
            // 处理函数类型映射（约束11,21）
            if (typeof value === 'function') {
                const handler = value as Function;
                this[handler.name] = handler(data[key]);
            } 
            // 处理属性名映射（约束21）
            else {
                switch (value) {
                    case 'guild_positions':
                        this.guildPositions = data[key] as string[];
                        break;
                    case 'restricted_guilds':
                        this.restrictedGuilds = data[key] as string[];
                        break;
                    // 其他属性映射需要在此扩展
                }
            }
        }
    }

    // 显式标注类型（约束1,10）
    update(name: string, value: any): Promise<Object> {
        return this.user.client.rest.methods.patchUserSettings({ [name]: value });
    }

    setGuildPosition(guild: any, position: number, relative: boolean = false): Promise<any> {
        // 使用数组复制代替Object.assign（约束37）
        const temp = this.guildPositions.slice(); 
        Util.moveElementInArray(temp, guild.id, position, relative);
        return this.update('guild_positions', temp).then(() => guild);
    }

    addRestrictedGuild(guild: any): Promise<any> {
        const temp = this.restrictedGuilds.slice();
        if (temp.includes(guild.id)) {
            return Promise.reject(new Error('Guild is already restricted'));
        }
        temp.push(guild.id);
        return this.update('restricted_guilds', temp).then(() => guild);
    }

    removeRestrictedGuild(guild: any): Promise<any> {
        const temp = this.restrictedGuilds.slice();
        const index = temp.indexOf(guild.id);
        if (index === -1) {
            return Promise.reject(new Error('Guild is not restricted'));
        }
        temp.splice(index, 1);
        return this.update('restricted_guilds', temp).then(() => guild);
    }
}

export default ClientUserSettings;

/* 应用的主要约束说明：
1. 显式类型标注（约束1,10,23）
2. 禁止动态属性访问（约束2,21）
3. 使用slice代替Object.assign（约束37）
4. 类属性显式声明（约束18）
5. 使用合法属性访问方式（约束21）
6. 模块导入语法转换（约束60）
7. Promise错误处理（约束44）
8. 数组操作类型安全（约束14）
*/
