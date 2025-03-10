// 应用约束60：改用import语法
import Collector from './interfaces/Collector.ets';
import Collection from '../util/Collection.ets';

// 应用约束15：使用接口继承替代交叉类型
interface ReactionCollectorOptions extends CollectorOptions {
  max?: number;
  maxEmojis?: number;
  maxUsers?: number;
}

// 应用约束28：只有接口可以被implements
class ReactionCollector extends Collector {
  // 应用约束18：类字段显式声明
  public message: Message;
  public users: Collection;
  public total: number = 0;

  // 应用约束1：去除any类型，明确参数类型
  constructor(message: Message, filter: CollectorFilter, options: ReactionCollectorOptions = {}) {
    super(message.client, filter, options);

    this.message = message;
    this.users = new Collection();

    // 应用约束7：使用private代替#私有字段
    this.client.setMaxListeners(this.client.getMaxListeners() + 1);
    
    // 应用约束26：使用箭头函数替代函数表达式
    this.client.on('messageReactionAdd', () => this.listener());
  }

  // 应用约束1：明确返回类型
  handle(reaction: MessageReaction): { key: Snowflake, value: MessageReaction } | null {
    if (reaction.message.id !== this.message.id) return null;
    return {
      key: reaction.emoji.id || reaction.emoji.name,
      value: reaction,
    };
  }

  // 应用约束1：明确参数和返回类型
  postCheck(reaction: MessageReaction, user: User): string | null {
    this.users.set(user.id, user);
    if (this.options.max && ++this.total >= this.options.max) return 'limit';
    if (this.options.maxEmojis && this.collected.size >= this.options.maxEmojis) return 'emojiLimit';
    if (this.options.maxUsers && this.users.size >= this.options.maxUsers) return 'userLimit';
    return null;
  }

  cleanup(): void {
    this.client.removeListener('messageReactionAdd', this.listener);
    this.client.setMaxListeners(this.client.getMaxListeners() - 1);
  }
}

// 应用约束60：使用export替代module.exports
export default ReactionCollector;
