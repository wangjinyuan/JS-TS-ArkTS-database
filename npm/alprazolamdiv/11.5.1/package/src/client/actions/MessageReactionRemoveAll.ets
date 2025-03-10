// 应用ArkTS约束：使用import代替require，文件后缀改为.ets（约束60, 78）
import Action from './Action.ets';
import Constants from '../../util/Constants.ets';

// 应用ArkTS约束：使用class语法，显式类型声明（约束1, 10）
class MessageReactionRemoveAll extends Action {
  // 应用ArkTS约束：方法参数需要明确类型（约束1）
  handle(data: Object): Object | boolean {
    // 应用ArkTS约束：使用get方法需要确保类型安全（约束21）
    const channel = this.client.channels.get(data['channel_id']);
    if (!channel || channel.type === 'voice') return false;

    const message = channel.messages.get(data['message_id']);
    if (!message) return false;

    message._clearReactions();
    // 应用ArkTS约束：使用字符串常量代替动态属性（约束5）
    this.client.emit(Constants.Events.MESSAGE_REACTION_REMOVE_ALL, message);

    return { message };
  }
}

/**
 * Emitted whenever all reactions are removed from a cached message.
 * @event Client#messageReactionRemoveAll
 * @param {Message} message The message the reactions were removed from
 */

// 应用ArkTS约束：使用export default代替module.exports（约束60）
export default MessageReactionRemoveAll;
