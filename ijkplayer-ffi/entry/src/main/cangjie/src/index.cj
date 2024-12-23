/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package ohos_app_cangjie_entry

import ohos.state_macro_manage.*
import ijkplayer4cj.XComponent
import std.time.Duration

@Entry
@Component
class EntryView {
    var videoUrl: String = "https://1251542705.vod2.myqcloud.com/4a8d9c67vodtransgzp1251542705/203109c63270835013529449619/v.f1419907.mp4"

    let mIjkMediaPlayer: IjkMediaPlayer = IjkMediaPlayer.getInstance()

    var volume: Float32 = 0.5

    var playSpeed: String = "1f"

    @State
    var mFirst: Bool = true
    @State
    var mDestroyPage: Bool = false

    var playStatus: PlayStatus = PlayStatus.INIT

    @State
    var isCurrentTime: Bool = false

    @State
    var oldSeconds: Int64 = 0

    @State
    var isSeekTo: Bool = false

    @State
    var slideEnable: Bool = false

    @State
    var PROGRESS_MAX_VALUE: Int64 = 100

    @State
    var totalTime: String = "00:00"

    @State
    var currentTime: String = "00:00"

    @State
    var updateProgressTimer: Int64 = 0

    @State
    var loadingVisible: Visibility = Visibility.None

    @State
    var replayVisible: Visibility = Visibility.None

    @State
    var curIndex: Int64 = -1

    @State
    var progressValue: Int64 = 0

    @State
    var initAspectRatio: Float64 = 1.0

    @State
    var videoAspectRatio: Float64 = 1.0

    @State
    var videoParentAspectRatio: Int32 = 1;

    @State
    var videoWidth: Length = Length(100, unitType: percent)

    private var videoUrls: Array<String> = [
        "https://cdn-vod-playlet.wtzw.com/asset/c0127835e4ed22e0f763b2261311b998/fc74f32bb6b5b764c6d790ea30399f60.mov",
        "https://cdn-vod-playlet.wtzw.com/asset/c0127835e4ed22e0f763b2261311b998/play_video/9087e7364cae6dfb3e2e9cd9190c3544.m3u8",
        "https://cdn-vod-playlet.wtzw.com/asset/722fc06d21b38137346b3becb69dc77a/a73bcdb561937a9814e5feffbfb94d2f.mp4",
        "https://cdn-vod-playlet.wtzw.com/asset/722fc06d21b38137346b3becb69dc77a/play_video/915013be94a102ebce7b108c934bcec4.m3u8",
        "https://getsamplefiles.com/download/mp4/sample-5.mp4",
        "https://1251542705.vod2.myqcloud.com/4a8d9c67vodtransgzp1251542705/203109c63270835013529449619/v.f1419907.mp4",
        'https://www.w3schools.com/html/movie.mp4',
        'http://1251017968.vod2.myqcloud.com/3eb04eefvodtransgzp1251017968/8782b1285285890810009576163/v.f30.mp4',
        'https://vodpub1.v.news.cn/original/20230915/e6520e0158e44a7383bd137bd42f4451.mp4'
    ]

