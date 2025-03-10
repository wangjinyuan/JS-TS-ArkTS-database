import AbstractHandler from './AbstractHandler.ets';

class GuildMemberUpdateHandler extends AbstractHandler {
  // 应用约束9：使用let/const代替var
  // 应用约束1：禁止使用any类型，需为packet参数添加具体类型（此处假设有合适的类型定义）
  handle(packet: { d: { guild_id: string, user: { id: string } } }): void {
    // 应用约束48：类方法中this使用符合要求
    const client = this.packetManager.client;
    const data = packet.d;

    // 应用约束21：使用Map的get方法代替属性访问
    const guild = client.guilds.get(data.guild_id);
    if (guild) {
      const member = guild.members.get(data.user.id);
      // 应用约束21：使用合法属性访问
      if (member) guild._updateMember(member, data);
    }
  }
}

// 应用约束60/61：使用ES模块导出代替require/module.exports
export default GuildMemberUpdateHandler;
