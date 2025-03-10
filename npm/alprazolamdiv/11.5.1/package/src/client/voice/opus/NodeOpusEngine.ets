// 应用约束60：使用import代替require
import OpusEngine from './BaseOpusEngine.ets';
// 应用约束60：使用import代替require
import opus from 'node-opus.ets';

class NodeOpusEngine extends OpusEngine {
  // 应用约束18：类字段必须在类中声明
  private encoder: Object;

  // 应用约束48：显式声明构造函数参数类型
  constructor(player: Object) {
    super(player);
    // 应用约束7：使用private代替#私有字段
    // 应用约束18：移除构造函数参数中的字段声明
    // 应用约束30：使用as进行类型转换
    this.encoder = new (opus as any).OpusEncoder(this.samplingRate, this.channels);
    super.init();
  }

  // 应用约束10：显式指定参数和返回类型
  setBitrate(bitrate: number): void {
    this.encoder.applyEncoderCTL(this.ctl.BITRATE, Math.min(128, Math.max(16, bitrate)) * 1000);
  }

  setFEC(enabled: boolean): void {
    this.encoder.applyEncoderCTL(this.ctl.FEC, enabled ? 1 : 0);
  }

  setPLP(percent: number): void {
    this.encoder.applyEncoderCTL(this.ctl.PLP, Math.min(100, Math.max(0, percent * 100)));
  }

  encode(buffer: Object): Object {
    super.encode(buffer);
    return this.encoder.encode(buffer, 1920);
  }

  decode(buffer: Object): Object {
    super.decode(buffer);
    return this.encoder.decode(buffer, 1920);
  }
}

// 应用约束60：使用export代替module.exports
export default NodeOpusEngine;
