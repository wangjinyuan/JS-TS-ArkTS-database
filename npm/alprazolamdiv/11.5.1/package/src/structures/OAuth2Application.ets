// 应用ArkTS约束：
// 1. 强制使用静态类型（错误1）
// 2. 禁止在运行时变更对象布局（错误2）
// 7. 使用private而非#私有字段（错误7）
// 9. 使用let/const而非var（错误9）
// 10. 使用具体类型替代any（错误10）
// 18. 类字段在类中声明（错误18）
// 28. 类不允许被implements（错误28）
// 60. 使用import代替require（错误60）
// 73. 移除as const断言（错误73）

// Snowflake类型需要根据实际实现定义，这里假设已存在
import Snowflake from '../util/Snowflake.ets';

// 定义数据接口
interface OAuth2ApplicationData {
  id: Snowflake;
  name: string;
  description: string;
  icon?: string | null;
  rpc_origins?: string[] | null;
  redirect_uris: string[];
  bot_require_code_grant: boolean;
  bot_public: boolean;
  rpc_application_state: boolean;
  bot: Record<string, unknown>;
  flags: number;
  secret: boolean;
  owner?: Record<string, unknown>;
}

// Client类型需要根据实际实现定义
class Client {
  dataManager = {
    newUser: (data: Record<string, unknown>) => new User()
  };
  rest = {
    methods: {
      resetApplication: (id: Snowflake) => new OAuth2Application(new Client(), {} as OAuth2ApplicationData)
    }
  };
}

// User类型需要根据实际实现定义
class User {}

/**
 * Represents an OAuth2 Application.
 */
class OAuth2Application {
  // 类属性声明（错误18）
  public readonly client: Client;
  public id: Snowflake = '' as Snowflake;
  public name: string = '';
  public description: string = '';
  public icon: string | null = null;
  public iconURL: string = '';
  public rpcOrigins: string[] | null = null;
  public redirectURIs: string[] = [];
  public botRequireCodeGrant: boolean = false;
  public botPublic: boolean = false;
  public rpcApplicationState: boolean = false;
  public bot: Record<string, unknown> = {};
  public flags: number = 0;
  public secret: boolean = false;
  public owner: User | null = null;

  constructor(client: Client, data: OAuth2ApplicationData) {
    // 初始化client属性（错误2）
    this.client = client;
    this.setup(data);
  }

  setup(data: OAuth2ApplicationData): void {
    this.id = data.id;
    this.name = data.name;
    this.description = data.description;
    this.icon = data.icon ?? null;
    this.iconURL = `https://cdn.discordapp.com/app-icons/${this.id}/${this.icon}.jpg`;
    this.rpcOrigins = data.rpc_origins ?? null;
    this.redirectURIs = data.redirect_uris;
    this.botRequireCodeGrant = data.bot_require_code_grant;
    this.botPublic = data.bot_public;
    this.rpcApplicationState = data.rpc_application_state;
    this.bot = data.bot;
    this.flags = data.flags;
    this.secret = data.secret;

    if (data.owner) {
      this.owner = this.client.dataManager.newUser(data.owner);
    }
  }

  // Getter方法保持TS语法
  get createdTimestamp(): number {
    return Snowflake.deconstruct(this.id).timestamp;
  }

  get createdAt(): Date {
    return new Date(this.createdTimestamp);
  }

  /**
   * Reset the app's secret and bot token.
   * @deprecated userbot methods will be removed
   */
  reset(): OAuth2Application {
    return this.client.rest.methods.resetApplication(this.id);
  }

  toString(): string {
    return this.name;
  }
}

export default OAuth2Application;
