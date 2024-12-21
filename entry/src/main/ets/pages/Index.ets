import { NodeController,FrameNode,UIContext } from '@kit.ArkUI';
import {requireCJLib} from "libark_interop_loader.so"


interface a{
  test_getloadCJPage():string,
  test_getArkTSCallback(cb:Function):string
  setContext(context:Context):string
}

export class CangjieLib{

  private constructor(){

  }

  private static instance:a

  public static getInstance():a{
    if(!CangjieLib.instance){
      CangjieLib.instance = requireCJLib("libohos_app_cangjie_entry.so") as a
    }
    return CangjieLib.instance
  }

}



class MyNodeController extends NodeController{
  private rootNode:FrameNode|null = null;

  makeNode(uiContext: UIContext): FrameNode | null {
    if(this.rootNode === null){
      let cjlib:a = requireCJLib("libohos_app_cangjie_entry.so") as a
      cjlib.test_getloadCJPage()
    }
    return this.rootNode
  }
}


@Entry
@Component
struct Index{
  private baseNode:MyNodeController = new MyNodeController()

  build(){
    Column(){
      NodeContainer(this.baseNode)
    }.height('100%').width('100%')
  }

}


// import { requireCJLib } from "libark_interop_loader.so";
//
// interface CJLib {
//   testCJ(src: string): string
// }
//
// @Entry
// @Component
// struct Index {
//   @State message: string = 'Hello World';
//
//   build() {
//     RelativeContainer() {
//       Text(this.message)
//         .fontSize(40)
//         .fontWeight(FontWeight.Bold)
//         .alignRules({
//           center: { anchor: '__container__', align: VerticalAlign.Center },
//           middle: { anchor: '__container__', align: HorizontalAlign.Center }
//         })
//         .onClick(() => {
//           const lib = requireCJLib("libohos_app_cangjie_entry.so") as CJLib
//           this.message = lib.testCJ("Cangjie")
//         })
//     }
//     .height('100%')
//     .width('100%')
//   }
// }