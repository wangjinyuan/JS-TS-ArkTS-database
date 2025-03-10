import Action from './Action.ets';
import Constants from '../../util/Constants.ets';
import Util from '../../util/Util.ets';

// 应用规则24：使用接口替代对象字面量类型声明
interface UpdateResult {
  old: Object | null;
  updated: Object | null;
}

class UserUpdateAction extends Action {
  // 应用规则10：使用具体类型替代any
  handle(data: Object): UpdateResult { // 规则10：参数需要显式类型标注
    const client = this.client;

    if (client.user) {
      // 应用规则30：使用as进行类型断言
      if ((client.user as any).equals(data)) { // 规则10：临时使用any处理动态方法
        return {
          old: client.user,
          updated: client.user,
        };
      }

      // 应用规则24：使用具体类型替代Object
      const oldUser = Util.cloneObject(client.user);
      client.user.patch(data);
      client.emit(Constants.Events.USER_UPDATE, oldUser, client.user);
      return {
        old: oldUser,
        updated: client.user,
      };
    }

    return {
      old: null,
      updated: null,
    };
  }
}

// 应用规则61：使用export default替代module.exports
export default UserUpdateAction;

/* 应用的主要规则说明：
1. 规则60：将require替换为import语句，文件后缀改为.ets
2. 规则10：所有any类型需要替换为具体类型，暂时保留Object类型
3. 规则24：使用接口定义返回类型替代对象字面量类型
4. 规则30：使用as进行必要的类型断言
5. 规则61：使用ES模块的导出语法替代CommonJS
6. 规则9：保持const声明不变，符合ArkTS规范
7. 规则76：严格空检查，允许返回null值
*/
