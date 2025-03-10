// 应用约束60：使用ES6 import代替require
import Action from './Action.ets';

class GuildEmojiDeleteAction extends Action {
  // 应用约束1：为方法参数添加明确类型（假设Emoji类型已定义）
  handle(emoji: Emoji): { emoji: Emoji } {
    // 应用约束9：使用const代替var
    const client = this.client;
    client.dataManager.killEmoji(emoji);
    // 应用约束2：通过类属性修改代替动态属性添加
    emoji.deleted = true;
    return { emoji };
  }
}

/**
 * Emitted whenever a custom guild emoji is deleted.
 * @event Client#emojiDelete
 * @param {Emoji} emoji The emoji that was deleted
 */

// 应用约束60：使用ES6 export代替module.exports
export default GuildEmojiDeleteAction;

/* 假设存在的Emoji类定义（需要单独文件）：
class Emoji {
  public deleted: boolean = false;
  // 其他属性和方法...
}
*/
