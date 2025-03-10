// 应用规则60: 使用import代替require
import Action from './Action.ets';
import Constants from '../../util/Constants.ets';

class MessageUpdateAction extends Action {
  // 应用规则1: 显式声明方法参数类型和返回类型
  handle(data: Object): { old: Object | null, updated: Object | null } {
    const client = this.client;

    // 应用规则14: 使用Map的get方法代替索引签名访问
    const channel = client.channels.get(data['channel_id']);
    if (channel) {
      const message = channel.messages.get(data['id']);
      if (message) {
        message.patch(data);
        // 应用规则14: 使用Map访问代替索引签名
        client.emit(Constants.Events.MESSAGE_UPDATE, message._edits[0], message);
        return {
          old: message._edits[0],
          updated: message,
        };
      }

      return {
        old: message,
        updated: message,
      };
    }

    return {
      old: null,
      updated: null,
    };
  }
}

/**
 * Emitted whenever a message is updated - e.g. embed or content change.
 * @event Client#messageUpdate
 * @param {Message} oldMessage The message before the update
 * @param {Message} newMessage The message after the update
 */

// 应用规则60: 使用export default代替module.exports
export default MessageUpdateAction;
