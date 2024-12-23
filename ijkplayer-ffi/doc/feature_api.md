
## ijkplayer4cj 包

### IjkMediaPlayer类 
```cangjie
/*
 * 类名 - IjkMediaPlayer
 * 功能 - ijk媒体播放器
 */
public class IjkMediaPlayer  {

    public static let OPT_CATEGORY_FORMAT: String = "1"

    public static let OPT_CATEGORY_CODEC: String = "2"

    public static let OPT_CATEGORY_SWS: String = "3"

    public static let OPT_CATEGORY_PLAYER: String = "4"
    
    /*
     * 构造函数 获取 IjkMediaPlayer 实例
     * 参数 id - xcomponennt的值
     */
    public init  (id: String)

    /*
     * 功能 - 单例, 获取IjkMediaPlayer 实例
     * 
     * 返回值 IjkMediaPlayer - 单例IjkMediaPlayer 实例
     */
    public static func getInstance () : IjkMediaPlayer

    /*
     * 功能 - 设置 XComponent 回调的 context
     *
     * 参数 id - 组件 id 值
     * 参数 context - XComponent 回调的 context
     */
    public func setContext (id: String) : Unit

    /*
     * 功能 - 设置 debug 模式
     *
     * 参数 open - 是否打开 debug 模式,默认为false,不是debug模式
     */
    public func setDebug (open: Bool) : Unit

    /*
     * 功能 - 设置视频源
     *
     * 参数 url - 视频地址
     * 返回值 Unit - Unit
     */
    public func setDataSource (url: String) : Unit

    /*
     * 功能 - 设置视频源 http 请求头
     *
     * 参数 headers - 请求头
     * 返回值 Unit - Unit
     */
    public func setDataSourceHeader (headers: HashMap < String, String >) : Unit

    /*
     * 功能 - 设置视频播放参数
     * 
     * 参数 category - OPT_CATEGORY_FORMAT、OPT_CATEGORY_CODEC、OPT_CATEGORY_SWS、OPT_CATEGORY_PLAYER
     * 参数 key - 比如 "max-buffer-size"(预读数据的缓冲区大小的key) , 比如 "min-frames"(停止预读的最小帧数的key)
     * 参数 value - 比如 "102400"(预读数据的缓冲区大小的value) , 比如 "100"(停止预读的最小帧数的value)
     * 返回值 Unit - 
     */
    public func setOption (category: String, key: String, value: String) : Unit
    
    /*
     * 功能 - 设置视频播放参数
     * 
     * 参数 category - OPT_CATEGORY_FORMAT、OPT_CATEGORY_CODEC、OPT_CATEGORY_SWS、OPT_CATEGORY_PLAYER
     * 参数 key - 比如 "max-buffer-size"(预读数据的缓冲区大小的key) , 比如 "min-frames"(停止预读的最小帧数的key)
     * 参数 value - 比如 "102400"(预读数据的缓冲区大小的value) , 比如 "100"(停止预读的最小帧数的value)
     * 返回值 Unit - 
     */
    public func setOptionLong(category: String, key: String, value: String): Unit

    /*
     * 功能 - 播放前异步准备
     * 
     * 返回值 Unit - Unit
     */
    public func prepareAsync () : Unit

    /*
     * 功能 - 开始播放
     * 
     * 返回值 Unit - Unit
     */
    public func start () : Unit

    /*
     * 功能 - 停止
     * 
     * 返回值 Unit - 
     */
    public func stop () : Unit

    /*
     * 功能 - 暂停
     * 
     * 返回值 Unit - 
     */
    public func pause () : Unit

    /*
     * 功能 - 重置
     * 
     * 返回值 Unit - 
     */
    public func reset () : Unit

    /*
     * 功能 - 释放
     * 
     * 返回值 Unit - 
     */
    public func release () : Unit

    /*
     * 功能 - 跳到指定时间节点的视频处
     * 
     * 参数 msec - 视频时间节点，范围（"0" ~ "getDuration()"）
     * 返回值 Unit - 
     */
    public func seekTo (msec: String) : Unit

    /*
     * 功能 - 倍数播放
     * 
     * 参数 speed - 倍数 常规参数（"0.25"、"0.5"、"0.75"、"1"、"1.5"、"2"、"4"）数字后面加f也可，比如0.5f
     * 返回值 Unit - 
     */
    public func setSpeed (speed: String) : Unit

    /*
     * 功能 - 获取倍数
     * 
     * 返回值 Float32 - 倍数
     */
    public func getSpeed () : Float32

    /*
     * 功能 - 判断是否是播放状态
     * 
     * 返回值 Bool - 是否播放的状态
     */
    public func isPlaying () : Bool

    /*
     * 功能 - 获取 video 的宽
     * 
     * 返回值 Int64 - 宽
     */
    public func getVideoWidth () : Int64

    /*
     * 功能 - 获取 video 的高
     * 
     * 返回值 Int64 - 高
     */
    public func getVideoHeight () : Int64
    
     /*
     * 功能 - 获取视频宽高比的分子
     * 
     * 返回值 Int64 - 视频宽高比的分子
     */
    public func getVideoSarNum () : Int64

    /*
     * 功能 - 获取视频宽高比的分母
     * 
     * 返回值 Int64 - 视频宽高比的分母
     */
    public func getVideoSarDen () : Int64

    /*
     * 功能 - 获取视频总时长
     * 
     * 返回值 Int32 - 总时长
     */
    public func getDuration () : Int32

    /*
     * 功能 - 获取视频播放当前位置
     * 
     * 返回值 Int32 - 视频播放当前位置
     */
    public func getCurrentPosition () : Int32
    
     /*
     * 功能 - 获取音频sessionID
     * 
     * 返回值 Int32 - 音频sessionID
     */
    public func getAudioSessionId(): Int32

    /*
     * 功能 - 设置音量
     * 
     * 参数 leftVolume - 左声道音量（"0" ~ "1"）正常可按0.1幅度增长
     * 参数 rightVolume - 右声道音量（"0" ~ "1"）正常可按0.1幅度增长
     * 返回值 Unit - 
     */
    public func setVolume (leftVolume: String, rightVolume: String) : Unit

    /*
     * 功能 - 设置循环播放
     * 
     * 参数 looping - 否循环播放,true循环播放，false不循环播放
     * 返回值 Unit - 
     */
    public func setLoopCount (looping: Bool) : Unit
    
    /*
     * 功能 - 查看当前是否循环播放
     * 
     * 返回值 Bool - 是否循环播放,true是循环播放，false不是循环播放
     */
    public func isLooping(): Bool
    
    /*
     * 功能 - 选择轨道
     * 
     * 参数 track - 轨道
     * 返回值 Unit - 
     */
    func selectTrack(track: String): Unit
    
    /*
     * 功能 - 删除选择轨道
     * 
     * 参数 track - 选择的轨道
     * 返回值 Unit - 
     */
    func deselectTrack(track: String): Unit
    
    /*
     * 功能 - 获取媒体信息
     * 
     * 返回值 MediaInfoType - 媒体信息
     */
    func getMediaInfo(): MediaInfoType {
    
    /*
     * 功能 - c侧底层初始化配置
     * 
     * 返回值 Unit - unit 
     */
    public func native_setup () : Unit
    
    /*
     * 功能 - 设置屏幕常亮
     * 
     * 参数 on - 屏幕是否常亮,true屏幕常亮，false屏幕不常亮
     * 参数 context - 上下文对象
     * 返回值 Unit 
     */
    public func setScreenOnWhilePlaying(on: Bool, context: StageContext): Unit
        
    /*
     * 功能 - 设置获取视频宽高回调监听
     * 
     * 参数 listener - 是一个参数为视频宽度尺寸 视频高度尺寸 视频sar_num 视频sar_den 返回值为Unit的监听方法
     * 返回值 Unit 
     */
    public func setOnVideoSizeChangedListener(listener: (width: Int32, height: Int32, sar_num: Int32, sar_den: Int32)-> Unit): Unit 
    
    /*
     * 功能 - 设置视频准备就绪回调监听
     * 
     * 参数 listener - 是一个无参 返回值为Unit的监听方法
     * 返回值 Unit 
     */
    public func setOnPreparedListener(listener: ()-> Unit): Unit 
    
    /*
     * 功能 - 设置播放器的各种状态回调监听
     * 
     * 参数 listener - 是一个参数为what状态序号,extra额外携带参数 返回值为unit的监听方法
     * 返回值 Unit 
     */
    public func setOnInfoListener(listener: (what: Int64, extra: Int64) -> Unit): Unit

    /*
     * 功能 - 设置buffer缓冲回调监听
     * 
     * 参数 listener - 是一个参数为percent缓冲百分比 返回值为unit的监听方法
     * 返回值 Unit 
     */
    public func setOnBufferingUpdateListener(listener: (percent: Int32) -> Unit): Unit
    
    /*
     * 功能 - 设置播放异常回调监听
     * 
     * 参数 listener - 是一个参数为what错误状态序号,extra额外携带参数 返回值为unit的监听方法
     * 返回值 Unit 
     */
    public func setOnErrorListener(listener: (what: Int64, extra: Int64) -> Unit): Unit
    
     /*
     * 功能 - 设置快进后退回调监听
     * 
     * 参数 listener - 是一个无参 返回值为Unit的监听方法
     * 返回值 Unit 
     */
    public func setOnSeekCompleteListener(listener: () -> Unit): Unit
    
    /*
     * 功能 - 设置播放结束后的回调监听
     * 
     * 参数 listener - 是一个无参 返回值为Unit的监听方法
     * 返回值 Unit 
     */
    public func setOnCompletionListener(listener: ()-> Unit): Unit
        
    /*
     * 功能 - 设置视频监听器
     * 
     * 返回值 Unit 
     */
    public func setMessageListener(): Unit
    
}

```



