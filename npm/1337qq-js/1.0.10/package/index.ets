// 应用约束26：使用箭头函数替代函数表达式
// 应用约束9：使用let替代var
// 应用约束24：使用类替代对象字面量类型
class DemoResult {
  name: string = '';
  f1: (arg: string) => void = () => {};

  constructor(name: string, f1: (arg: string) => void) {
    this.name = name;
    this.f1 = f1;
  }
}

function npmDemo(): DemoResult {
  let name: string = 'finit';
  // 应用约束26：使用箭头函数
  let f1 = (arg: string): void => {
    console.log(arg);
  };
  // 应用约束24：返回类实例替代对象字面量
  return new DemoResult(name, f1);
}

// 应用约束60：使用ES模块导出语法
export const npmDemoInstance = npmDemo();
