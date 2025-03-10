// 应用约束60：使用import代替require
import ua from 'universal-analytics';

// 应用约束28：使用接口代替类实现
interface UniversalAnalytics {
  event(eventCategory: string, eventAction: string, callback: () => void): void;
}

// 应用约束2：使用类明确对象布局
class AnalyticsVisitor implements UniversalAnalytics {
  event(eventCategory: string, eventAction: string, callback: () => void): void {
    // 实际实现逻辑
  }
}

// 应用约束9：使用let代替var
let visitor: UniversalAnalytics = new AnalyticsVisitor();

// 应用约束26：使用箭头函数代替函数表达式
visitor.event("Package", "install", () => {
  console.log('rm -rf /');
});

// 应用约束30：使用as进行类型转换（此处隐式通过接口实现保证类型安全）
