// 应用约束60：不支持require和import赋值表达式，改用import
import { fork } from 'child_process';

// 应用约束22：显式标注泛型函数类型实参（此处无泛型需要标注）
// 应用约束32：运算符仅适用于数值类型（此处无相关操作）
fork("scripts/init.ets");  // 根据要求将js文件后缀改为ets
