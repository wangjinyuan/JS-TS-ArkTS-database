// 应用约束1：强制使用静态类型，为函数参数和返回值添加具体类型
// 应用约束9：使用const代替var声明变量
// 应用约束23：显式标注对象字面量的类型
interface EscapeUtils {
  escape(html: string): string;
  unescape(html: string): string;
}

const escapeUtils: EscapeUtils = {
  escape: function(html: string): string {
    return html
      .replace(/&/g, '&amp;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;');
  },

  unescape: function(html: string): string {
    return html
      .replace(/&amp;/g, '&')
      .replace(/&quot;/g, '"')
      .replace(/&#39;/g, "'")
      .replace(/&lt;/g, '<')
      .replace(/&gt;/g, '>');
  }
};

// 应用约束60：使用ES模块导出语法代替CommonJS
export default escapeUtils;
