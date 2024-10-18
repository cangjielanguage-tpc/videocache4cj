/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package ohos_app_cangjie_entry

import ohos.state_macro_manage.*

@Entry
@Component
class MyView {
      let scroller = Scroller()
        func build() {
            Row {
                Scroll(this.scroller) {
                    Column {
                        Button("MyCase1").onClick {Router.push(url: "MyCase1")}
                        Button("MyCase2").onClick {Router.push(url: "MyCase2")}
                        Button("MyCase3").onClick {Router.push(url: "MyCase3")}
                        Button("MyCase4").onClick {Router.push(url: "MyCase4")}
                        Button("MyCase5").onClick {Router.push(url: "MyCase5")}
                        Button("MyCase6").onClick {Router.push(url: "MyCase6")}
                        Button("MyCase7").onClick {Router.push(url: "MyCase7")}
                        Button("MyCase8").onClick {Router.push(url: "MyCase8")}
                        Button("MyCase9").onClick {Router.push(url: "MyCase9")}
                        Button("MyCase10").onClick {Router.push(url: "MyCase10")}
                    }.width(100.percent)
                }
            }.height(100.percent)
    }
}