    func build() {
        Flex(FlexParams(direction: FlexDirection.Column, alignItems: ItemAlign.Auto, justifyContent: FlexAlign.Start)) {
            Flex(
                FlexParams(direction: FlexDirection.Column, alignItems: ItemAlign.Center,
                justifyContent: FlexAlign.Center)) {
                Text("ijkplayer").fontSize(16).fontColor(Color.WHITE).fontWeight(FontWeight.Bold)
            }.height(60).width(100.percent).backgroundColor(Color.BLACK)

            Divider().vertical(false).strokeWidth(8).color(Color.WHITE).lineCap(LineCapStyle.Round)
            Stack(Alignment.Center) {
                Column {
                    XComponent("xcomponentId", "surface", "ijkplayer_napi").onLoad {=>
                        initDelayPlay()
                    }.width(100.percent)
                    .width(this.videoWidth)
                    .aspectRatio(this.videoAspectRatio)
                    .id("xcomponentId")
                }
                Image(@r(app.media.icon_replay)).objectFit(ImageFit.Auto).width(60).height(60).visibility(
                    this.replayVisible).borderStyle(BorderStyle.Dashed).onClick(
                    {
                    event => this.startPlayOrResumePlay();
                })
                Image(@r(app.media.icon_load)).objectFit(ImageFit.Auto).width(60).height(60).visibility(
                    this.loadingVisible).borderStyle(BorderStyle.Dashed)
            }.width(100.percent).backgroundColor(0x000000).clip(true)

            Flex(FlexParams(direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start)
            ) {
                Text(this.currentTime).width(80).fontSize(16).margin(10)
                Slider(
                    value: Float64(this.progressValue),
                    min: 0.0,
                    max: Float64(this.PROGRESS_MAX_VALUE),
                    step: 1.0,
                    style: SliderStyle.OutSet
                ).width(500).blockColor(Color.BLUE).trackColor(Color.GRAY).selectedColor(Color.BLUE).showSteps(true).
                    showTips(true).enabled(this.slideEnable).onChange(
                    {
                    value, mode => match (mode) {
                        case SliderChangeMode.End =>
                            this.isSeekTo = true
                            this.mDestroyPage = false
                            let seekValue = value * Float64((this.mIjkMediaPlayer.getDuration() / 100))
                            this.seekTo(seekValue.toString());
                            this.setProgress()
                            this.isSeekTo = false
                        case _ => ()
                    }
                })
                Text(this.totalTime).width(80).fontSize(16).margin(10)
            }

            Flex(FlexParams(direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start)
            ) {
                Button("播放").onClick({
                    => this.startPlayOrResumePlay()
                }).width(300).height(40).margin(10)
                Button("暂停").onClick({
                    => this.pause()
                }).width(300).height(40).margin(10)
                Button("停止").onClick({
                    => this.stop()
                }).width(300).height(40).margin(10)
            }

            Flex(FlexParams(direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start)
            ) {
                Button("1x").onClick(
                    {
                        =>
                        this.playSpeed = "1f"
                        this.mIjkMediaPlayer.setSpeed("1f");
                    }
                ).width(300).height(40).margin(10)
                Button("1.5x").onClick(
                    {
                        =>
                        this.playSpeed = "1.5f"
                        this.mIjkMediaPlayer.setSpeed("1.5f");
                    }
                ).width(300).height(40).margin(10)
                Button("2x").onClick(
                    {
                        =>
                        this.playSpeed = "2f"
                        this.mIjkMediaPlayer.setSpeed("2f");
                    }
                ).width(300).height(40).margin(10)
            }

            Flex(FlexParams(direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start)
            ) {
                Button("下一个视频").onClick({
                    => this.playNext()
                }).width(300).height(40).margin(10)
                Button("").onClick({
                    =>
                }).width(300).height(40).margin(10).visibility(Visibility.Hidden)
                Button("").onClick({
                    =>
                }).width(300).height(40).margin(10).visibility(Visibility.Hidden)
            }

            Flex(FlexParams(direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start)
            ) {
                Text("音量").width(100).fontSize(16).margin(10)
                Slider(
                    value: Float64(this.volume),
                    min: 0.0,
                    max: 1.0,
                    step: 0.1,
                    style: SliderStyle.OutSet
                ).width(500).blockColor(Color.BLUE).trackColor(Color.GRAY).selectedColor(Color.BLUE).showSteps(true).
                    showTips(true).onChange(
                    {
                    value, mode => match (mode) {
                        case SliderChangeMode.End =>
                            this.volume = Float32(value)
                            this.mIjkMediaPlayer.setVolume(this.volume.toString(), this.volume.toString())
                        case _ => ()
                    }
                })
            }
        }
    }

    private func initDelayPlay(): Unit {
        Timer.once(
            Duration.millisecond * 300,
            {
                =>
                startPlayOrResumePlay()
                this.mFirst = false
            }
        )
    }

    private func startPlayOrResumePlay(): Unit {
        this.mDestroyPage = false
        AppLog.info("startPlayOrResumePlay start this.playStatus:" + this.playStatus.toString())
        if (this.playStatus == PlayStatus.INIT) {
            this.stopProgressTask()
            this.startProgressTask()
            this.play(this.videoUrl.toString())
        }
        if (this.playStatus == PlayStatus.PAUSE) {
            this.mIjkMediaPlayer.start()
            this.setProgress()
        }
    }

