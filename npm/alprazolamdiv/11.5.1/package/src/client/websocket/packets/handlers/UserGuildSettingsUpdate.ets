// 应用约束60: 使用import代替require
import AbstractHandler from './AbstractHandler.ets';
import Constants from '../../../../util/Constants.ets';
import ClientUserGuildSettings from '../../../../structures/ClientUserGuildSettings.ets';

// 应用约束1: 强制使用静态类型
interface PacketData {
    guild_id: string;
    // 根据实际数据结构补充其他字段
}

class UserGuildSettingsUpdateHandler extends AbstractHandler {
    // 应用约束1: 显式声明方法参数类型
    handle(packet: { d: PacketData }): void {
        const client = this.packetManager.client;
        
        // 应用约束21: 使用Map类型代替动态属性访问
        const settings = client.user.guildSettings.get(packet.d.guild_id);
        
        if (settings) {
            settings.patch(packet.d);
        } else {
            // 应用约束1: 显式类型声明
            client.user.guildSettings.set(
                packet.d.guild_id,
                new ClientUserGuildSettings(packet.d, client)
            );
        }
        
        // 应用约束1: 事件参数类型需要匹配
        client.emit(
            Constants.Events.USER_GUILD_SETTINGS_UPDATE,
            client.user.guildSettings.get(packet.d.guild_id)
        );
    }
}

/**
 * Emitted whenever the client user's settings update.
 * @event Client#clientUserGuildSettingsUpdate
 * @param {ClientUserGuildSettings} clientUserGuildSettings The new client user guild settings
 */

// 应用约束61: 使用export default代替module.exports
export default UserGuildSettingsUpdateHandler;
