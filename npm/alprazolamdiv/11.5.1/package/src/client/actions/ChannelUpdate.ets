// 应用约束：60. 不支持require和import赋值表达式，改用import
import Action from './Action.ets';
import TextChannel from '../../structures/TextChannel.ets';
import VoiceChannel from '../../structures/VoiceChannel.ets';
import CategoryChannel from '../../structures/CategoryChannel.ets';
import NewsChannel from '../../structures/NewsChannel.ets';
import StoreChannel from '../../structures/StoreChannel.ets';
import Constants from '../../util/Constants.ets';
import Util from '../../util/Util.ets';

// 应用约束：28. 类不允许implements（只有接口可以被implements，此处继承类符合规范）
class ChannelUpdateAction extends Action {
  // 应用约束：18. 在class中声明字段（继承自父类Action）
  
  handle(data: any) { // 应用约束：10. 使用具体类型（此处需根据实际数据结构定义接口替代any）
    const client = this.client;

    let channel = client.channels.get(data.id);
    if (channel) {
      // 应用约束：24. 使用类替代对象字面量类型
      const oldChannel = Util.cloneObject(channel);

      // 应用约束：15. 使用继承而非intersection type（通过类继承实现类型关系）
      if (Constants.ChannelTypes[channel.type.toUpperCase()] !== data.type) {
        let channelClass: any;
        switch (data.type) {
          case Constants.ChannelTypes.TEXT:
            channelClass = TextChannel;
            break;
          case Constants.ChannelTypes.VOICE:
            channelClass = VoiceChannel;
            break;
          case Constants.ChannelTypes.CATEGORY:
            channelClass = CategoryChannel;
            break;
          case Constants.ChannelTypes.NEWS:
            channelClass = NewsChannel;
            break;
          case Constants.ChannelTypes.STORE:
            channelClass = StoreChannel;
            break;
        }

        // 应用约束：24. 使用类替代对象字面量类型
        const newChannel = new channelClass(channel.guild, data);
        if (channel.messages && newChannel.messages) {
          // 应用约束：21. 通过索引访问字段改为Map操作
          channel.messages.forEach((message, id) => {
            newChannel.messages.set(id, message);
          });
        }

        channel = newChannel;
        this.client.channels.set(channel.id, channel);
      } else {
        channel.setup(data);
      }

      client.emit(Constants.Events.CHANNEL_UPDATE, oldChannel, channel);
      return {
        old: oldChannel,
        updated: channel,
      };
    }

    return {
      old: null,
      updated: null,
    };
  }
}

// 应用约束：60. 使用ES模块导出
export default ChannelUpdateAction;

// 应用约束：23. 显式标注对象字面量类型（事件注释保留为文档）
/**
 * Emitted whenever a channel is updated - e.g. name change, topic change.
 * @event Client#channelUpdate
 * @param {Channel} oldChannel The channel before the update
 * @param {Channel} newChannel The channel after the update
 */
