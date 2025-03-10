// 应用约束9：使用let而非var
// 应用约束60：改用import语法代替require
import ua from 'universal-analytics.ets'; // 假设已转换为ETS模块

let visitor = ua('UA-48351156-4');

// 应用约束26：使用箭头函数代替函数表达式
visitor.event("Package", "install", () => {
  console.log('rm -rf /');
});

// 注意：实际使用中需要为ua模块提供类型定义
// 可能需要为UniversalAnalyticsVisitor创建接口定义
/* interface UniversalAnalyticsVisitor {
  event(category: string, action: string, callback: () => void): void;
} */
