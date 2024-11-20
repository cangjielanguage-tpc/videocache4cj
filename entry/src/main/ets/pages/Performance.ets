/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import router from '@ohos.router';
import { IjkMediaPlayer } from "@ohos/ijkplayer";
import { OnPreparedListener } from "@ohos/ijkplayer";
import { OnVideoSizeChangedListener } from "@ohos/ijkplayer";
import { OnCompletionListener } from "@ohos/ijkplayer";
import { OnBufferingUpdateListener } from "@ohos/ijkplayer";
import { OnErrorListener } from "@ohos/ijkplayer";
import { OnInfoListener } from "@ohos/ijkplayer";
import { OnSeekCompleteListener } from "@ohos/ijkplayer";
import { LogUtils } from "@ohos/ijkplayer"
import { PlayStatus } from "../common/PlayStatus"
import prompt from '@ohos.prompt';
import { RouterParam } from "./RouterParam"
import systemDateTime from '@ohos.systemDateTime';

let mIjkMediaPlayer = IjkMediaPlayer.getInstance();
let xid: string = "xcomponentId"
let testUrl: string = ""

let isTest10: boolean = true;
let isTest100: boolean = true;
let isTest1000: boolean = true;
let isTest10000: boolean = true;

let IPlayerFuncMap: Map<string, ((times: number, funcName: string) => void)> = new Map();

IPlayerFuncMap["reset"] = (times: number, funcName: string): void => {
  let start: number = Date.now() * 1e6;
  for (let index = 0; index < times; index++) {
    mIjkMediaPlayer.reset();
  }
  let end: number = Date.now() * 1e6;
  console.warn("[ PASSED ] CASE: TestSuite_" + funcName + "_" + /*"次数"*/ times + " (" + (end - start) +
    "ns, " /*"总时间"*/ + /*"平均时间"*/ ((end - start) / times) + "ns/op)");
}

IPlayerFuncMap["setDebug"] = (times: number, funcName: string): void => {
  mIjkMediaPlayer.reset()
  let start: number = Date.now() * 1e6;
  for (let index = 0; index < times; index++) {
    mIjkMediaPlayer.setDebug(true);
  }
  let end: number = Date.now() * 1e6;
  console.warn("[ PASSED ] CASE: TestSuite_" + funcName + "_" + /*"次数"*/times + " (" + (end - start) + "ns, "/*"总时间"*/ + /*"平均时间"*/((end - start) / times) + "ns/op)")
}

IPlayerFuncMap["native_setup"] = (times: number, funcName: string): void => {
  mIjkMediaPlayer.reset()
  mIjkMediaPlayer.setDebug(true);
  let start: number = Date.now() * 1e6;
  for (let index = 0; index < times; index++) {
    mIjkMediaPlayer.native_setup();
  }
  let end: number = Date.now() * 1e6;
  console.warn("[ PASSED ] CASE: TestSuite_" + funcName + "_" + /*"次数"*/times + " (" + (end - start) + "ns, "/*"总时间"*/ + /*"平均时间"*/((end - start) / times) + "ns/op)")
}

IPlayerFuncMap["setDataSource"] = (times: number, funcName: string): void => {
  mIjkMediaPlayer.reset()
  mIjkMediaPlayer.setDebug(true);
  mIjkMediaPlayer.native_setup();
  let start: number = Date.now() * 1e6;
  for (let index = 0; index < times; index++) {
    mIjkMediaPlayer.setDataSource(testUrl);
  }
  let end: number = Date.now() * 1e6;
  console.warn("[ PASSED ] CASE: TestSuite_" + funcName + "_" + /*"次数"*/times + " (" + (end - start) + "ns, "/*"总时间"*/ + /*"平均时间"*/((end - start) / times) + "ns/op)")
}

IPlayerFuncMap["setDataSourceHeader"] = (times: number, funcName: string): void => {
  mIjkMediaPlayer.reset()
  mIjkMediaPlayer.setDebug(true);
  mIjkMediaPlayer.native_setup();
  mIjkMediaPlayer.setDataSource(testUrl);
  let headers = new Map([
    ["user_agent", "Mozilla/5.0 BiliDroid/7.30.0 (bbcallen@gmail.com)"],
    ["referer", "https://www.bilibili.com"]
  ]);
  let start: number = Date.now() * 1e6;
  for (let index = 0; index < times; index++) {
    mIjkMediaPlayer.setDataSourceHeader(headers);
  }
  let end: number = Date.now() * 1e6;
  console.warn("[ PASSED ] CASE: TestSuite_" + funcName + "_" + /*"次数"*/times + " (" + (end - start) + "ns, "/*"总时间"*/ + /*"平均时间"*/((end - start) / times) + "ns/op)")
}

@Entry
@Component
struct Performance {
  @State videoUrl: string = (router.getParams() as RouterParam).videoUrl
  @State funcName: string = (router.getParams() as RouterParam).funcName
  @State titleName: string = (router.getParams() as RouterParam).titleName
  @State mContext: object | undefined = undefined;
  private timesArr: Array<number> = [10, 100, 1000, 10000, 100000];

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Text(this.titleName)
          .fontSize(26)
          .fontColor(Color.White)
          .margin(10)
          .fontWeight(FontWeight.Bold)
      }.height(70).width('100%').backgroundColor(Color.Black)

      Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
        Image($r('app.media.back'))
          .width(25)
          .height(20)
        Text("返回")
          .fontSize(20)
          .fontColor(Color.Black)
          .fontStyle(FontStyle.Normal)
          .textAlign(TextAlign.Start)
          .padding(0)
          .width('100%')
      }.onClick(() => {
        router.back()
      })

      Row() {
        XComponent({
          id: xid,
          type: 'surface',
          libraryname: 'ijkplayer_napi'
        })
          .onLoad((event?: object) => {
            if (!!event) {
              this.initContext(event);
            }
          })
          .onDestroy(() => {
          })
          .width('100%')
          .height('30%')
      }

      ForEach(this.timesArr, (times: number) => {
        Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
          Button("点击测试" + times + "次")
            .fontStyle(FontStyle.Normal)
            .padding(15)
        }.onClick(() => {
          this.funcSwitch(times);
        })
      })
    }
  }

  private funcSwitch(times: number) {
    switch (this.funcName) {
      case "reset":
        IPlayerFuncMap["reset"](times, this.funcName)
        break
      case "setDebug":
        IPlayerFuncMap["setDebug"](times, this.funcName)
        break
      case "native_setup":
        IPlayerFuncMap["native_setup"](times, this.funcName)
        break
      case "setDataSource":
        IPlayerFuncMap["setDataSource"](times, this.funcName)
        break
      case "setDataSourceHeader":
        IPlayerFuncMap["setDataSourceHeader"](times, this.funcName)
        break
      default:
        return
    }
  }

  private initContext(context: object) {
    this.mContext = context;
    mIjkMediaPlayer.setContext(this.mContext,"xcomponentId")
    testUrl = this.videoUrl
  }

  private getCurrentTime(): number {
    let start: number = 0
    systemDateTime.getCurrentTime(true).then((time: number) => {
      start = time;
    })
    return start;
  }

  private getTestStatus(times: number): boolean {
    switch (times) {
      case 10:
        return isTest10
      case 100:
        return isTest100
      case 1000:
        return isTest1000
      case 10000:
        return isTest10000
      default:
        return false
    }
  }

}