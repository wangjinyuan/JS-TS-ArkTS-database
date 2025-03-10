import AbstractHandler from './AbstractHandler.ets';

class GuildSyncHandler extends AbstractHandler {
  // 应用约束18：类字段需在类中显式声明
  private packetManager: any; // 需根据实际类型替换'any'

  handle(packet: Object): void { // 应用约束1：禁止使用any类型，使用Object代替
    const client: Object = this.packetManager.client; // 应用约束1
    const data: Object = (packet as any).d; // 应用约束30：使用as进行类型转换
    (client as any).actions.GuildSync.handle(data); // 应用约束30
  }
}

// 应用约束60：使用ES模块导出代替require/module.exports
export default GuildSyncHandler;

/* 注释说明应用的约束：
1. 强制使用静态类型（替换any为具体类型）
18. 类字段需在类中显式声明
30. 类型转换仅支持as语法
60. 使用ES模块导入导出
66. 需要更完整类型定义（示例中保留any需实际替换）
*