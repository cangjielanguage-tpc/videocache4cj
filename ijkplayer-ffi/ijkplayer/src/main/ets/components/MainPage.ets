import { hilog } from '@kit.PerformanceAnalysisKit';
import { requireCJLib } from "libark_interop_loader.so";

interface CJLib {
  testCJ(src: string): string
}

@Component
export struct MainPage {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            const lib = requireCJLib("libijkplayer4cj.so") as CJLib
            this.message = lib.testCJ("Cangjie")
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}