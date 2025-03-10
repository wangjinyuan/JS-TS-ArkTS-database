// 应用约束：60. 不支持require和import赋值表达式，改用import
import AbstractHandler from './AbstractHandler.ets';
import Constants from '../../../../util/Constants.ets';

// 应用约束：1. 强制使用静态类型，定义接口替代any类型
interface Packet {
  d: {
    channel_id: string;
    last_pin_timestamp?: string;
  };
}

class ChannelPinsUpdate extends AbstractHandler {
  // 应用约束：1. 强制使用静态类型，明确方法参数类型
  handle(packet: Packet): void {
    const client = this.packetManager.client;
    const data = packet.d;
    
    // 应用约束：1. 强制使用静态类型，添加类型断言
    const channel = client.channels.get(data.channel_id) as Channel | undefined;
    
    // 应用约束：32. 限制一元运算符使用，显式转换日期
    const timeStr = data.last_pin_timestamp ? data.last_pin_timestamp : '';
    const time = timeStr ? new Date(timeStr) : null;

    if (channel && time) {
      // 应用约束：2. 禁止运行时变更对象布局，使用合法属性赋值
      channel.lastPinTimestamp = time.getTime();

      // 应用约束：1. 强制使用静态类型，事件参数保持类型一致
      client.emit(Constants.Events.CHANNEL_PINS_UPDATE, channel, time);
    }
  }
}

// 应用约束：61. 不支持export = ...语法，改用ES6导出
export default ChannelPinsUpdate;

/* 类型补充定义 */
// 应用约束：24. 对象字面量不能用于类型声明，使用接口替代
interface Channel {
  lastPinTimestamp: number | null;
  // 其他频道属性...
}

// 应用约束：1. 强制使用静态类型，扩展Client类型定义
interface Client {
  channels: Map<string, Channel>;
  emit(event: string, ...args: any[]): void;
  // 其他客户端属性...
}
