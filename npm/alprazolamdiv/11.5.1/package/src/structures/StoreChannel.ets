// 应用约束60: 使用import代替require
import GuildChannel from './GuildChannel.ets';

/**
 * Represents a guild store channel on Discord.
 * @extends {GuildChannel}
 */
class StoreChannel extends GuildChannel {
  // 应用约束18: 类字段必须在类中显式声明
  type: string;
  nsfw: boolean;

  // 应用约束1: 添加参数类型注解
  constructor(guild: Object, data: Object) {
    super(guild, data);
    this.type = 'store';
  }

  // 应用约束1: 添加参数类型注解
  setup(data: { nsfw: boolean }) {
    super.setup(data);

    /**
     * If the guild considers this channel NSFW
     * @readonly
     */
    this.nsfw = data.nsfw;
  }
}

// 应用约束61: 使用ES模块导出语法
export default StoreChannel;
