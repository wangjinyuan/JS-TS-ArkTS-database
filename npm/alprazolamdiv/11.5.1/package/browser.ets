// 应用约束60：使用import代替require
import Discord from './index.ets';

// 应用约束78：.ets文件import其他.ets文件
// 应用约束75：移除process.env和window相关的非标准库用法
// 应用约束9：使用const/let代替var（原代码已符合）
// 应用约束80：import语句放在文件顶部

export default Discord;

// 注释掉浏览器环境相关代码（ArkTS不支持浏览器环境判断）
// if (browser && webpack) window.Discord = Discord;
// else if (!browser);
