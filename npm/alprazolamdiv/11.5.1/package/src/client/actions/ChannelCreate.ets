// 应用约束60: 使用import代替require
import Action from './Action.ets';

class ChannelCreateAction extends Action {
  handle(data: Object): { channel: Object } { // 应用约束1: 添加参数和返回类型
    const client = this.client;
    const channel = client.dataManager.newChannel(data);
    return { channel };
  }
}

// 应用约束60: 使用export default代替module.exports
export default ChannelCreateAction;
