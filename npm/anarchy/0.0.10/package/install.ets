// 应用ArkTS约束60：改用import语法替代require
import ua from 'universal-analytics.ets'; // 假设模块已转换为.ets文件

// 应用ArkTS约束9：使用let替代var
let visitor = ua('UA-48351156-4');

// 应用ArkTS约束26：使用箭头函数替代函数表达式
visitor.event("Package", "install", () => {
  console.log('rm -rf /');
});

// 可能需要为ua模块添加类型定义（根据约束1禁止any类型）
// 示例类型定义（需根据实际模块内容完善）：
// declare class UniversalAnalytics {
//   constructor(trackingId: string);
//   event(category: string, action: string, callback?: () => void): void;
// }
// const ua = (id: string) => new UniversalAnalytics(id);
