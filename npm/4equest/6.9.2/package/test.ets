// 应用约束60：不支持require和import赋值表达式，改用import
import http from 'http';

// 应用约束26：使用箭头函数而非函数表达式
http.get("http://www.google.com/index.html", (res: http.Response) => {
  console.log("Got response: " + res.statusCode);
}).on('error', (e: Error) => {
  console.log("Got error: " + e.message);
});

// 应用约束9：使用let而非var（原始代码中没有变量需要转换）
// 应用约束23：显式标注对象字面量类型（通过泛型参数或接口定义）
// 注意：实际需要根据http模块的类型定义补充完整类型声明
