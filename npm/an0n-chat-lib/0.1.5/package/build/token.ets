// 应用约束2：使用let/const而非var，故将var改为const
enum TokenType {
    Normal = 1,
    MFA = 2
}

// 应用约束18：类属性必须在类中显式声明
class Token {
    // 显式声明类属性
    service: string;
    type: TokenType;
    value: string;

    // 应用约束18：构造函数参数需要在类中声明字段
    constructor(service: string, type: TokenType, value: string) {
        this.service = service;
        this.type = type;
        this.value = value;
    }
}

// 应用ES模块导出语法替换CommonJS导出
export { TokenType, Token };

// 应用约束80：import语句需前置，但本例没有import语句
// 应用约束9：使用let/const替换var
// 应用约束7：使用private关键字替代#符号（本例无需修改）
// 应用约束10：避免使用any/unknown类型（本例已保持具体类型）
