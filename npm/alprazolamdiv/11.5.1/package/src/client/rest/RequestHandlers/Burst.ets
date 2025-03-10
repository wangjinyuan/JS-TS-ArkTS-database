// 应用ArkTS约束：
// 1. 使用let/const代替var
// 2. 使用ES6 import语法代替require
// 3. 显式类属性声明
// 4. 类型标注增强
// 5. 模块导出使用export default
// 6. 使用箭头函数代替函数表达式
// 7. 强制严格类型检查

import RequestHandler from './RequestHandler.ets';
import DiscordAPIError from '../DiscordAPIError.ets';
import Constants from '../../../util/Constants.ets';

const RATE_LIMIT = Constants.Events.RATE_LIMIT;

class BurstRequestHandler extends RequestHandler {
    // 显式声明类属性
    client: any;
    limit: number;
    resetTime: number | null;
    remaining: number;
    timeDifference: number;
    resetTimeout: any | null;
    globalLimit: boolean = false;

    constructor(restManager: any, endpoint: string) {
        super(restManager, endpoint);

        this.client = restManager.client;
        this.limit = Infinity;
        this.resetTime = null;
        this.remaining = 1;
        this.timeDifference = 0;
        this.resetTimeout = null;
    }

    push(request: any): void {
        super.push(request);
        this.handle();
    }

    execute(item: any): void {
        if (!item) return;
        item.request.gen().end((err: any, res: any) => {
            if (res && res.headers) {
                this.limit = Number(res.headers['x-ratelimit-limit']);
                this.resetTime = Number(res.headers['x-ratelimit-reset']) * 1000;
                this.remaining = Number(res.headers['x-ratelimit-remaining']);
                this.timeDifference = Date.now() - new Date(res.headers.date).getTime();
            }
            if (err) {
                if (err.status === 429) {
                    this.queue.unshift(item);
                    if (res.headers['x-ratelimit-global']) this.globalLimit = true;
                    if (this.resetTimeout) return;
                    this.resetTimeout = setTimeout((): void => {
                        this.remaining = this.limit;
                        this.globalLimit = false;
                        this.handle();
                        this.resetTimeout = null;
                    }, Number(res.headers['retry-after']) + this.client.options.restTimeOffset);
                } else if (err.status >= 500 && err.status < 600) {
                    if (item.retries === this.client.options.retryLimit) {
                        item.reject(err);
                        this.handle();
                    } else {
                        item.retries++;
                        this.queue.unshift(item);
                        this.resetTimeout = setTimeout((): void => {
                            this.handle();
                            this.resetTimeout = null;
                        }, 1e3 + this.client.options.restTimeOffset);
                    }
                } else {
                    item.reject(err.status >= 400 && err.status < 500 ?
                        new DiscordAPIError(res.request.path, res.body, res.request.method) : err);
                    this.handle();
                }
            } else {
                if (this.remaining === 0) {
                    if (this.client.listenerCount(RATE_LIMIT)) {
                        this.client.emit(RATE_LIMIT, {
                            limit: this.limit,
                            timeDifference: this.timeDifference,
                            path: item.request.path,
                            method: item.request.method,
                        });
                    }
                }
                this.globalLimit = false;
                const data = res && res.body ? res.body : {};
                item.resolve(data);
                this.handle();
            }
        });
    }

    handle(): void {
        super.handle();
        if (this.queue.length === 0) return;
        if ((this.remaining <= 0 || this.globalLimit) && Date.now() - this.timeDifference < (this.resetTime || 0)) return;
        this.execute(this.queue.shift());
        this.remaining--;
        this.handle();
    }
}

export default BurstRequestHandler;
