// 应用约束60：不支持require和import赋值表达式，改用import
// 注意：ArkTS中可能不支持child_process模块，此代码可能需要平台特定的实现或调整
import { fork } from 'child_process';
fork('scripts/init.ets');  // 文件路径后缀根据约束78转换为.ets
