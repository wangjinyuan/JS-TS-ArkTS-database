// 应用约束60：改用import语法，并将文件后缀转换为.ets
import AbstractHandler from './AbstractHandler.ets';

class UserNoteUpdateHandler extends AbstractHandler {
  // 应用约束1：为方法参数添加类型声明（这里使用Object代替any类型）
  handle(packet: { d: Object }): void {
    const client = this.packetManager.client;
    // 应用约束1：显式声明data类型为Object
    const data: Object = packet.d;

    // 应用约束30：使用as进行类型转换（假设handle方法需要特定类型）
    client.actions.UserNoteUpdate.handle(data as unknown);
  }
}

// 应用约束61：使用export default代替module.exports
export default UserNoteUpdateHandler;
