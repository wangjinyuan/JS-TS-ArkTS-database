// 应用ArkTS约束：
// 1. 使用import代替require（约束60）
// 2. 使用export default代替module.exports（约束60）
// 3. 显式声明类属性（约束18）
// 4. 添加类型注解（约束1,10）
// 5. 使用箭头函数表达式（约束26,47）
import AbstractHandler from './AbstractHandler.ets';

class GuildCreateHandler extends AbstractHandler {
  // 假设packetManager已在AbstractHandler父类中声明
  // 假设client属性已在AbstractHandler父类中声明
  
  handle(packet: any): void { // 建议替换any为具体类型
    const client = this.packetManager.client;
    const data = packet.d as { // 类型断言代替动态类型
      id: string,
      unavailable?: boolean,
      [key: string]: any
    };

    const guild = client.guilds.get(data.id);
    if (guild) {
      if (!guild.available && !data.unavailable) {
        // A newly available guild
        guild.setup(data);
        this.packetManager.ws.checkIfReady();
      }
    } else {
      // A new guild
      client.dataManager.newGuild(data);
    }
  }
}

export default GuildCreateHandler;
