function helloWorld(): string {
    return "Hello World";
}

function HelloWorldNPM(): string {
    return "Hello World NPM";
}

// 根据约束60：使用ES模块导入语法替代require
// 根据约束28：类不允许implements，但这里使用函数不需要调整
// 根据约束10：显式指定返回类型为string
// 根据约束9：使用let/const替代var
export default HelloWorldNPM;
export { helloWorld };

/* 原始JS中将helloWorld挂载到HelloWorldNPM函数的属性上，但根据约束70(不支持函数属性)，
   改为分别导出两个函数，调用方需要分别import default导出和命名导出 */