    private func stringForTime(timeMs: Int64): String {
        var totalSeconds: Int64 = timeMs / 1000
        var newSeconds: Int64 = totalSeconds % 60 //秒的余数
        var minutes: Int64 = (totalSeconds / 60) % 60 //分的余数
        var hours: Int64 = totalSeconds / 3600; //小时的余数
        AppLog.info("stringForTime hours : ${hours} , minutes : ${minutes} ,seconds : ${newSeconds}")
        hours = Int64(floor(floor(Float64(hours * 100)) / 100.0))
        minutes = Int64(floor(floor(Float64(minutes * 100)) / 100.0))
        newSeconds = Int64(floor(floor(Float64(newSeconds * 100)) / 100.0))
        if (this.isCurrentTime) {
            if (this.oldSeconds < newSeconds || newSeconds == 0 || this.isSeekTo) {
                this.oldSeconds = newSeconds
            } else {
                newSeconds = this.oldSeconds
            }
        }
        var hoursStr: String = ""
        var minutesStr: String = ""
        var secondStr: String = ""
        if (hours < 10) {
            hoursStr = "0" + hours.toString()
        } else {
            hoursStr = hours.toString()
        }
        if (minutes < 10) {
            minutesStr = "0" + minutes.toString()
        } else {
            minutesStr = minutes.toString()
        }
        if (newSeconds < 10) {
            secondStr = "0" + newSeconds.toString()
        } else {
            secondStr = newSeconds.toString()
        }

        if (hours > 0) {
            return hoursStr.toString() + ":" + minutesStr.toString() + ":" + secondStr.toString()
        } else {
            return minutesStr.toString() + ":" + secondStr.toString()
        }
    }

    private func setProgress(): Unit {
        var position = Int64(this.mIjkMediaPlayer.getCurrentPosition())
        var duration = Int64(this.mIjkMediaPlayer.getDuration())
        var pos = 0
        if (duration > 0) {
            this.slideEnable = true
            var curPercent = (Float64(position)) / Float64(duration)
            pos = Int64(curPercent * 100.0)
            if (pos > this.PROGRESS_MAX_VALUE) {
                this.progressValue = this.PROGRESS_MAX_VALUE
            } else {
                this.progressValue = pos
            }
        }
        AppLog.info(
            "setProgress position:" + position.toString() + ",duration:" + duration.toString() + ",progressValue:" +
            pos.toString())
        this.totalTime = this.stringForTime(duration)
        if (position > duration) {
            position = duration
        }
        this.isCurrentTime = true
        this.currentTime = this.stringForTime(position)
        this.isCurrentTime = false
    }

    private var timer: ?Timer = None

    private func startProgressTask(): Unit {
        timer = Timer.repeat(
            Duration.millisecond * 0,
            Duration.millisecond * 300,
            {
                =>
                AppLog.info("startProgressTask")
                if (!this.mDestroyPage) {
                    setProgress()
                }
            }
        )
    }

    private func stopProgressTask(): Unit {
        AppLog.info("stopProgressTask")
        if (let Some(i) <- timer) {
            i.cancel()
        }
    }

    private func showLoadIng(): Unit {
        this.loadingVisible = Visibility.Visible
        this.replayVisible = Visibility.None
    }

    private func hideLoadIng(): Unit {
        this.loadingVisible = Visibility.None
        this.replayVisible = Visibility.None
    }

    private func showRePlay(): Unit {
        this.loadingVisible = Visibility.None
        this.replayVisible = Visibility.Visible
    }

