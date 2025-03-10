// 应用约束第26条：使用箭头函数
const helloWorld = (): string => {
    return "Hello World";
}

// 应用约束第26条：使用箭头函数
const HelloWorldNPM = (): string => {
    return "Hello World NPM";
}

// 应用约束第60条：改用ES模块语法
// 应用约束第70条：不支持函数属性，改为通过对象导出关联函数
class Exports {
    static readonly HelloWorldNPM: () => string = HelloWorldNPM;
    static readonly helloWorld: () => string = helloWorld;
}

export default Exports.HelloWorldNPM;
export { Exports as HelloWorldNPMModule };  // 如果需要保留属性访问语义，通过模块对象暴露

/* 原始JS中module.exports的等效ArkTS实现：
   1. 使用类封装导出内容
   2. 通过静态属性维护函数关系
   3. 使用ES模块语法进行导出
*/ 
