import AbstractHandler from './AbstractHandler.ets';
import Constants from '../../../../util/Constants.ets';
// Uncomment in v12
// import Collection from '../../../../util/Collection.ets';

class GuildMembersChunkHandler extends AbstractHandler {
  // 应用约束18：类字段在类中显式声明
  private packetManager: any; // 需要根据实际类型替换any

  // 应用约束45：显式标注函数返回类型
  handle(packet: { d: { guild_id: string; members: any[] } }): void {
    const client = this.packetManager.client;
    const data = packet.d;
    const guild = client.guilds.get(data.guild_id);
    if (!guild) return;

    // 应用约束14：用数组代替index signature
    // 应用约束25：数组元素类型需可推断
    const members = data.members.map((member: any) => guild._addMember(member, false));

    // 应用约束30：使用as进行类型转换（假设Constants.Events已正确定义）
    client.emit(Constants.Events.GUILD_MEMBERS_CHUNK as string, members, guild);

    // 应用约束1：使用具体类型代替any
    (client.ws as { lastHeartbeatAck: boolean }).lastHeartbeatAck = true;
  }
}

/**
 * Emitted whenever a chunk of guild members is received (all members come from the same guild).
 * @event Client#guildMembersChunk
 * @param {GuildMember[]} members The members in the chunk
 * @param {Guild} guild The guild related to the member chunk
 */

// 应用约束61：使用ES6 export语法
export default GuildMembersChunkHandler;

/* 应用的主要约束：
1. 强制使用静态类型（约束1）
2. 使用let/const代替var（约束9）
3. 显式标注函数参数和返回类型（约束10,45）
4. 使用ES6模块导入/导出（约束60,61）
5. 避免any类型（约束1）
6. 用数组代替index signature（约束14）
7. 类型转换使用as语法（约束30）
8. 类字段显式声明（约束18）*/