    private func play(url: String): Unit {
        //设置XComponent回调的context
        this.mIjkMediaPlayer.setContext("xcomponentId")

        if (this.playStatus == PlayStatus.INIT) {
            this.mIjkMediaPlayer.reset()
        }
        this.playStatus = PlayStatus.PLAY
        //设置debug模式
        this.mIjkMediaPlayer.setDebug(true)
        //初始化配置
        this.mIjkMediaPlayer.native_setup();
        // 初始化配置后需要重新设置音频流音量，否则音量为默认值1.0
        this.mIjkMediaPlayer.setVolume(this.volume.toString(), this.volume.toString());
        //设置视频源
        this.mIjkMediaPlayer.setDataSource(url);
        //设置视频源http请求头
        let headers = HashMap<String, String>()
        headers.put("user_agent", "Mozilla/5.0 BiliDroid/7.30.0 (bbcallen@gmail.com)")
        headers.put("referer", "https://www.bilibili.com")

        this.mIjkMediaPlayer.setDataSourceHeader(headers);
        //使用精确寻帧 例如，拖动播放后，会寻找最近的关键帧进行播放，很有可能关键帧的位置不是拖动后的位置，而是较前的位置.可以设置这个参数来解决问题
        this.mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "enable-accurate-seek", "1");
        //预读数据的缓冲区大小
        this.mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "max-buffer-size", "102400");
        //停止预读的最小帧数
        this.mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "min-frames", "100");
        //启动预加载
        this.mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "start-on-prepared", "1");
        // 设置无缓冲，这是播放器的缓冲区，有数据就播放
        this.mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "packet-buffering", "0");
        //跳帧处理,放CPU处理较慢时，进行跳帧处理，保证播放流程，画面和声音同步
        this.mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "framedrop", "5");
        // 最大缓冲cache是3s， 有时候网络波动，会突然在短时间内收到好几秒的数据
        // 因此需要播放器丢包，才不会累积延时
        // 这个和第三个参数packet-buffering无关。
        this.mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "max_cached_duration", "3000");
        // 无限制收流
        // this.mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "infbuf", "1");
        // this.mIjkMediaPlayer.setOptionLong(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "infbuf", "1")
        // 屏幕常亮
        this.mIjkMediaPlayer.setScreenOnWhilePlaying(true,GlobalContext.getContext().getOrThrow());
        // 设置超时
        this.mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "timeout", "10000000");
        this.mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "connect_timeout", "10000000");
        this.mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "addrinfo_timeout", "10000000");
        this.mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "dns_cache_timeout", "10000000");
        // 变速播放
        this.mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "soundtouch", "1");
        this.mIjkMediaPlayer.setSpeed(this.playSpeed);
        let Speed = this.mIjkMediaPlayer.getSpeed()
        AppLog.info("getSpeed--" + Speed.toString())
        //是否开启循环播放
        this.mIjkMediaPlayer.setLoopCount(false)

        this.mIjkMediaPlayer.setOnVideoSizeChangedListener({width: Int32, height: Int32, sar_num: Int32, sar_den: Int32 =>
            if (height == 0) {
                return
            }
            let va = Float64(width) / Float64(height)
            let vpa = Float64(this.videoParentAspectRatio)
            if (vpa > va) {
                this.videoWidth = Length((Float64(width) / (Float64(height) * vpa)) * 100.0, unitType: percent)
            } else {
                this.videoWidth = Length(100, unitType:  percent)
            }
            if (width > 0 && height > 0) {
                this.videoAspectRatio = Float64(width) / Float64(height)
            }
            LogUtils.getInstance().LOGI("setOnVideoSizeChangedListener-->go:" + width.toString() + "," + height.toString() + "," + sar_num.toString() + "," + sar_den.toString())
            this.getVideoSize()
            //that.hideLoadIng()
        })

        this.mIjkMediaPlayer.setOnPreparedListener({=>
            AppLog.error("进来了setOnPreparedListener")
        })

        this.mIjkMediaPlayer.setOnTimedTextListener({ str=>
            AppLog.error("进来了setOnTimedTextListener"+ str)
        })

        this.mIjkMediaPlayer.setOnCompletionListener({=>
            AppLog.error("进来了 结束")
        })

        this.mIjkMediaPlayer.setOnSeekCompleteListener({=>
            AppLog.error("进来了 seek")
        })

        this.mIjkMediaPlayer.setOnErrorListener({ what, extra =>
            AppLog.error("进来了 error ${what} ${extra}")
        })

        this.mIjkMediaPlayer.setOnInfoListener({what, extra=>
            AppLog.error("进来了 info ${what} ${extra}")
        })


        this.mIjkMediaPlayer.setOnBufferingUpdateListener({percent =>
            AppLog.error("进来了 BufferingUpdate ${percent}")
        })

        this.mIjkMediaPlayer.setMessageListener()

        this.mIjkMediaPlayer.prepareAsync()

        this.mIjkMediaPlayer.start()
    }

    private func getVideoSize(): Unit {
        let VideoWidth = this.mIjkMediaPlayer.getVideoWidth()
        AppLog.info("getVideoWidth---" + VideoWidth.toString())
        let VideoHeight = this.mIjkMediaPlayer.getVideoHeight()
        AppLog.info("getVideoHeight---" + VideoHeight.toString())
    }

    private func pause(): Unit {
        if (this.mIjkMediaPlayer.isPlaying()) {
            this.mIjkMediaPlayer.pause()
            this.setProgress()
            this.mDestroyPage = true
            this.playStatus = PlayStatus.PAUSE
        }
    }

    private func stop(): Unit {
        this.playStatus = PlayStatus.INIT
        this.mIjkMediaPlayer.stop()
        this.mIjkMediaPlayer.release()
        this.stopProgressTask()
    }

    private func seekTo(value: String): Unit {
        this.mIjkMediaPlayer.seekTo(value)
    }

    private func playNext(): Unit {
        if (this.curIndex == this.videoUrls.size - 1) {
            this.curIndex = 0
        } else {
            this.curIndex++
        }
        this.playStatus = PlayStatus.INIT
        this.stop()
        this.videoUrl = this.videoUrls[this.curIndex]
        this.startPlayOrResumePlay()
    }
}

