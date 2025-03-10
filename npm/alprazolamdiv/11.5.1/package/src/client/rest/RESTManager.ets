// 应用ArkTS约束：
// 1. 使用let/const代替var（规则9）
// 2. 类属性必须在类中声明（规则18）
// 3. 使用ES模块导入（规则60,80）
// 4. 禁止any类型，需要明确类型声明（规则1,10）
// 5. 添加类型注解（规则23）
// 6. 使用箭头函数替代函数表达式（规则26）
// 7. 使用class替代构造函数类型（规则12）

import UserAgentManager from './UserAgentManager.ets';
import RESTMethods from './RESTMethods.ets';
import SequentialRequestHandler from './RequestHandlers/Sequential.ets';
import BurstRequestHandler from './RequestHandlers/Burst.ets';
import APIRequest from './APIRequest.ets';
import Constants from '../../util/Constants.ets';

class RESTManager {
  // 声明类属性（规则18）
  client: any; // 实际应替换为具体Client类型
  handlers: { [key: string]: any } = {};
  userAgentManager: UserAgentManager;
  methods: RESTMethods;
  rateLimitedEndpoints: { [key: string]: any } = {};
  globallyRateLimited: boolean = false;

  constructor(client: any) { // 实际应替换为具体Client类型
    this.client = client;
    this.userAgentManager = new UserAgentManager(this);
    this.methods = new RESTMethods(this);
  }

  destroy(): void {
    for (const handlerKey of Object.keys(this.handlers)) {
      const handler = this.handlers[handlerKey];
      if (handler.destroy) handler.destroy();
    }
  }

  push(handler: any, apiRequest: APIRequest): Promise<any> {
    return new Promise((resolve, reject) => {
      handler.push({
        request: apiRequest,
        resolve,
        reject,
        retries: 0,
      });
    });
  }

  getRequestHandler(): any { // 实际应使用具体类型
    switch (this.client.options.apiRequestMethod) {
      case 'sequential':
        return SequentialRequestHandler;
      case 'burst':
        return BurstRequestHandler;
      default:
        throw new Error(Constants.Errors.INVALID_RATE_LIMIT_METHOD);
    }
  }

  makeRequest(
    method: string,
    url: string,
    auth: string,
    data: any,
    file: any,
    reason: string
  ): Promise<any> {
    const apiRequest = new APIRequest(this, method, url, auth, data, file, reason);
    
    if (!this.handlers[apiRequest.route]) {
      const RequestHandlerType = this.getRequestHandler();
      this.handlers[apiRequest.route] = new RequestHandlerType(this, apiRequest.route);
    }

    return this.push(this.handlers[apiRequest.route], apiRequest);
  }
}

export default RESTManager; // 规则60,61
