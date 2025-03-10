// 根据约束1、7、9、10、18、28、30、45、47、60、61、77，进行转换
import { PartialGuild } from './PartialGuild.ets';
import { PartialGuildChannel } from './PartialGuildChannel.ets';
import { Constants } from '../util/Constants.ets';
import { Client } from '../client/Client.ets'; // 假设Client类型定义
import { User } from '../structures/User.ets'; // 假设User类型定义
import { Guild } from '../structures/Guild.ets'; // 假设Guild类型定义
import { GuildChannel } from '../structures/GuildChannel.ets'; // 假设GuildChannel类型定义

interface InviteData {
  guild: {
    id: string;
    text_channel_count: number;
    voice_channel_count: number;
  };
  code: string;
  approximate_presence_count: number;
  approximate_member_count: number;
  temporary: boolean;
  max_age: number;
  uses: number;
  max_uses: number;
  inviter?: any;
  channel: {
    id: string;
  };
  created_at: string;
}

class Invite {
  // 显式声明所有类属性（约束18）
  public client: Client;
  public guild: Guild | PartialGuild;
  public code: string = '';
  public presenceCount: number = 0;
  public memberCount: number = 0;
  public textChannelCount: number = 0;
  public voiceChannelCount: number = 0;
  public temporary: boolean = false;
  public maxAge: number | null = null;
  public uses: number = 0;
  public maxUses: number = 0;
  public inviter: User | null = null;
  public channel: GuildChannel | PartialGuildChannel;
  public createdTimestamp: number = 0;

  constructor(client: Client, data: InviteData) {
    // 初始化client属性（约束18）
    this.client = client;
    this.setup(data);
  }

  private setup(data: InviteData): void {
    this.guild = this.client.guilds.get(data.guild.id) || new PartialGuild(this.client, data.guild);
    this.code = data.code;
    this.presenceCount = data.approximate_presence_count;
    this.memberCount = data.approximate_member_count;
    this.textChannelCount = data.guild.text_channel_count;
    this.voiceChannelCount = data.guild.voice_channel_count;
    this.temporary = data.temporary;
    this.maxAge = data.max_age;
    this.uses = data.uses;
    this.maxUses = data.max_uses;

    if (data.inviter) {
      this.inviter = this.client.dataManager.newUser(data.inviter);
    }

    this.channel = this.client.channels.get(data.channel.id) || new PartialGuildChannel(this.client, data.channel);
    this.createdTimestamp = new Date(data.created_at).getTime();
  }

  // 使用显式类型标注（约束45）
  get createdAt(): Date {
    return new Date(this.createdTimestamp);
  }

  get expiresTimestamp(): number {
    return this.createdTimestamp + (this.maxAge! * 1000);
  }

  get expiresAt(): Date {
    return new Date(this.expiresTimestamp);
  }

  get url(): string {
    return Constants.Endpoints.inviteLink(this.code);
  }

  // 添加参数类型和返回类型（约束45）
  delete(reason?: string): Promise<Invite> {
    return this.client.rest.methods.deleteInvite(this, reason);
  }

  toString(): string {
    return this.url;
  }
}

export default Invite;
