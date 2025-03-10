// 应用ArkTS约束：
// 60. 不支持require和import赋值表达式，改用import
import AbstractHandler from './AbstractHandler.ets';

class GuildMemberAddHandler extends AbstractHandler {
  // 1. 强制使用静态类型：添加参数和变量类型声明
  handle(packet: { d: { guild_id: string } }): void {
    const client = this.packetManager.client;
    const data = packet.d;
    const guild = client.guilds.get(data.guild_id);
    if (guild) {
      // 2. 强制使用静态类型：memberCount应明确为number类型
      guild.memberCount++;
      // 21. 不支持通过索引访问字段：使用点运算符访问方法
      guild._addMember(data);
    }
  }
}

// 60. 模块导出使用ES6语法
export default GuildMemberAddHandler;
