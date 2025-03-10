// 应用约束：1. 强制使用静态类型；7. 使用private关键字；9. 使用let而非var；10. 使用具体类型；28. 类不允许implements等

// 假设Collector和相关接口已在interfaces/Collector.ets中定义
import Collector from './interfaces/Collector.ets';

// 定义类型接口
interface MessageCollectorOptions {
  max?: number;
  maxMatches?: number;
  maxProcessed?: number;
}

interface CollectorFilter {
  // 根据实际需求定义过滤函数类型
  (message: Message): boolean;
}

interface TextBasedChannel {
  id: string;
}

interface Message {
  id: string;
  channel: TextBasedChannel;
}

class MessageCollector extends Collector {
  // 显式声明类属性（约束18）
  public channel: TextBasedChannel;
  public received: number = 0;
  private _reEmitter: (message: Message) => void;

  // 添加构造函数参数类型（约束1）
  constructor(
    channel: TextBasedChannel,
    filter: CollectorFilter,
    options: MessageCollectorOptions = {}
  ) {
    super(channel.client, filter, options);

    this.channel = channel;

    // 处理max/maxMatches向后兼容（约束1）
    if (options.max) options.maxProcessed = options.max;
    if (options.maxMatches) options.max = options.maxMatches;

    // 事件监听处理（约束47, 48）
    this.client.setMaxListeners(this.client.getMaxListeners() + 1);
    this.client.on('message', this.listener.bind(this));

    this._reEmitter = (message: Message) => {
      this.emit('message', message);
    };
    this.on('collect', this._reEmitter);
  }

  // 方法添加类型注解（约束1）
  public on(eventName: string, listener: Function): void {
    // 移除util.deprecate相关代码（约束75）
    super.on(eventName, listener);
  }

  // 添加返回类型（约束1,45）
  handle(message: Message): { key: string; value: Message } | null {
    if (message.channel.id !== this.channel.id) return null;
    this.received++;
    return {
      key: message.id,
      value: message
    };
  }

  postCheck(): string | null {
    const opts = this.options as MessageCollectorOptions;
    if (opts.maxMatches && this.collected.size >= opts.maxMatches) return 'matchesLimit';
    if (opts.maxProcessed && this.received >= opts.maxProcessed) return 'limit';
    return null;
  }

  cleanup(): void {
    this.removeListener('collect', this._reEmitter);
    this.client.removeListener('message', this.listener);
    this.client.setMaxListeners(this.client.getMaxListeners() - 1);
  }

  // 添加listener方法类型声明（约束1）
  private listener = (message: Message): void => {
    this.handle(message);
  };
}

export default MessageCollector;
