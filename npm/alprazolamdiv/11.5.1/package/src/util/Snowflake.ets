// 应用约束：60. 不支持require和import赋值表达式，改用ES模块导入
import Long from './long.ets'; // 假设long模块已转换为ets

// 应用约束：1. 强制使用静态类型，2. 使用let而非var（约束9）
const EPOCH: number = 1420070400000;
let INCREMENT: number = 0;

// 应用约束：24. 对象字面量不能用于类型声明，使用接口定义类型
interface DeconstructedSnowflake {
    timestamp: number;
    date: Date;
    workerID: number;
    processID: number;
    increment: number;
    binary: string;
}

class SnowflakeUtil {
    // 应用约束：18. 类字段在类中声明
    constructor() {
        throw new Error(`The ${this.constructor.name} class may not be instantiated.`);
    }

    // 应用约束：1. 强制类型标注，10. 禁止any类型
    static generate(timestamp: number | Date = Date.now()): string {
        if (timestamp instanceof Date) timestamp = timestamp.getTime();
        if (typeof timestamp !== 'number' || isNaN(timestamp)) {
            throw new TypeError(
                `"timestamp" argument must be a number (received ${isNaN(timestamp as number) ? 'NaN' : typeof timestamp})`
            );
        }
        
        // 应用约束：32. 运算符类型限制
        if (INCREMENT >= 4095) INCREMENT = 0;
        
        // 应用约束：25. 数组字面量类型推断
        const binaryStr = `${pad((timestamp - EPOCH).toString(2), 42)}0000100000${pad((INCREMENT++).toString(2), 12)}`;
        
        // 应用约束：30. 类型转换使用as语法
        return Long.fromString(binaryStr, 2).toString() as string;
    }

    static deconstruct(snowflake: string): DeconstructedSnowflake {
        // 应用约束：30. 类型安全转换
        const binaryStr = pad(Long.fromString(snowflake).toString(2), 64);
        
        // 应用约束：24. 使用类代替对象字面量
        class Result implements DeconstructedSnowflake {
            timestamp: number;
            workerID: number;
            processID: number;
            increment: number;
            binary: string;

            constructor() {
                this.timestamp = parseInt(binaryStr.substring(0, 42), 2) + EPOCH;
                this.workerID = parseInt(binaryStr.substring(42, 47), 2);
                this.processID = parseInt(binaryStr.substring(47, 52), 2);
                this.increment = parseInt(binaryStr.substring(52, 64), 2);
                this.binary = binaryStr;
            }

            // 应用约束：29. 使用getter代替defineProperty
            get date(): Date {
                return new Date(this.timestamp);
            }
        }

        return new Result();
    }
}

// 应用约束：1. 添加类型标注，26. 使用箭头函数
const pad = (v: string, n: number, c: string = '0'): string => {
    return v.length >= n ? v : (c.repeat(n) + v).slice(-n);
};

// 应用约束：61. 使用ES模块导出
export default SnowflakeUtil;
