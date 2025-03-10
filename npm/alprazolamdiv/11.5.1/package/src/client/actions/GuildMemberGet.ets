// 应用约束60：使用import代替require
import Action from './Action.ets';

class GuildMemberGetAction extends Action {
  // 应用约束18：在类中声明字段，但本例中无需额外字段
  // 应用约束1：避免any类型，需为参数和返回值指定具体类型，假设Guild和Member为已定义的类型
  handle(guild: Guild, data: Object): { member: Member } {
    // 应用约束29：禁止修改对象方法布局，保持标准方法调用
    const member = guild._addMember(data, false);
    return { member };
  }
}

// 应用约束60：使用export代替module.exports
export default GuildMemberGetAction;

/* 类型定义示例（需在相应位置实际声明）：
class Guild {
  _addMember(data: Object, cache: boolean): Member {
    // 实际实现
  }
}

interface Member {
  // 成员属性定义
}
*/
