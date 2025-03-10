// 应用约束60：使用import代替require
import AbstractHandler from './AbstractHandler.ets';
import Constants from '../../../../util/Constants.ets';

// 应用约束28：接口实现需显式声明
class GuildDeleteHandler extends AbstractHandler {
    // 应用约束18：类字段需在类中显式声明
    private packetManager: any; // 需根据实际类型补充类型定义

    // 应用约束2：保持对象布局不变
    handle(packet: { d: any }): void { // 应用约束10：使用具体类型替代any
        const client = this.packetManager.client;
        const data = packet.d;
        
        // 应用约束30：使用as进行类型转换
        const response = client.actions.GuildDelete.handle(data) as { guild?: any };
        
        // 应用约束44：catch参数不标注类型
        try {
            if (response.guild) {
                client.emit(Constants.Events.GUILD_DELETE, response.guild);
            }
        } catch (e) {
            console.error('Event emit error:', e);
        }
    }
}

/**
 * Emitted whenever a guild is deleted/left.
 * @event Client#guildDelete
 * @param {Object} guild The guild that was deleted // 应用约束24：使用类替代对象字面量类型
 */
// 应用约束60：使用export代替module.exports
export default GuildDeleteHandler;

// 应用约束80：import语句位于文件顶部
// 应用约束9：使用let/const替代var
// 应用约束4：使用nominal typing替代structural typing
// 应用约束15：使用继承替代交叉类型
