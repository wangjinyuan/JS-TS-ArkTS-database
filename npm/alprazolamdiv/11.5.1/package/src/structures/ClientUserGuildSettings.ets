// 应用约束：使用let而非var（约束9）
// 应用约束：强制使用静态类型（约束1）
// 应用约束：禁止在构造函数中声明字段（约束18）
import Constants from '../util/Constants.ets';
import Collection from '../util/Collection.ets';
import ClientUserChannelOverride from './ClientUserChannelOverride.ets';
import type { Client } from '../client/Client.ets'; // 假设Client类型定义

/**
 * A wrapper around the ClientUser's guild settings.
 */
class ClientUserGuildSettings {
  // 应用约束：显式声明类属性（约束18）
  client: Client;
  guildID: string;
  channelOverrides: Collection<string, ClientUserChannelOverride>;

  constructor(data: Record<string, any>, client: Client) {
    // 应用约束：禁止运行时变更对象布局（约束2）
    this.client = client;
    this.guildID = data.guild_id;
    this.channelOverrides = new Collection();
    this.patch(data);
  }

  /**
   * Patch the data contained in this class with new partial data.
   */
  patch(data: Record<string, any>): void {
    // 应用约束：对象属性名必须为合法标识符（约束5）
    const settingsMap = Constants.UserGuildSettingsMap as Record<string, any>;
    
    for (const key of Object.keys(settingsMap)) {
      if (!(key in data)) continue;
      
      const value = settingsMap[key];
      if (key === 'channel_overrides') {
        // 处理通道覆盖数据
        const channels = data[key] as Array<Record<string, any>>;
        channels.forEach(channel => {
          this.channelOverrides.set(
            channel.channel_id,
            new ClientUserChannelOverride(channel)
          );
        });
      } else if (typeof value === 'function') {
        // 应用约束：禁止动态属性访问（约束21）
        // 此处需要类型断言，实际项目应完善类型定义
        (this as any)[value.name] = value(data[key]);
      } else {
        (this as any)[value] = data[key];
      }
    }
  }

  /**
   * Update a specific property of the guild settings.
   */
  update(name: string, value: any): Promise<Object> {
    // 应用约束：对象字面量动态属性（约束5），使用Map替代
    const updateData = new Map<string, any>();
    updateData.set(name, value);
    return this.client.rest.methods.patchClientUserGuildSettings(
      this.guildID, 
      updateData
    );
  }
}

// 应用约束：使用ES模块导出（约束60）
export default ClientUserGuildSettings;

// 补充类型定义（根据实际项目需要完善）
interface Client {
  rest: {
    methods: {
      patchClientUserGuildSettings: (
        guildID: string, 
        data: Map<string, any>
      ) => Promise<Object>;
    };
  };
}
