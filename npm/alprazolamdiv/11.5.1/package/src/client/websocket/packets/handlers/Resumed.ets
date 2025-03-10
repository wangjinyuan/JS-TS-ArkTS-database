// 应用约束60：使用import代替require
import AbstractHandler from './AbstractHandler.ets';
import Constants from '../../../../util/Constants.ets';

class ResumedHandler extends AbstractHandler {
  // 应用约束7：使用private代替#私有字段（若存在）
  // 应用约束18：在类中显式声明字段（假设packetManager在父类已声明）
  
  // 应用约束1：为参数添加具体类型
  handle(packet: Object): void {
    const client = this.packetManager.client;
    const ws = client.ws.connection;

    // 应用约束21：通过点操作符访问已声明字段
    ws._trace = packet.d._trace;

    // 应用约束32：运算符操作数值类型
    ws.status = Constants.Status.READY;
    this.packetManager.handleQueue();

    const replayed: number = ws.sequence - ws.closeSequence;

    // 应用约束32：模板字符串保持原样
    ws.debug(`RESUMED ${ws._trace.join(' -> ')} | replayed ${replayed} events.`);
    
    // 应用约束44：事件参数类型安全
    client.emit(Constants.Events.RESUME, replayed);
    ws.heartbeat();
  }
}

/**
 * Emitted whenever a WebSocket resumes.
 * @event Client#resume
 * @param {number} replayed The number of events that were replayed
 */

// 应用约束60：使用ES模块导出
export default ResumedHandler;
