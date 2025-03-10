// 应用ArkTS约束：
// 1. 使用import代替require（约束60,61）
// 2. 类属性显式声明（约束18）
// 3. 使用let代替var（约束9）
// 4. 类型显式标注（约束10,23）
// 5. 使用箭头函数绑定this（约束26,48）
// 6. 错误处理使用Error类（约束44）

import Collection from '../../util/Collection.ets';
import VoiceConnection from './VoiceConnection.ets';

class ClientVoiceManager {
    // 显式声明类属性（约束18）
    client: any; // 需替换为具体的Client类型
    connections: Collection<string, VoiceConnection>;

    constructor(client: any) { // 需替换为具体的Client类型
        this.client = client;
        this.connections = new Collection();

        // 使用箭头函数绑定this（约束26,48）
        this.client.on('self.voiceServer', (data: any) => this.onVoiceServer(data));
        this.client.on('self.voiceStateUpdate', (data: any) => this.onVoiceStateUpdate(data));
    }

    onVoiceServer(data: any): void {
        const { guild_id, token, endpoint } = data;
        const connection = this.connections.get(guild_id);
        if (connection) connection.setTokenAndEndpoint(token, endpoint);
    }

    onVoiceStateUpdate(data: any): void {
        const { guild_id, session_id, channel_id } = data;
        const connection = this.connections.get(guild_id);
        if (connection) {
            connection.channel = this.client.channels.get(channel_id);
            connection.setSessionID(session_id);
        }
    }

    joinChannel(channel: any): Promise<VoiceConnection> { // 需替换为具体的VoiceChannel类型
        return new Promise((resolve, reject) => {
            if (!channel.joinable) {
                reject(channel.full ? 
                    new Error('You do not have permission to join this voice channel; it is full.') :
                    new Error('You do not have permission to join this voice channel.'));
                return;
            }

            let connection = this.connections.get(channel.guild.id);

            if (connection) {
                if (connection.channel.id !== channel.id) {
                    connection.updateChannel(channel);
                }
                resolve(connection);
                return;
            }

            const newConnection = new VoiceConnection(this, channel);
            this.connections.set(channel.guild.id, newConnection);

            newConnection.once('failed', (reason: any) => {
                this.connections.delete(channel.guild.id);
                reject(reason);
            });

            newConnection.once('authenticated', () => {
                newConnection.once('ready', () => resolve(newConnection));
                newConnection.once('error', (err: any) => reject(err));
                newConnection.once('disconnect', () => 
                    this.connections.delete(channel.guild.id));
            });
        });
    }
}

export default ClientVoiceManager;
