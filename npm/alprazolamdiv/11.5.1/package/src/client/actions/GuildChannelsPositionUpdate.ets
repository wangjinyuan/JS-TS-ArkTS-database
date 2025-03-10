// 应用约束60: 使用import代替require
import Action from './Action.ets';

// 应用约束24: 使用接口替代对象字面量类型
interface Data {
    guild_id: string;
    channels: ChannelPartial[];
}

interface ChannelPartial {
    id: string;
    position: number;
}

interface Guild {
    channels: Map<string, Channel>;
}

interface Channel {
    position: number;
}

class GuildChannelsPositionUpdate extends Action {
    // 应用约束1: 为client添加明确类型声明（假设Client类型已定义）
    handle(data: Data): { guild: Guild | undefined } {
        const client = this.client;

        // 应用约束1: 为guild添加类型声明
        const guild: Guild | undefined = client.guilds.get(data.guild_id);
        if (guild) {
            // 应用约束1: 为partialChannel添加类型声明
            for (const partialChannel of data.channels) {
                const channel: Channel | undefined = guild.channels.get(partialChannel.id);
                if (channel) channel.position = partialChannel.position;
            }
        }

        return { guild };
    }
}

// 应用约束60: 使用ES模块导出
export default GuildChannelsPositionUpdate;
