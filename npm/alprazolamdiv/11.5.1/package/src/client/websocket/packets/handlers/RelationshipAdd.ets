// 应用约束60: 使用import代替require
import AbstractHandler from './AbstractHandler.ets';

// 应用约束15: 使用继承替代交叉类型
class RelationshipAddHandler extends AbstractHandler {
  handle(packet: { d: { type: number; id: string } }): void {
    const client = this.packetManager.client;
    const data = packet.d;
    
    // 应用约束25: 显式类型标注
    if (data.type === 1) {
      client.fetchUser(data.id).then((user: { id: string }) => {
        // 应用约束21: 使用Map代替动态属性
        client.user.friends.set(user.id, user);
      });
    } else if (data.type === 2) {
      client.fetchUser(data.id).then((user: { id: string }) => {
        client.user.blocked.set(user.id, user);
      });
    }
  }
}

// 应用约束60: 使用ES模块导出
export default RelationshipAddHandler;

/* 补充类型定义（根据实际业务需要定义）：
interface User {
  id: string;
}

interface Client {
  user: {
    friends: Map<string, User>;
    blocked: Map<string, User>;
  };
  fetchUser(id: string): Promise<User>;
}
*/
