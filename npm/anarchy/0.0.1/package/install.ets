// 原始JavaScript代码为空，以下为示例代码展示转换规则应用
// 示例中应用了以下ArkTS约束：
// 7. 使用private关键字代替#私有字段
// 9. 使用let代替var
// 18. 类字段需在类中显式声明
// 30. 类型转换使用as语法
// 32. 运算符仅用于数值类型

class Example {
  private privateField: number = 42; // 应用规则7
  x: number = 0;                     // 应用规则18
  y: number = 0;                     // 应用规则18

  constructor(x: number, y: number) { // 显式类型标注
    this.x = x;
    this.y = y;
  }

  getSum(): number {
    return this.x + this.y;
  }
}

let obj = new Map<Object, string>(); // 应用规则5和9
obj.set('name', 'test');
obj.set(3 as unknown as Object, 'value'); // 应用规则30
console.log(obj.get(3 as unknown as Object)); // 应用规则5

function dynamicProps(obj: Object): Object { // 显式类型标注
  // 应用规则2和21：禁止动态添加属性
  // 需要重构为类型安全的方式，这里保持空实现
  return obj;
}

// 数值类型运算示例
let num = +42; // 应用规则32合法运算
let strNum = parseInt('42'); // 显式类型转换代替隐式转换
console.log(-strNum); // 合法数值运算
