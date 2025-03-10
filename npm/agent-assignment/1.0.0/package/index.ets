// 应用约束26：使用箭头函数而非函数表达式
const helloWorld = (): string => {
    return "Hello World";
}

// 应用约束26：使用箭头函数而非函数表达式
const HelloWorldNPM = (): string => {
    return "Hello World NPM";
}

// 应用约束60：使用ES模块导出语法替代CommonJS的module.exports
// 应用约束11：使用class而非具有call signature的类型
class Exports {
    static HelloWorldNPM = HelloWorldNPM;
    static helloWorld = helloWorld;
}

export default Exports.HelloWorldNPM;
