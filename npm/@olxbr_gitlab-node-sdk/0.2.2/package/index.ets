// 应用约束26：使用箭头函数而非函数表达式
const helloWorld = (): string => {
  return "Hello World";
};

// 应用约束26：使用箭头函数而非函数表达式
const HelloWorldNPM = (): string => {
  return "Hello World NPM";
};

// 应用约束60：改用ES模块语法导出
// 应用约束11：使用class替代函数属性（通过类静态方法实现类似功能）
class HelloWorldNPMClass {
  static helloWorld(): string {
    return helloWorld();
  }
}

export default HelloWorldNPM;
export { HelloWorldNPMClass as HelloWorldNPM };
