// 应用约束60：使用import代替require
import Action from './Action.ets';

// 应用约束26：使用箭头函数代替函数表达式
const mappify = (iterable: Iterable<[any, any]>): Map<any, any> => {
    const map = new Map();
    for (const x of iterable) {
        // 应用约束51：调整展开运算符使用
        map.set(x[0], x[1]);
    }
    return map;
};

class GuildEmojisUpdateAction extends Action {
    // 应用约束1：添加显式类型声明
    client: any; // 应替换为具体Client类型

    // 应用约束18：类字段在类中声明
    handle(data: any): void { // 应替换为具体数据类型
        const guild = this.client.guilds.get(data.guild_id);
        if (!guild || !guild.emojis) return;

        // 应用约束14：使用Map代替index signature
        const deletions = mappify(guild.emojis.entries());

        for (const emoji of data.emojis) {
            const cachedEmoji = guild.emojis.get(emoji.id);
            if (cachedEmoji) {
                deletions.delete(emoji.id);
                if (!cachedEmoji.equals(emoji, true)) {
                    this.client.actions.GuildEmojiUpdate.handle(cachedEmoji, emoji);
                }
            } else {
                this.client.actions.GuildEmojiCreate.handle(guild, emoji);
            }
        }

        // 应用约束41：使用常规for循环代替for..of迭代器
        const deletionValues = Array.from(deletions.values());
        for (let i = 0; i < deletionValues.length; i++) {
            this.client.actions.GuildEmojiDelete.handle(deletionValues[i]);
        }
    }
}

// 应用约束60：使用export代替module.exports
export default GuildEmojisUpdateAction;

// 注意：以下类型需要正确定义（示例中保留any需替换）：
// 1. Client类型应包含guilds: Map<string, Guild> 
// 2. Guild类型应包含emojis: Map<string, Emoji>
// 3. Emoji类型应实现equals方法
// 4. data参数应定义明确接口类型
