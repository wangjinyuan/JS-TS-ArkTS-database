// 应用约束60：使用import代替require
import Action from './Action.ets';

class GuildEmojiUpdateAction extends Action {
  // 应用约束1：为参数添加类型注解（根据实际类型替换any）
  handle(oldEmoji: any, newEmoji: any): object { // 需要根据实际返回类型定义更具体的类型
    // 应用约束1：client需要正确定义类型
    const emoji = this.client.dataManager.updateEmoji(oldEmoji, newEmoji);
    return { emoji };
  }
}

/**
 * Emitted whenever a custom guild emoji is updated.
 * @event Client#emojiUpdate
 * @param {Emoji} oldEmoji The old emoji
 * @param {Emoji} newEmoji The new emoji
 */

// 应用约束61：使用export default代替module.exports
export default GuildEmojiUpdateAction;

// 注意：需要完成以下后续工作：
// 1. 为Emoji类型创建接口/类定义
// 2. 为client.dataManager及其updateEmoji方法添加类型声明
// 3. 为返回对象定义具体类型而不是使用object
// 4. 根据实际业务需求替换any为具体类型
