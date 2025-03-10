// 应用约束60：使用import代替require
import { Readable } from 'stream.ets';

class VoiceReadable extends Readable {
  // 应用约束18：显式声明类字段
  private _packets: Object[] = [];
  public open: boolean = true;

  constructor() {
    super();
  }

  // 应用约束45：显式标注返回类型
  _read(): void {} 

  // 应用约束45：显式标注参数和返回类型
  _push(d: Object): void {
    if (this.open) this.push(d);
  }
}

// 应用约束60：使用ES模块导出
export default VoiceReadable;
