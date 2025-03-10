function helloWorld(): string {
  return "Hello World";
}

function HelloWorldNPM(): string {
  return "Hello World NPM";
}

// 应用约束70：不支持对函数声明属性，改用模块导出替代属性挂载
// 应用约束60：不支持require和import赋值表达式，改用ES模块导出
// 应用约束61：不支持export =语法，改为常规export
export default HelloWorldNPM;
export { helloWorld };
