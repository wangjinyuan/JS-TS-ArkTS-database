// 应用约束：60. 不支持require和import赋值表达式，改用import
import AbstractHandler from './AbstractHandler.ets';
import Constants from '../../../../util/Constants.ets';

// 应用约束：28. 类不允许implements，只有接口可以被implements（假设AbstractHandler是类）
class TypingStartHandler extends AbstractHandler {
  // 应用约束：18. 在class中声明字段
  private packetManager: any; // 需补充具体类型
  // 应用约束：1. 强制使用静态类型
  handle(packet: any): void { // 需补充具体packet类型
    const client = this.packetManager.client;
    const data = packet.d as { 
      channel_id: string, 
      user_id: string, 
      timestamp: number 
    };
    const channel = client.channels.get(data.channel_id);
    const user = client.users.get(data.user_id);
    const timestamp = new Date(data.timestamp * 1000);

    if (channel && user) {
      if (channel.type === 'voice') {
        client.emit(Constants.Events.WARN, `Discord sent a typing packet to voice channel ${channel.id}`);
        return;
      }
      // 应用约束：21. 不支持通过索引访问字段（使用Map方法）
      if (channel._typing.has(user.id)) {
        const typing = channel._typing.get(user.id)!;
        typing.lastTimestamp = timestamp;
        typing.resetTimeout(tooLate(channel, user));
      } else {
        // 应用约束：30. 类型转换仅支持as语法
        channel._typing.set(user.id, new TypingData(
          client, 
          timestamp, 
          timestamp, 
          tooLate(channel, user) as unknown as number
        ));
        client.emit(Constants.Events.TYPING_START, channel, user);
      }
    }
  }
}

class TypingData {
  // 应用约束：18. 在class中声明字段
  public client: any;
  public since: Date;
  public lastTimestamp: Date;
  private _timeout: number;

  // 应用约束：1. 强制使用静态类型
  constructor(
    client: any, 
    since: Date, 
    lastTimestamp: Date, 
    _timeout: number
  ) {
    this.client = client;
    this.since = since;
    this.lastTimestamp = lastTimestamp;
    this._timeout = _timeout;
  }

  resetTimeout(_timeout: number): void {
    this.client.clearTimeout(this._timeout);
    this._timeout = _timeout;
  }

  // 应用约束：1. 强制使用静态类型
  get elapsedTime(): number {
    return Date.now() - this.since.getTime();
  }
}

// 应用约束：1. 强制使用静态类型
function tooLate(channel: any, user: any): number { // 需补充具体类型
  return channel.client.setTimeout(() => {
    channel.client.emit(
      Constants.Events.TYPING_STOP, 
      channel, 
      user, 
      channel._typing.get(user.id)
    );
    channel._typing.delete(user.id);
  }, 6000) as number;
}

/**
 * Emitted whenever a user starts typing in a channel.
 * @event Client#typingStart
 * @param {Channel} channel The channel the user started typing in
 * @param {User} user The user that started typing
 */

/**
 * Emitted whenever a user stops typing in a channel.
 * @event Client#typingStop
 * @param {Channel} channel The channel the user stopped typing in
 * @param {User} user The user that stopped typing
 */

// 应用约束：60. 使用ES模块导出
export default TypingStartHandler;

// 应用约束补充说明：
// 1. 多处使用any类型需要根据实际业务补充具体类型
// 2. 事件系统需要配合ArkTS的事件机制实现
// 3. Map类型需要明确泛型参数，如Map<string, TypingData>
// 4. 可选链操作符需要转换为类型守卫
// 5. 需要为Client、Channel、User等类型定义具体接口
