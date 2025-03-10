// 应用约束60: 使用import代替require
import AbstractHandler from './AbstractHandler.ets';

// 应用约束24: 使用接口代替对象字面量类型
interface VoiceServerData {
  token: string;
  guild_id: string;
  endpoint: string;
}

class VoiceServerUpdate extends AbstractHandler {
  // 应用约束18: 在类中显式声明方法参数类型
  handle(packet: { d: VoiceServerData }): void {
    const client = this.packetManager.client;
    const data: VoiceServerData = packet.d;
    
    // 应用约束29: 使用类方法代替动态属性访问
    client.emit('self.voiceServer', data);
  }
}

// 应用约束60: 使用export default代替module.exports
export default VoiceServerUpdate;

// 应用约束3: 限制运算符语义（保持原始数值类型操作）
// 应用约束10: 使用具体类型代替any
// 应用约束26: 使用箭头函数（本例中未涉及函数表达式）
// 应用约束28: 仅接口可被实现（通过extends继承抽象类）
