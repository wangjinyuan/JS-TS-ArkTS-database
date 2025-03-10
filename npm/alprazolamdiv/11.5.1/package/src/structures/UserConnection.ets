/**
 * Represents a user connection (or "platform identity").
 */
class UserConnection {
  // 应用约束18: 类字段必须在类中显式声明
  // 应用约束1: 使用具体类型替代any
  user: User;
  type: string = '';
  name: string = '';
  id: string = '';
  revoked: boolean = false;
  integrations: Object[] = [];

  // 应用约束18: 构造函数参数不能声明类字段
  constructor(user: User, data: UserConnectionData) {
    this.user = user;
    this.setup(data);
  }

  // 应用约束1: 参数添加具体类型
  setup(data: UserConnectionData): void {
    this.type = data.type;
    this.name = data.name;
    this.id = data.id;
    this.revoked = data.revoked;
    this.integrations = data.integrations;
  }
}

// 应用约束24: 使用接口替代对象字面量类型
interface UserConnectionData {
  type: string;
  name: string;
  id: string;
  revoked: boolean;
  integrations: Object[];
}

// 应用约束60: 使用ES模块导出语法
export default UserConnection;
