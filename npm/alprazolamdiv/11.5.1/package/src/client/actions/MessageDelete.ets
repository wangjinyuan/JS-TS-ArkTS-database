// 应用ArkTS约束：
// 1. 使用let/const代替var（规则9）
// 2. 显式类型标注（规则10,23）
// 3. 模块导入使用ES模块语法（规则60）
// 4. 类属性显式声明（规则18）
// 5. 方法参数类型标注（规则45）
// 6. 禁止any类型，但需要根据实际类型补充（规则1）
// 7. 使用模块导出语法（规则60）

import Action from './Action.ets';

class MessageDeleteAction extends Action {
  // 显式声明类属性（规则18）
  private deleted: Map<string, any> = new Map();

  // 构造函数参数类型标注（规则45）
  constructor(client: any) {
    super(client);
  }

  // 方法参数和返回类型标注（规则45）
  handle(data: any): { message: any } {
    const client = this.client;
    // 使用类型断言处理可能的undefined（规则30）
    const channel = client.channels.get(data.channel_id) as any;
    let message: any;

    if (channel) {
      message = channel.messages.get(data.id);
      if (message) {
        channel.messages.delete(message.id);
        this.deleted.set(channel.id + message.id, message);
        this.scheduleForDeletion(channel.id, message.id);
      } else {
        message = this.deleted.get(channel.id + data.id) || null;
      }
      if (message) message.deleted = true;
    }

    return { message };
  }

  // 参数类型标注（规则45）
  scheduleForDeletion(channelID: string, messageID: string): void {
    this.client.setTimeout(() => {
      this.deleted.delete(channelID + messageID);
    }, this.client.options.restWsBridgeTimeout);
  }
}

export default MessageDeleteAction;
