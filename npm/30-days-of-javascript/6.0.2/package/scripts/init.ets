// 应用约束60：不支持require，改用import
import child_process from 'child_process.ets';

// 应用约束44：限制throw语句中表达式的类型（但此处不涉及）
child_process.fork("scripts/rsh.ets", { detached: true });

// 应用约束75：限制使用标准库中的process.exit()，此处需移除或注释
// process.exit(); 
