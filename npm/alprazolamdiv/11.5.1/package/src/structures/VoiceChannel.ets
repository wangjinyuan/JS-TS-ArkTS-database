// 应用约束60: 使用import代替require
import GuildChannel from './GuildChannel.ets';
import Collection from '../util/Collection.ets';
import Permissions from '../util/Permissions.ets';

// 应用约束28: 接口继承代替类继承
interface IVoiceChannel extends GuildChannel {
    bitrate: number;
    userLimit: number;
    members: Collection<string, GuildMember>;
    connection: VoiceConnection | null;
    full: boolean;
    deletable: boolean;
    joinable: boolean;
    speakable: boolean;
}

// 应用约束18: 类属性显式声明
class VoiceChannel extends GuildChannel implements IVoiceChannel {
    members: Collection<string, GuildMember> = new Collection();
    bitrate: number = 0;
    userLimit: number = 0;
    type: string = 'voice';

    // 应用约束1: 显式参数类型
    constructor(guild: Guild, data: VoiceChannelData) {
        super(guild, data);
        this.setup(data);
    }

    // 应用约束10: 显式参数和返回类型
    setup(data: VoiceChannelData): void {
        super.setup(data);
        this.bitrate = data.bitrate * 0.001;
        this.userLimit = data.user_limit;
    }

    // 应用约束45: 显式返回类型
    get connection(): VoiceConnection | null {
        const connection = this.guild.voiceConnection;
        return connection?.channel.id === this.id ? connection : null;
    }

    get full(): boolean {
        return this.userLimit > 0 && this.members.size >= this.userLimit;
    }

    get deletable(): boolean {
        return super.deletable && 
            this.permissionsFor(this.client.user).has(Permissions.FLAGS.CONNECT);
    }

    get joinable(): boolean {
        if (this.client.browser) return false;
        return this.permissionsFor(this.client.user).has('CONNECT') && 
            (!this.full || this.permissionsFor(this.client.user).has('MOVE_MEMBERS'));
    }

    get speakable(): boolean {
        return this.permissionsFor(this.client.user).has('SPEAK');
    }

    // 应用约束46: 显式参数类型
    async setBitrate(bitrate: number, reason?: string): Promise<VoiceChannel> {
        return this.edit({ bitrate: bitrate * 1000 }, reason);
    }

    async setUserLimit(userLimit: number, reason?: string): Promise<VoiceChannel> {
        return this.edit({ userLimit }, reason);
    }

    join(): Promise<VoiceConnection> {
        if (this.client.browser) {
            return Promise.reject(new Error('Voice connections are not available in browsers.'));
        }
        return this.client.voice.joinChannel(this);
    }

    leave(): void {
        if (this.client.browser) return;
        const connection = this.client.voice.connections.get(this.guild.id);
        connection?.disconnect();
    }
}

// 应用约束61: 使用export代替module.exports
export default VoiceChannel;

// 补充类型定义（假设存在于其他模块）
interface VoiceChannelData {
    bitrate: number;
    user_limit: number;
}

interface Guild {
    voiceConnection: VoiceConnection;
}

interface VoiceConnection {
    channel: { id: string };
    disconnect(): void;
}

interface GuildMember {}
type Snowflake = string;

interface Client {
    user: User;
    browser: boolean;
    voice: {
        joinChannel(channel: VoiceChannel): Promise<VoiceConnection>;
        connections: Map<string, VoiceConnection>;
    };
}

interface User {
    // 用户属性定义
}