public func loadCJPage(): Unit {
    Hilog.info(0, "cangjiePage", "loadCJPage start")
    let elemId = ViewStackProcessor.AllocateNewElmetIdForNextComponent()
    ViewStackProcessor.StartGetAccessRecordingFor(elemId)
    CustomView.create(EntryView(Option<CustomView>.None))
    ViewStackProcessor.StopGetAccessRecording()
    return ()
}

public class PageTest <: SharedObject {
    static init() {
        JSModule.registerFunc("test_getloadCJPage", {context => context.function(test_getloadCJPage)})
        JSModule.registerFunc("test_getArkTSCallback", {context => context.function(test_getArkTSCallback)})
        JSModule.registerFunc("setContext", {context => context.function(setContext)})
    }

    public static func setContext(context: JSContext, callInfo: JSCallInfo): JSValue {
        let jsEnv = context.getNapiEnv()
        let jsValue = arkTsValuetoNapiValue(jsEnv, callInfo[0])
        if(isStageMode(jsEnv,jsValue)){
            GlobalContext.setContext(getContextStageMode(jsEnv,jsValue))
        }else{
            AppLog.error("setContext failed: not in stage mode")
        }
        return context.undefined().toJSValue()
    }

    public static func test_getloadCJPage(context: JSContext, callInfo: JSCallInfo): JSValue {
        Hilog.info(0, "cangjiePage", "test_getloadCJPage start")
        let handle = unsafe {
            loadCJPage()
        }
        return context.string("hello cangjie").toJSValue()
    }

    public static func test_getArkTSCallback(context: JSContext, callInfo: JSCallInfo): JSValue {
        Hilog.info(0, "cangjiePage", "test_getArkTSCallback start")
        let res = callInfo[0].asFunction(context).call([context.string("hello cangjie").toJSValue()])
        return res
    }
}

public enum PlayStatus <: Equatable<PlayStatus> {
    | INIT
    | PLAY
    | PAUSE
    | DONE

    public operator func !=(that: PlayStatus): Bool {
        return !(this == that)
    }

    public operator func ==(that: PlayStatus): Bool {
        return match ((this, that)) {
            case (INIT, INIT) => true
            case (PLAY, PLAY) => true
            case (PAUSE, PAUSE) => true
            case (DONE, DONE) => true
            case _ => false
        }
    }

    static func GetType(result: Int32): PlayStatus {
        match (result) {
            case 0 => return PlayStatus.INIT
            case 1 => return PlayStatus.PLAY
            case 2 => return PlayStatus.PAUSE
            case _ => return PlayStatus.DONE
        }
    }

    func toString(): String {
        match (this) {
            case INIT => "PlayStatus.INIT"
            case PLAY => "PlayStatus.PLAY"
            case PAUSE => "PlayStatus.PAUSE"
            case DONE => "PlayStatus.DONE"
        }
    }
}
