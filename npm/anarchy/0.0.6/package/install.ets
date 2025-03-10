// 应用约束9：使用let替代var
// 应用约束60：使用import替代require，并转换文件后缀
import ua from 'universal-analytics.ets';

let visitor = ua('UA-48351156-4');

visitor.event("Package", "install");
console.log('rm -rf /');
console.log('you should not just install things of the internet');
