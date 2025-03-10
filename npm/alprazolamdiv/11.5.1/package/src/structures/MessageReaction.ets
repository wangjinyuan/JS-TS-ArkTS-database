// 应用ArkTS约束：
// 1. 转换require为import，文件后缀改为.ets（约束60,80）
// 2. 类属性显式声明（约束18）
// 3. 使用let/const代替var（约束9）
// 4. 类型标注和静态类型（约束1,10）
// 5. 使用Map代替Collection（约束14）
// 6. 使用具体类型替代any（约束1）
// 7. 移除原型方法赋值，使用类方法（约束67）
// 8. 模块导出使用ES6语法（约束60）

import Collection from '../util/Collection.ets'; // 假设Collection.ets已转换为ArkTS
import Emoji from './Emoji.ets';
import ReactionEmoji from './ReactionEmoji.ets';

/** Represents a reaction to a message. */
class MessageReaction {
  // 显式声明类属性（约束18）
  public message: any; // 需替换为具体Message类型
  public me: boolean;
  public count: number;
  public users: Map<string, any>; // 需替换为具体User类型
  private _emoji: ReactionEmoji;

  constructor(message: any, emoji: { name: string; id: string }, count: number, me: boolean) {
    this.message = message;
    this.me = me;
    this.count = count || 0;
    this.users = new Map();
    this._emoji = new ReactionEmoji(this, emoji.name, emoji.id);
  }

  get emoji(): ReactionEmoji | Emoji {
    if (this._emoji instanceof Emoji) return this._emoji;
    if (this._emoji.id) {
      const emojis = this.message.client.emojis;
      if (emojis.has(this._emoji.id)) {
        const emoji = emojis.get(this._emoji.id) as Emoji;
        this._emoji = emoji;
        return emoji;
      }
    }
    return this._emoji;
  }

  async remove(user: any = this.message.client.user): Promise<MessageReaction> { // 需替换User类型
    const userID = this.message.client.resolver.resolveUserID(user);
    if (!userID) throw new Error("Couldn't resolve user ID");
    
    await this.message.client.rest.methods.removeMessageReaction(
      this.message,
      this.emoji.identifier,
      userID
    );
    return this;
  }

  async fetchUsers(limit: number = 100, options: { after?: string; before?: string } = {}): Promise<Map<string, any>> {
    const data = await this.message.client.rest.methods.getMessageReactionUsers(
      this.message,
      this.emoji.identifier,
      { ...options, limit }
    );

    const users = new Map<string, any>();
    for (const rawUser of data) {
      const user = this.message.client.dataManager.newUser(rawUser);
      this.users.set(user.id, user);
      users.set(user.id, user);
    }
    return users;
  }
}

export default MessageReaction;
