// 应用约束7：使用private关键字代替#符号
// 应用约束18：禁止在constructor中声明字段，改为在类中显式声明
// 应用约束28：接口可以被implements，类不能
// 应用约束8：类型命名必须唯一
// 应用约束10：使用具体类型代替any
// 应用约束24：使用类代替对象字面量类型声明
class PartialGuild {
  // 显式声明类属性并初始化（约束18）
  public id: string = '';
  public name: string = '';
  public icon: string | null = null;
  public splash: string | null = null;

  // 使用readonly修饰符代替Object.defineProperty（约束2）
  public readonly client: Client;

  constructor(client: Client, data: PartialGuildData) {
    this.client = client;
    this.setup(data);
  }

  // 添加类型注解（约束1）
  setup(data: PartialGuildData): void {
    this.id = data.id;
    this.name = data.name;
    this.icon = data.icon ?? null;
    this.splash = data.splash ?? null;
  }
}

// 定义数据接口（约束15）
interface PartialGuildData {
  id: string;
  name: string;
  icon?: string | null;
  splash?: string | null;
}

// 定义Client类型（需要根据实际实现补充）
class Client {
  // 示例实现，需根据实际情况补充
}

// 应用约束61：使用ES模块语法代替module.exports
export default PartialGuild;

/* 原始注释保留：
{ splash: null,
     id: '123123123',
     icon: '123123123',
     name: 'name' }
*/

/**
 * Represents a guild that the client only has limited information for - e.g. from invites.
 * （约束24：使用类注释代替对象字面量类型声明）
 */
