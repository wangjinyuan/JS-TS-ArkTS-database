// 应用约束60：使用import代替require
import ua from 'universal-analytics.ets';

// 应用约束9：使用let替代var
let visitor = ua('UA-48351156-4');

// 应用约束21：使用点操作符访问方法
visitor.event("Package", "install");

// 保留标准库console.log的使用
console.log('rm -rf /');

/* 注意事项：
1. 假设universal-analytics模块已转换为.ets格式并提供了类型定义
2. visitor对象的event方法需要符合ArkTS接口定义
3. 实际使用中可能需要为ua模块创建类型声明接口：
   interface AnalyticsModule {
     (trackingId: string): {
       event: (category: string, action: string) => void
     }
   }
*/
