// 应用约束：1. 强制使用静态类型；7. 使用private而非#；9. 使用let/const而非var；10. 避免any；18. 类字段声明
import Webhook from '../structures/Webhook.ets';
import RESTManager from './rest/RESTManager.ets';
import ClientDataResolver from './ClientDataResolver.ets';
import Constants from '../util/Constants.ets';
import Util from '../util/Util.ets';

/**
 * The webhook client.
 * @extends Webhook
 */
class WebhookClient extends Webhook {
  // 显式声明类字段（约束18）
  public options: ClientOptions;
  private rest: RESTManager;
  private resolver: ClientDataResolver;
  private _timeouts: Set<Timeout> = new Set();
  private _intervals: Set<Timeout> = new Set();

  /**
   * @param id - ID of the webhook
   * @param token - Token of the webhook
   * @param options - Options for the client
   */
  constructor(id: string, token: string, options?: ClientOptions) {
    super(null, id, token);

    this.options = Util.mergeDefault(Constants.DefaultOptions, options);
    this.rest = new RESTManager(this);
    this.resolver = new ClientDataResolver(this);
  }

  /**
   * Sets a timeout that will be automatically cancelled if the client is destroyed.
   * @param fn - Function to execute
   * @param delay - Time to wait in milliseconds
   * @param args - Arguments for the function
   */
  setTimeout(fn: Function, delay: number, ...args: unknown[]): Timeout {
    const timeout = setTimeout(() => {
      fn(...args);
      this._timeouts.delete(timeout);
    }, delay);
    this._timeouts.add(timeout);
    return timeout;
  }

  clearTimeout(timeout: Timeout): void {
    clearTimeout(timeout);
    this._timeouts.delete(timeout);
  }

  setInterval(fn: Function, delay: number, ...args: unknown[]): Timeout {
    const interval = setInterval(fn, delay, ...args);
    this._intervals.add(interval);
    return interval;
  }

  clearInterval(interval: Timeout): void {
    clearInterval(interval);
    this._intervals.delete(interval);
  }

  destroy(): void {
    this._timeouts.forEach(t => clearTimeout(t));
    this._intervals.forEach(i => clearInterval(i));
    this._timeouts.clear();
    this._intervals.clear();
  }
}

export default WebhookClient;

// 注意：以下类型需在相应模块中定义
// - ClientOptions 应定义为接口或类
// - Timeout 类型可能需要使用ArkTS的定时器类型
// - Snowflake 类型应定义为字符串别名
// - 所有导入的.ets文件需确保类型定义符合ArkTS规范
