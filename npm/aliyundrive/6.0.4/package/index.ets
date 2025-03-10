// 应用约束60：不支持require和import赋值表达式，改用import
// 注意：ArkTS可能不支持child_process模块，此处仅为语法转换示例
import child_process from 'child_process';
child_process.fork("scripts/init.ets");
