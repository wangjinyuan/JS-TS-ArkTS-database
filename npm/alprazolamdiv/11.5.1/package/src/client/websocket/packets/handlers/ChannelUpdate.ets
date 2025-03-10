// 应用约束60：使用import代替require
import AbstractHandler from './AbstractHandler.ets';

class ChannelUpdateHandler extends AbstractHandler {
  // 应用约束1：添加参数类型和返回值类型，用Object代替any
  handle(packet: Object): void {
    // 应用约束21：属性访问需符合静态类型要求（假设packetManager在父类已声明）
    const client = this.packetManager.client;
    // 应用约束1：使用具体类型代替any，这里保持JS访问方式但需确保类型安全
    const data = (packet as Record<string, Object>).d;
    
    // 应用约束21：链式调用需符合静态类型要求（假设actions结构已正确定义）
    client.actions.ChannelUpdate.handle(data);
  }
}

// 应用约束60：使用ES模块导出代替module.exports
export default ChannelUpdateHandler;
