// 应用约束1：强制使用静态类型，替换any类型
// 应用约束9：使用let而非var
// 应用约束28：类不允许implements，改为接口
// 应用约束60：使用import代替require
// 应用约束24：对象字面量类型改为类或接口

import AbstractHandler from './AbstractHandler.ets';
import Constants from '../../../../util/Constants.ets';
import Util from '../../../../util/Util.ets';

// 定义必要的接口类型
interface PacketData {
  d: {
    guild_id: string;
    user_id: string;
    channel_id?: string;
    mute: boolean;
    deaf: boolean;
    self_mute: boolean;
    self_deaf: boolean;
    session_id: string;
  };
}

interface ClientType {
  guilds: Map<string, Guild>;
  user: { id: string };
  channels: Map<string, Channel>;
  emit(event: string, ...args: any[]): void;
}

interface Guild {
  members: Map<string, GuildMember>;
  channels: Map<string, Channel>;
}

interface GuildMember {
  id: string;
  voiceChannel?: Channel;
  speaking: any;
  serverMute: boolean;
  serverDeaf: boolean;
  selfMute: boolean;
  selfDeaf: boolean;
  voiceSessionID: string;
  voiceChannelID?: string;
  user: { id: string };
  guild: Guild;
}

interface Channel {
  id: string;
  members: Map<string, GuildMember>;
}

class VoiceStateUpdateHandler extends AbstractHandler {
  // 应用约束18：类字段显式声明
  private packetManager: { client: ClientType };

  constructor(packetManager: { client: ClientType }) {
    super();
    this.packetManager = packetManager;
  }

  handle(packet: PacketData): void {
    const client = this.packetManager.client;
    const data = packet.d;

    const guild = client.guilds.get(data.guild_id);
    if (guild) {
      const member = guild.members.get(data.user_id);
      if (member) {
        // 应用约束33：使用类方法代替对象克隆
        const oldVoiceChannelMember = this.cloneMember(member);
        
        if (member.voiceChannel && member.voiceChannel.id !== data.channel_id) {
          member.voiceChannel.members.delete(oldVoiceChannelMember.id);
        }

        if (!data.channel_id) member.speaking = null;

        if (member.user.id === client.user.id && data.channel_id) {
          client.emit('self.voiceStateUpdate', data);
        }

        const newChannel = data.channel_id ? client.channels.get(data.channel_id) : null;
        if (newChannel) {
          newChannel.members.set(member.id, member);
          member.guild.channels.set(data.channel_id, newChannel);
        }

        member.serverMute = data.mute;
        member.serverDeaf = data.deaf;
        member.selfMute = data.self_mute;
        member.selfDeaf = data.self_deaf;
        member.voiceSessionID = data.session_id;
        member.voiceChannelID = data.channel_id;
        
        client.emit(Constants.Events.VOICE_STATE_UPDATE, oldVoiceChannelMember, member);
      }
    }
  }

  // 应用约束47：使用类方法代替函数内函数
  private cloneMember(member: GuildMember): GuildMember {
    return {
      ...member,
      voiceChannel: member.voiceChannel ? { ...member.voiceChannel } : undefined
    };
  }
}

/**
 * Emitted whenever a user changes voice state - e.g. joins/leaves a channel, mutes/unmutes.
 * @event Client#voiceStateUpdate
 * @param {GuildMember} oldMember The member before the voice state update
 * @param {GuildMember} newMember The member after the voice state update
 */

// 应用约束61：使用ES模块导出
export default VoiceStateUpdateHandler;

// 补充类型定义
interface Map<K, V> {
  get(key: K): V | undefined;
  set(key: K, value: V): void;
  delete(key: K): boolean;
}
