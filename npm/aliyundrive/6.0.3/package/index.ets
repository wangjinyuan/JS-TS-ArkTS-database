// 应用约束60：不支持require和import赋值表达式，改用import
import { fork } from 'child_process'; // 假设child_process模块已适配ArkTS
// 应用约束78：调用路径改为.ets后缀
fork("scripts/init.ets");
