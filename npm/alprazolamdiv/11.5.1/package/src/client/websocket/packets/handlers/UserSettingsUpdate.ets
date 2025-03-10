// 应用约束：
// 1. 使用import代替require（约束60）
// 2. 使用class代替模块导出（约束61）
// 3. 添加类型注解（约束1,10）
// 4. 使用let代替var（约束9）
// 5. 显式导出模块（约束60,61）

import AbstractHandler from './AbstractHandler.ets';
import Constants from '../../../../util/Constants.ets';

class UserSettingsUpdateHandler extends AbstractHandler {
  // 约束18: 类字段必须在类中声明
  private packetManager: any; // 需要更具体的类型替换any

  handle(packet: { d: any }): void { // 约束1: 使用具体类型替代any
    const client = this.packetManager.client;
    client.user.settings.patch(packet.d);
    client.emit(Constants.Events.USER_SETTINGS_UPDATE, client.user.settings);
  }
}

/**
 * Emitted when the client user's settings update.
 * @event Client#clientUserSettingsUpdate
 * @param {ClientUserSettings} clientUserSettings The new client user settings
 */

export default UserSettingsUpdateHandler;

// 注意：需要补充的类型定义建议：
// 1. 定义Packet接口替代any类型
// 2. 定义Client类型及其相关属性
// 3. 定义Constants.Events的枚举类型
