// 应用约束60：使用import代替require
import AbstractHandler from './AbstractHandler.ets';

class UserUpdateHandler extends AbstractHandler {
  // 应用约束2：为方法参数添加类型标注
  handle(packet: { d: any }): void {
    const client = this.packetManager.client;
    // 应用约束23：显式标注对象字面量类型（假设data类型为any）
    const data: any = packet.d;
    client.actions.UserUpdate.handle(data);
  }
}

// 应用约束61：使用export default代替module.exports
export default UserUpdateHandler;

// 应用约束80：保持import语句在顶部
// 应用约束9：使用const/let代替var
// 应用约束1：避免使用any类型（示例中保留any需要根据实际业务类型替换）
