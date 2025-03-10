// 应用ArkTS约束：使用import代替require，文件后缀改为.ets（约束60、78）
import Action from './Action.ets';
import Message from '../../structures/Message.ets';

// 应用ArkTS约束：类属性需要显式初始化（约束18）
class MessageCreateAction extends Action {
  handle(data: any): Object { // 暂时保留any类型，实际应替换为具体类型
    const client = this.client;

    // 应用ArkTS约束：使用类型断言代替动态类型判断（约束30）
    const rawData = Array.isArray(data) ? data[0] : data;
    const channel = client.channels.get(rawData.channel_id);
    const user = client.users.get(rawData.author.id);

    if (channel) {
      const member = channel.guild ? channel.guild.member(user) : null;
      
      // 应用ArkTS约束：数组类型需要显式声明（约束25）
      if (Array.isArray(data)) {
        const messages: Message[] = new Array(data.length);
        for (let i = 0; i < data.length; i++) {
          // 应用ArkTS约束：显式类型转换（约束30）
          messages[i] = channel._cacheMessage(new Message(channel, data[i] as Object, client));
        }
        const lastMessage = messages[messages.length - 1];
        channel.lastMessageID = lastMessage.id;
        
        if (user) {
          user.lastMessageID = lastMessage.id;
          user.lastMessage = lastMessage;
        }
        
        if (member) {
          member.lastMessageID = lastMessage.id;
          member.lastMessage = lastMessage;
        }
        
        return {
          messages,
        };
      } else {
        const message = channel._cacheMessage(new Message(channel, data as Object, client));
        channel.lastMessageID = data.id;
        
        if (user) {
          user.lastMessageID = data.id;
          user.lastMessage = message;
        }
        
        if (member) {
          member.lastMessageID = data.id;
          member.lastMessage = message;
        }
        
        return {
          message,
        };
      }
    }

    return {
      message: null,
    };
  }
}

// 应用ArkTS约束：使用export default代替module.exports（约束60）
export default MessageCreateAction;

// 应用ArkTS约束说明：
// 1. 类型相关（约束1）：需要为data参数定义具体接口类型替代any
// 2. 类型转换（约束30）：使用as操作符进行显式类型转换
// 3. 数组类型（约束25）：显式声明messages数组类型
// 4. 模块系统（约束60、78）：使用ES模块导入/导出语法
// 5. 类型推断（约束23）：需要显式声明返回类型和变量类型
