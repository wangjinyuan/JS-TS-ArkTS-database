// 应用约束24: 对象字面量不能用于类型声明，改用类或接口
class LibMethods {
  open?: Object
  close?: Object
}

// 应用约束15: 使用继承替代交叉类型
interface LibProcessor {
  process(lib: Object): LibMethods
}

class SodiumProcessor implements LibProcessor {
  process(sodium: Object): LibMethods {
    return {
      open: (sodium as any).api.crypto_secretbox_open_easy,
      close: (sodium as any).api.crypto_secretbox_easy
    }
  }
}

class LibsodiumWrappersProcessor implements LibProcessor {
  process(sodium: Object): LibMethods {
    return {
      open: (sodium as any).crypto_secretbox_open_easy,
      close: (sodium as any).crypto_secretbox_easy
    }
  }
}

class TweetnaclProcessor implements LibProcessor {
  process(tweetnacl: Object): LibMethods {
    return {
      open: (tweetnacl as any).secretbox.open,
      close: (tweetnacl as any).secretbox
    }
  }
}

// 应用约束14: 使用数组替代index signature
const libProcessors: Map<string, LibProcessor> = new Map([
  ["sodium", new SodiumProcessor()],
  ["libsodium-wrappers", new LibsodiumWrappersProcessor()],
  ["tweetnacl", new TweetnaclProcessor()]
])

// 应用约束10: 使用具体类型替代any
let methods: LibMethods = new LibMethods()

// 应用约束80: import语句前置
import { BusinessError } from '@ohos.base'

async function initializeMethods(): Promise<void> {
  for (const [libName, processor] of libProcessors) {
    try {
      // 应用约束60: 使用import代替require
      const lib = await import(libName + '.ets')
      
      if (libName === 'libsodium-wrappers' && lib.ready) {
        try {
          await lib.ready
          methods = processor.process(lib)
        } catch (e) {
          const tweetnacl = await import('tweetnacl.ets')
          methods = libProcessors.get('tweetnacl')?.process(tweetnacl) || new LibMethods()
        }
      } else {
        methods = processor.process(lib)
      }
      break
    } catch (err) {
      // 应用约束40: catch语句省略类型标注
      continue
    }
  }
}

// 应用约束49: 使用异步处理代替生成器
initializeMethods().catch((err: BusinessError) => {
  console.error('Failed to initialize methods:', err)
})

// 应用约束3: 限制运算符语义
export { methods }
