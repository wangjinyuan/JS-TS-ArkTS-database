// 应用规则60：使用import代替require
import AbstractHandler from './AbstractHandler.ets';
import Constants from '../../../../util/Constants.ets';
import Util from '../../../../util/Util.ets';

// 应用规则28：只有接口可以被implements
class PresenceUpdateHandler extends AbstractHandler {
  // 应用规则18：类字段在类中声明
  private packetManager: any; // 需要替换为具体类型
  private client: any; // 需要替换为具体类型

  // 应用规则18：构造函数参数需要显式声明字段
  constructor(packetManager: any) {
    super();
    this.packetManager = packetManager;
    this.client = packetManager.client;
  }

  // 应用规则10：显式指定参数和返回类型
  handle(packet: any): void { // 需要替换为具体类型
    const client = this.client;
    const data = packet.d;
    let user = client.users.get(data.user.id);
    const guild = client.guilds.get(data.guild_id);

    // 应用规则23：显式类型标注
    if (!user) {
      if (data.user.username) {
        user = client.dataManager.newUser(data.user);
      } else {
        return;
      }
    }

    // 应用规则24：使用类代替对象字面量
    const oldUser = Util.cloneObject(user) as any; // 需要替换为具体类型
    user.patch(data.user);
    if (!user.equals(oldUser)) {
      client.emit(Constants.Events.USER_UPDATE, oldUser, user);
    }

    if (guild) {
      let member = guild.members.get(user.id);
      if (!member && data.status !== 'offline') {
        // 应用规则24：使用明确类型代替对象字面量
        member = guild._addMember({
          user: user,
          roles: data.roles,
          deaf: false,
          mute: false,
        } as MemberInitOptions, false);
        client.emit(Constants.Events.GUILD_MEMBER_AVAILABLE, member);
      }
      if (member) {
        if (client.listenerCount(Constants.Events.PRESENCE_UPDATE) === 0) {
          guild._setPresence(user.id, data);
          return;
        }
        const oldMember = Util.cloneObject(member) as any; // 需要替换为具体类型
        if (member.presence) {
          oldMember.frozenPresence = Util.cloneObject(member.presence);
        }
        guild._setPresence(user.id, data);
        client.emit(Constants.Events.PRESENCE_UPDATE, oldMember, member);
      } else {
        guild._setPresence(user.id, data);
      }
    }
  }
}

// 应用规则15：使用接口继承代替交叉类型
interface MemberInitOptions {
  user: any; // 需要替换为User类型
  roles: string[];
  deaf: boolean;
  mute: boolean;
}

// 应用规则53：事件注释转换为ArkTS格式
/**
 * Emitted whenever a guild member's presence changes
 * @event Client#presenceUpdate
 * @param oldMember The member before the presence update
 * @param newMember The member after the presence update
 */

/**
 * Emitted whenever a user's details are changed.
 * @event Client#userUpdate
 * @param oldUser The user before the update
 * @param newUser The user after the update
 */

/**
 * Emitted whenever a member becomes available
 * @event Client#guildMemberAvailable
 * @param member The member that became available
 */

// 应用规则60：使用export代替module.exports
export default PresenceUpdateHandler;
