// 应用ArkTS约束：
// 1. 使用let/const代替var（约束9）
// 2. 显式类型标注（约束10,23）
// 3. 类属性显式声明（约束18）
// 4. 使用class代替构造签名（约束12）
// 5. 模块导入语法转换（约束60,80）
// 6. 禁止对象字面量类型（约束24）
// 7. 使用箭头函数代替函数表达式（约束26）
// 8. 显式访问修饰符（约束7）
// 9. 导出语法转换（约束61）

import Collection from '../util/Collection.ets';

// 假设已定义的基础类型和类
type Snowflake = string;
class User {}
class Role {}
class Message {
  content: string = '';
  client = new Client();
  channel = new Channel();
}
class Client {
  users = new Collection<Snowflake, User>();
  dataManager = new DataManager();
  channels = new Collection<Snowflake, GuildChannel>();
}
class DataManager {
  newUser(data: any): User { return new User(); }
}
class Guild {
  roles = new Collection<Snowflake, Role>();
  members = new Collection<Snowflake, GuildMember>();
}
class Channel {
  guild = new Guild();
}
class GuildMember {}
class GuildChannel {}

/**
 * Keeps track of mentions in a {@link Message}.
 */
class MessageMentions {
  // 显式声明类属性（约束18）
  everyone: boolean;
  users: Collection<Snowflake, User>;
  roles: Collection<Snowflake, Role>;
  private _content: string;
  private _client: Client;
  private _guild: Guild | null;
  private _members: Collection<Snowflake, GuildMember> | null = null;
  private _channels: Collection<Snowflake, GuildChannel> | null = null;

  // 静态属性声明（约束53）
  static EVERYONE_PATTERN: RegExp = /@(everyone|here)/g;
  static USERS_PATTERN: RegExp = /<@!?[0-9]+>/g;
  static ROLES_PATTERN: RegExp = /<@&[0-9]+>/g;
  static CHANNELS_PATTERN: RegExp = /<#([0-9]+)>/g;

  constructor(message: Message, users?: Collection<Snowflake, User> | User[], roles?: Collection<Snowflake, Role> | Role[], everyone?: boolean) {
    this.everyone = Boolean(everyone);
    this._content = message.content;
    this._client = message.client;
    this._guild = message.channel.guild;

    // 处理users（约束24）
    if (users instanceof Collection) {
      this.users = new Collection(users);
    } else if (users) {
      this.users = new Collection();
      for (const mention of users) {
        let user = message.client.users.get((mention as User)['id']); // 类型断言
        if (!user) user = message.client.dataManager.newUser(mention);
        this.users.set(user['id'], user);
      }
    } else {
      this.users = new Collection();
    }

    // 处理roles（约束24）
    if (roles instanceof Collection) {
      this.roles = new Collection(roles);
    } else if (roles) {
      this.roles = new Collection();
      for (const mention of roles) {
        const role = message.channel.guild.roles.get((mention as Role)['id']);
        if (role) this.roles.set(role['id'], role);
      }
    } else {
      this.roles = new Collection();
    }
  }

  // Getter方法保持TS语法（约束50）
  get members(): Collection<Snowflake, GuildMember> | null {
    if (this._members) return this._members;
    if (!this._guild) return null;
    this._members = new Collection();
    this.users.forEach(user => {
      const member = this._guild!.members.get(user['id']);
      if (member) this._members!.set(member['id'], member);
    });
    return this._members;
  }

  get channels(): Collection<Snowflake, GuildChannel> {
    if (this._channels) return this._channels;
    this._channels = new Collection();
    let matches: RegExpExecArray | null;
    while ((matches = MessageMentions.CHANNELS_PATTERN.exec(this._content)) !== null) {
      const chan = this._client.channels.get(matches[1]);
      if (chan) this._channels.set(chan['id'], chan);
    }
    return this._channels;
  }
}

export default MessageMentions;
