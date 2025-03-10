// 应用约束60: 使用import代替require
import Action from './Action.ets';
import Constants from '../../util/Constants.ets';

// 应用约束7: 使用private关键字代替#私有字段
// 应用约束18: 在class中声明字段
class GuildDeleteAction extends Action {
    // 应用约束10: 显式指定具体类型
    private deleted: Map<string, any>;
    // 应用约束9: 使用let代替var
    private client: any;

    constructor(client: any) {
        super(client);
        this.client = client;
        this.deleted = new Map<string, any>();
    }

    // 应用约束10: 显式指定参数类型
    handle(data: any): { guild: any } {
        const client = this.client;

        // 应用约束21: 使用Map.get方法代替属性访问
        let guild = client.guilds.get(data.id);
        if (guild) {
            // 应用约束26: 使用箭头函数
            guild.channels.values().forEach((channel: any) => {
                if (channel.type === 'text') channel.stopTyping(true);
            });

            if (guild.available && data.unavailable) {
                // 应用约束2: 通过属性赋值代替delete
                guild.available = false;
                client.emit(Constants.Events.GUILD_UNAVAILABLE, guild);

                return {
                    guild: null
                };
            }

            // 应用约束21: 使用Map.delete方法
            guild.channels.values().forEach((channel: any) => {
                this.client.channels.delete(channel.id);
            });
            if (guild.voiceConnection) guild.voiceConnection.disconnect();

            client.guilds.delete(guild.id);
            this.deleted.set(guild.id, guild);
            this.scheduleForDeletion(guild.id);
        } else {
            guild = this.deleted.get(data.id) || null;
        }
        if (guild) guild.deleted = true;

        return { guild };
    }

    // 应用约束10: 显式指定参数类型
    private scheduleForDeletion(id: string): void {
        // 应用约束30: 使用as进行类型断言
        this.client.setTimeout(
            () => this.deleted.delete(id), 
            this.client.options.restWsBridgeTimeout as number
        );
    }
}

// 应用约束60: 使用export代替module.exports
export default GuildDeleteAction;

/**
 * Emitted whenever a guild becomes unavailable, likely due to a server outage.
 * @event Client#guildUnavailable
 * @param {Guild} guild The guild that has become unavailable
 */

// 应用约束24: 使用类代替对象字面量类型
class GuildEventParams {
    guild: any = null;
}
