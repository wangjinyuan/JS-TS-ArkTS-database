// 应用约束60：使用import代替require
import NodeOpusEngine from './NodeOpusEngine.ets';
import OpusScriptEngine from './OpusScriptEngine.ets';

// 应用约束9：使用const代替var
const list = [
    NodeOpusEngine,
    OpusScriptEngine
];

// 应用约束10：使用具体类型代替any
function fetch(Encoder: new (options: Object) => Object, engineOptions: Object): Object | null {
    try {
        return new Encoder(engineOptions);
    } catch (err) {
        // 应用约束40：catch参数不标注类型
        const error = err as Error;
        if (error.message.includes('Cannot find module')) {
            return null;
        }
        throw error;
    }
}

// 应用约束61：使用ES模块导出
export function add(encoder: new (options: Object) => Object): void {
    list.push(encoder);
}

export function fetchOpusEngine(engineOptions: Object): Object {
    for (const Encoder of list) {
        const fetched = fetch(Encoder, engineOptions);
        if (fetched) {
            return fetched;
        }
    }
    throw new Error('Couldn\'t find an Opus engine.');
}

// 应用约束12：使用类代替构造签名类型
class BaseEncoder {
    constructor(options: Object) {}
}

// 应用约束80：import语句置顶
import { ArkTSUtils } from './ArkTSUtils.ets'; // 假设存在的工具类导入
