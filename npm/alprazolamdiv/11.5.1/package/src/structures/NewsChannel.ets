// 应用约束1：强制使用静态类型，添加参数类型和属性类型
// 应用约束2：禁止在运行时变更对象布局，提前声明类属性
// 应用约束9：使用let/const代替var
// 应用约束60：使用ES模块导入语法
import TextChannel from './TextChannel.ets';

/**
 * Represents a guild news channel on Discord.
 * @extends TextChannel
 */
class NewsChannel extends TextChannel {
  // 应用约束2：声明所有类属性
  type: string = 'news';
  rateLimitPerUser: number = 0;

  // 应用约束1：添加构造函数参数类型
  constructor(guild: any, data: any) {
    super(guild, data);
    this.type = 'news';
  }

  // 应用约束1：添加方法参数类型
  setup(data: any): void {
    super.setup(data);

    /**
     * The ratelimit per user for this channel (always 0)
     */
    this.rateLimitPerUser = 0;
  }
}

// 应用约束60：使用ES模块导出语法
export default NewsChannel;
