import * as Snowflake from '../util/Snowflake.ets'; // 应用约束60: 改用import语法

/**
 * Represents any channel on Discord.
 */
class Channel {
  // 应用约束2: 显式声明类属性
  public readonly client: Client; // 应用约束7: 使用public/private替代Object.defineProperty
  public type: string | null = null;
  public deleted: boolean = false;
  public id: string = '';

  // 应用约束18: 构造函数参数不能声明类字段
  constructor(client: Client, data?: ChannelData) {
    this.client = client; // 直接赋值替代Object.defineProperty
    if (data) this.setup(data);
  }

  // 应用约束24: 为数据参数定义明确类型
  setup(data: ChannelData): void {
    this.id = data.id;
  }

  // 应用约束34: 显式标注返回类型
  get createdTimestamp(): number {
    return Snowflake.deconstruct(this.id).timestamp;
  }

  get createdAt(): Date {
    return new Date(this.createdTimestamp);
  }

  // 应用约束10: 使用具体返回类型
  delete(): Promise<Channel> {
    return this.client.rest.methods.deleteChannel(this);
  }
}

// 应用约束24: 定义数据接口替代对象字面量类型
interface ChannelData {
  id: string;
}

// 应用约束61: 改用export语法
export default Channel;

// 应用约束8: 类型名称唯一性
interface Client { // 需要在实际文件中定义完整Client类型
  rest: {
    methods: {
      deleteChannel(channel: Channel): Promise<Channel>;
    };
  };
}
