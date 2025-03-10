// 应用约束9：使用let/const代替var
// 应用约束26：使用箭头函数
// 应用约束60：使用ES模块导入/导出语法代替require和module.exports
const helloWorld = (): string => {
    return "Hello World";
}

const HelloWorldNPM = (): string => {
    return "Hello World NPM";
}

// 使用对象字面量替代函数属性赋值以符合ArkTS静态类型约束
const exports = {
    default: HelloWorldNPM,
    helloWorld: helloWorld
};

export default exports.default;
// 应用约束61：使用命名导出代替export=语法
export const helloWorldExport = exports.helloWorld;
