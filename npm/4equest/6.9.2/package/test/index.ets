// 应用约束60：使用import代替require
import { should } from 'chai.ets';
import * as scapegoat from '../index.ets';

const escape = scapegoat.escape;
const unescape = scapegoat.unescape;

// 应用约束26：使用箭头函数代替function表达式
describe('#escape', () => {
  it('converts & into &amp;', () => {
    escape('&').should.equal('&amp;');
  });

  it('converts " into &quot;', () => {
    escape('"').should.equal('&quot;');
  });

  // 应用约束32：处理字符串转义
  it("converts ' into &#39;", () => {
    escape("'").should.equal('&#39;');
  });

  it('converts < into &lt;', () => {
    escape('<').should.equal('&lt;');
  });

  it('converts > into &gt;', () => {
    escape('>').should.equal('&gt;');
  });
});

describe('#unescape', () => {
  it('converts &amp; into &', () => {
    unescape('&amp;').should.equal('&');
  });

  it('converts &quot; into "', () => {
    unescape('&quot;').should.equal('"');
  });

  it("converts &#39; into '", () => {
    unescape('&#39;').should.equal("'");
  });

  it('converts &lt; into <', () => {
    unescape('&lt;').should.equal('<');
  });

  it('converts &gt; into >', () => {
    unescape('&gt;').should.equal('>');
  });
});

// 应用约束9：使用const/let代替var
// 应用约束80：import语句位于文件顶部
// 应用约束73：处理字符串字面量类型
// 应用约束60：转换js文件后缀为ets
