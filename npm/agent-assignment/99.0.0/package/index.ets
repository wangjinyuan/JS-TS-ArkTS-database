// 应用约束26：使用箭头函数而非函数表达式，但由于原代码使用函数声明，这里保持函数声明并添加返回类型
function helloWorld(): string {
    return "Hello World";
}

// 应用约束26同上，添加返回类型
function HelloWorldNPM(): string {
    return "Hello World NPM";
}

// 应用约束60：改用ES6模块导出语法，替换module.exports
export default HelloWorldNPM;
// 应用约束70：不支持对函数声明属性，改为单独导出helloWorld函数
export { helloWorld };

