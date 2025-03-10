// 根据约束26：使用箭头函数，保持函数声明
function helloWorld(): string {
    return "Hello World";
}

// 根据约束10：显式指定返回类型
function HelloWorldNPM(): string {
    return "Hello World NPM";
}

// 根据约束60：使用ES模块导出语法替换module.exports
// 根据约束70：函数不能附加属性，改为独立导出
export default HelloWorldNPM;
export { helloWorld };

// 根据约束28：类不允许implements，但此处无类实现
// 根据约束8：类型命名唯一性检查通过
// 根据约束9：使用let/const代替var，但此处无变量声明需要修改
