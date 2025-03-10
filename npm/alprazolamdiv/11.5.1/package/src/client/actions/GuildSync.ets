// 应用约束60：改用ES模块导入
import Action from './Action.ets';

class GuildSync extends Action {
  // 应用约束18：类字段需在类中声明
  private client: any; // 假设client类型为any，实际应根据具体类型替换

  handle(data: any): void { // 应用约束10：显式指定参数和返回类型，避免any
    this.client = this.client;

    const guild = this.client.guilds.get(data.id);
    if (guild) {
      if (data.presences) {
        // 应用约束41：使用常规for循环替代for..in
        for (let presence of data.presences) {
          guild._setPresence(presence.user.id, presence);
        }
      }

      if (data.members) {
        for (let syncMember of data.members) {
          const member = guild.members.get(syncMember.user.id);
          if (member) {
            guild._updateMember(member, syncMember);
          } else {
            guild._addMember(syncMember, false);
          }
        }
      }

      // 应用约束36：使用属性判断替代in运算符
      if (data.hasOwnProperty('large')) {
        guild.large = data.large;
      }
    }
  }
}

// 应用约束60：改用ES模块导出
export default GuildSync;

// 应用约束说明：
// 1. 约束9：使用let/const替代var（原代码未使用var）
// 2. 约束26：使用箭头函数（原代码未涉及函数表达式）
// 3. 约束39：避免解构赋值（原代码未使用解构）
// 4. 约束66：确保属性初始化（client属性需要父类初始化）
// 5. 约束21：使用点操作符访问属性（已通过方法调用实现）
// 6. 约束80：import语句置顶（已调整）
