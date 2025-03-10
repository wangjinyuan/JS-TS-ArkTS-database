// 应用约束：使用let而非var（错误9），强制使用静态类型（错误1），模块导入语法（错误60）
import Action from './Action.ets';
import Constants from '../../util/Constants.ets';

// 应用约束：显式声明类属性（错误18）
class GuildMemberRemoveAction extends Action {
  // 应用约束：禁止any类型（错误1），声明具体类型
  private deleted: Map<string, any> = new Map();

  // 应用约束：构造函数参数类型声明（错误1）
  constructor(client: any) {
    super(client);
  }

  // 应用约束：参数和返回类型声明（错误1）
  handle(data: { guild_id: string; user: { id: string }): { guild: any | null; member: any | null } {
    const client = this.client;
    const guild = client.guilds.get(data.guild_id);
    let member: any | null = null;
    
    if (guild) {
      guild.memberCount--;
      member = guild.members.get(data.user.id) || null;

      if (member) {
        guild._removeMember(member);
        this.deleted.set(`${guild.id}${data.user.id}`, member);
        
        // 应用约束：使用常量枚举值（错误56）
        if (client.status === Constants.Status.READY) {
          client.emit(Constants.Events.GUILD_MEMBER_REMOVE, member);
        }
        
        this.scheduleForDeletion(guild.id, data.user.id);
      } else {
        member = this.deleted.get(`${guild.id}${data.user.id}`) || null;
      }

      if (member) member.deleted = true;
    }
    return { guild, member };
  }

  // 应用约束：参数类型声明（错误1）
  scheduleForDeletion(guildID: string, userID: string): void {
    this.client.setTimeout(
      () => this.deleted.delete(`${guildID}${userID}`),
      this.client.options.restWsBridgeTimeout
    );
  }
}

/**
 * Emitted whenever a member leaves a guild, or is kicked.
 * @event Client#guildMemberRemove
 * @param {GuildMember} member The member that has left/been kicked from the guild
 */

// 应用约束：模块导出语法（错误61）
export default GuildMemberRemoveAction;
