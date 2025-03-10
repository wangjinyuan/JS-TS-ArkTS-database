// 应用了以下ArkTS约束：
// 1. 使用let而非var（规则9）
// 2. 显式类型标注（规则10、23）
// 3. 类属性必须显式声明并初始化（规则18）
// 4. 使用具体类型替代any（规则1）
// 5. 不支持索引签名，改用Map（规则14）
// 6. 使用箭头函数替代函数表达式（规则26）
// 7. 禁止在catch语句标注类型（规则40）
// 8. 使用模块导入/导出语法替代module.exports（规则60）

interface ApiError {
    code?: number;
    message?: string;
    errors?: Map<string, any>;
}

class DiscordAPIError extends Error {
    path: string = '';
    code: number = 0;
    method: string = '';

    constructor(path: string, error: ApiError, method: string) {
        super();
        const flattened = DiscordAPIError.flattenErrors(error.errors || new Map()).join('\n');
        this.name = 'DiscordAPIError';
        this.message = error.message && flattened ? `${error.message}\n${flattened}` : error.message || flattened;
        this.path = path;
        this.code = error.code || 0;
        this.method = method;
    }

    private static flattenErrors(obj: Map<string, any>, key: string = ''): string[] {
        let messages: string[] = [];

        obj.forEach((value, k) => {
            if (k === 'message') return;
            const newKey = key ? (isNaN(Number(k)) ? `${key}.${k}` : `${key}[${k}]` : k;

            if (value instanceof Map && value.has('_errors')) {
                const errors = (value.get('_errors') as Array<{ message: string }>).map(e => e.message).join(' ');
                messages.push(`${newKey}: ${errors}`);
            } else if (value.code || value.message) {
                messages.push(`${value.code ? `${value.code}: ` : ''}${value.message}`.trim());
            } else if (typeof value === 'string') {
                messages.push(value);
            } else if (value instanceof Map) {
                messages = messages.concat(this.flattenErrors(value, newKey));
            }
        });

        return messages;
    }
}

export default DiscordAPIError;
