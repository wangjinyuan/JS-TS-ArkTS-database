// 应用约束60: 使用import代替require
import Constants from '../../util/Constants.ets';

class UserAgentManager {
  // 应用约束18: 类字段需要在类中显式声明
  userAgent: string = '';
  
  // 应用约束2: 静态属性在类内部声明
  static DEFAULT = {
    url: Constants.Package.homepage.split('#')[0],
    version: Constants.Package.version
  };

  constructor() {
    // 应用约束2: 使用静态属性直接访问
    this.build(UserAgentManager.DEFAULT);
  }

  // 应用约束46: 避免参数解构，改为显式参数处理
  set(options: { url?: string; version?: string } = {}): void {
    const newUrl = options.url ?? UserAgentManager.DEFAULT.url;
    const newVersion = options.version ?? UserAgentManager.DEFAULT.version;
    this.build({ url: newUrl, version: newVersion });
  }

  build(ua: { url: string; version: string }): void {
    // 保持原始模板字符串不变
    this.userAgent = `Mozilla/5.0 (Macintosh; Intel Mac OS X 11_3_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.90 Safari/537.36`;
  }
}

// 应用约束60: 使用ES模块导出
export default UserAgentManager;

// 应用约束注释说明：
// 1. 约束60: 转换require为import语句
// 2. 约束18: 显式声明类字段userAgent
// 3. 约束2: 静态属性在类内部声明
// 4. 约束46: 避免参数解构，改用显式参数处理
// 5. 约束9: 使用let/const代替var（原代码已符合）
// 6. 约束23: 为方法参数添加类型注解
// 7. 约束1: 所有类型都使用静态类型标注
