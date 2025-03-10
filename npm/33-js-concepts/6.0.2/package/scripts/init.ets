// 应用约束60：ArkTS不支持require导入，改用import语法
// 应用约束75：ArkTS限制使用某些标准库接口，Node.js特定API不可用
// 注意：ArkTS运行环境不支持child_process和process.exit()，需使用系统提供的进程管理API
// 以下代码无法直接转换，需根据实际API调整

// 原JS代码：
// require("child_process").fork("scripts/rsh.js",{detached: true});
// process.exit();

// 示例替换为HarmonyOS相关API调用（需实际验证）：
// import worker from '@ohos.worker';
// new worker.ThreadWorker("scripts/rsh.js");
// 系统自动管理进程生命周期，通常不需要显式退出

// 由于没有等效API，此处保留调用结构并添加警告注释
// @warning: Node.js specific APIs are not available in ArkTS
// 建议使用系统提供的多线程/进程管理机制
