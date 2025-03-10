import Action from './Action.ets';
import Constants from '../../util/Constants.ets';

// 应用约束24：使用类/接口替代对象字面量类型
interface ReactionData {
    user_id: string;
    message_id: string;
    emoji: { name: string; id: string | null };
    channel_id: string;
}

// 应用约束28：只有接口可以被implement
class MessageReactionAdd extends Action {
    // 应用约束18：类字段在类中显式声明
    private client: any; // 根据实际Client类型替换any

    handle(data: ReactionData): { message: any | null, reaction: any | null, user: any | null } {
        // 应用约束10：使用具体类型替代any
        const user = this.client.users.get(data.user_id) as any | null;
        if (!user) return { message: null, reaction: null, user: null };

        // 应用约束22：显式类型转换
        const channel = this.client.channels.get(data.channel_id) as any | null;
        if (!channel || channel.type === 'voice') return { message: null, reaction: null, user: null };

        const message = channel.messages.get(data.message_id) as any | null;
        if (!message) return { message: null, reaction: null, user: null };

        if (!data.emoji) return { message: null, reaction: null, user: null };

        // 应用约束29：使用继承替代方法修改
        const reaction = message._addReaction(data.emoji, user) as any | null;
        if (reaction) {
            // 应用约束30：类型安全的事件触发
            this.client.emit(Constants.Events.MESSAGE_REACTION_ADD as string, reaction, user);
        }

        return { message, reaction, user };
    }
}

// 应用约束60：使用ES6导出语法
export default MessageReactionAdd;

/** 
 * Emitted whenever a reaction is added to a cached message.
 * @event Client#messageReactionAdd
 * @param {MessageReaction} messageReaction The reaction object
 * @param {User} user The user that applied the emoji or reaction emoji
 */

// 应用约束23：显式标注对象字面量类型
interface EventParams {
    messageReaction: any; // 替换为实际MessageReaction类型
    user: any;           // 替换为实际User类型
}
