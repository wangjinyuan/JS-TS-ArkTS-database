// 应用约束：
// 1. 使用let/const代替var（约束9）
// 2. 显式声明类属性（约束18）
// 3. 使用ES模块导出（约束60）
// 4. 类型标注（约束1,10）
// 5. 使用箭头函数（约束26，但本例未涉及）
// 6. 移除JSDoc类型注释改用TS类型标注（约束1）

class RequestHandler {
  // 显式声明类属性（约束18）
  private restManager: RESTManager;
  private queue: APIRequest[] = [];

  // 构造函数参数类型标注（约束1）
  constructor(restManager: RESTManager) {
    this.restManager = restManager;
  }

  // Getter/Setter类型标注（约束1）
  get globalLimit(): boolean {
    return this.restManager.globallyRateLimited;
  }

  set globalLimit(value: boolean) {
    this.restManager.globallyRateLimited = value;
  }

  // 方法参数类型标注（约束1）
  push(request: APIRequest): void {
    this.queue.push(request);
  }

  handle(): void {
    // 保持空方法实现
  }

  destroy(): void {
    this.queue = [];
  }
}

export default RequestHandler;
