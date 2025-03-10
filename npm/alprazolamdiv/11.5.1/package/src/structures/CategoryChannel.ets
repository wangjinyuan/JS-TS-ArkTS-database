// 应用约束60：使用import代替require
import GuildChannel from './GuildChannel.ets';

/**
 * Represents a guild category channel on Discord.
 * @extends {GuildChannel}
 */
class CategoryChannel extends GuildChannel {
  // 应用约束18：在类中声明字段
  public type: string;

  constructor(guild: any, data: any) { // 应用约束1：避免any类型（建议后续替换具体类型）
    super(guild, data);
    this.type = 'category';
  }

  /**
   * The channels that are part of this category
   * @readonly
   */
  // 应用约束45：添加返回类型标注
  get children(): Map<string, GuildChannel> { // 应用约束24：使用Map代替对象索引
    return this.guild.channels.filter((c: GuildChannel) => c.parentID === this.id);
  }
}

// 应用约束61：使用export default代替module.exports
export default CategoryChannel;
