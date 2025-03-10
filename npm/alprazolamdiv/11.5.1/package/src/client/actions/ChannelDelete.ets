// 应用约束60: 使用import代替require
import Action from './Action.ets';

class ChannelDeleteAction extends Action {
  // 应用约束18: 类字段需在类中显式声明
  client: any;
  deleted: Map<string, any> = new Map<string, any>();

  // 应用约束18: 构造函数参数需在类字段中声明
  constructor(client: any) {
    super(client);
    this.client = client;
  }

  handle(data: { id: string }): { channel: any } {
    const client = this.client;

    // 应用约束21: 使用点操作符访问属性
    let channel: any = client.channels.get(data.id);
    if (channel) {
      client.dataManager.killChannel(channel);
      this.deleted.set(channel.id, channel);
      this.scheduleForDeletion(channel.id);
    } else {
      channel = this.deleted.get(data.id) || null;
    }
    if (channel) channel.deleted = true;

    return { channel };
  }

  scheduleForDeletion(id: string): void {
    // 应用约束9: 使用let代替var，应用约束26: 使用箭头函数
    this.client.setTimeout(() => {
      this.deleted.delete(id);
    }, this.client.options.restWsBridgeTimeout);
  }
}

// 应用约束60: 使用export代替module.exports
export default ChannelDeleteAction;

// 应用约束说明：
// 1. 需要显式声明类属性并在构造函数中初始化（约束18）
// 2. 使用Map时需要指定泛型类型参数（约束14）
// 3. 使用箭头函数代替函数表达式（约束26）
// 4. 使用import/export代替CommonJS模块系统（约束60）
// 5. 参数和变量需要显式类型标注（约束10）
// 6. 使用Map的泛型形式new Map<string, any>()（约束14）
// 注：实际项目中应尽量避免使用any类型，这里为保持原始逻辑暂时保留
// 建议后续为client/dataManager等对象添加具体接口类型定义
