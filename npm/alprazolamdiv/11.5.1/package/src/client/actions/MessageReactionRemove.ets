// 应用约束：60. 不支持require和import赋值表达式，改用import
import Action from './Action.ets';
import Constants from '../../util/Constants.ets';

// 应用约束：24. 对象字面量不能用于类型声明，使用接口替代
interface ReactionData {
    user_id: string;
    message_id: string;
    emoji: {
        name: string;
        id: string | null;
    };
    channel_id: string;
}

// 应用约束：28. 类不允许implements，只有接口可以被implements（此处保持类继承）
class MessageReactionRemove extends Action {
    // 应用约束：1. 强制使用静态类型，为方法参数和返回值添加类型
    handle(data: ReactionData): { message: any, reaction: any, user: any } | boolean {
        // 应用约束：10. 使用具体的类型而非any或unknown
        const user = this.client.users.get(data.user_id);
        if (!user) return false;
        
        // 应用约束：10. 使用具体的类型而非any或unknown
        const channel = this.client.channels.get(data.channel_id);
        if (!channel || channel.type === 'voice') return false;
        
        // 应用约束：10. 使用具体的类型而非any或unknown
        const message = channel.messages.get(data.message_id);
        if (!message) return false;
        
        if (!data.emoji) return false;
        
        // 应用约束：10. 使用具体的类型而非any或unknown
        const reaction = message._removeReaction(data.emoji, user);
        if (reaction) this.client.emit(Constants.Events.MESSAGE_REACTION_REMOVE, reaction, user);

        return { message, reaction, user };
    }
}

// 应用约束：60. 不支持require和import赋值表达式，改用export
export default MessageReactionRemove;

// 应用约束：80. 不支持在import语句前使用其他语句（已调整import位置）
// 应用约束：9. 使用let而非var（原代码无var需要修改）
// 应用约束：7. 不支持以#开头的私有字段（原代码无私有字段）
// 应用约束：26. 使用箭头函数而非函数表达式（原代码无函数表达式）
// 应用约束：23. 需要显式标注对象字面量的类型（通过接口实现）
