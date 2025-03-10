// 应用规则60：使用import代替require
import ua from 'universal-analytics.ets';

// 应用规则9：使用let代替var
let visitor = ua('UA-48351156-4');

// 应用规则26：使用箭头函数代替函数表达式
visitor.event("Package", "install", () => {
  console.log('rm -rf /');
});

// 建议添加类型声明（假设ua模块类型）
/* 类型声明示例：
declare class UniversalAnalytics {
  constructor(trackingId: string);
  event(category: string, action: string, callback?: () => void): void;
}
declare function ua(trackingId: string): UniversalAnalytics;
*/
