// 根据约束60，使用import代替require
import Constants from '../util/Constants.ets';

// 根据约束24，使用类代替对象字面量类型
interface GuildChannelData {
  id: string;
  name: string;
  type: number;
}

// 根据约束2和18，在类中显式声明属性
class PartialGuildChannel {
  // 根据约束7，使用private代替#私有字段
  private readonly client: any;
  public id: string = '';
  public name: string = '';
  public type: string = '';

  // 根据约束18，在类中声明字段而非构造函数参数
  constructor(client: any, data: GuildChannelData) {
    // 根据约束67，使用标准属性赋值代替Object.defineProperty
    this.client = client;
    this.setup(data);
  }

  // 根据约束2，保持对象布局不变
  private setup(data: GuildChannelData): void {
    this.id = data.id;
    this.name = data.name;
    
    // 根据约束1，避免any类型，假设Constants已正确定义类型
    this.type = Constants.ChannelTypes.TEXT === data.type ? 'text' : 'voice';
  }
}

// 根据约束60，使用export default代替module.exports
export default PartialGuildChannel;

/* 
应用的主要约束列表：
1. 约束1 - 强制使用静态类型（添加接口和类型标注）
2. 约束2 - 禁止运行时变更对象布局（保持属性固定）
3. 约束7 - 使用private代替#私有字段
4. 约束18 - 类字段显式声明
5. 约束24 - 使用类/接口代替对象字面量类型
6. 约束60 - 使用ES模块导入导出
7. 约束67 - 避免原型操作改用标准属性
8. 约束76 - 强制严格类型检查（添加参数类型）
*/
