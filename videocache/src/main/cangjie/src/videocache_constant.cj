/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public class VideoCacheConstant {
    public static var PING_EVENT_ID: UInt32 = 1 // 发出事件---ping代理服务器成功传递响应结果
    public static var COUNT_TOTAL_SIZE_ID: UInt32 = 2 // 发出事件---子线程解析出文件夹里面的所有文件之后发给LruDiskUsage
    public static var COUNT_TOTAL_SIZE_START_ID: UInt32 = 3 // 发出事件---文件夹数据发送完毕之前，发出信号调用先清空之前缓存到列表的文件名
    public static var COUNT_TOTAL_SIZE_END_ID: UInt32 = 4 // 发出事件---文件夹数据发送完毕之后，发出信号调用LruDiskUsage的方法countTotalSize
    public static var SEND_TOTAL_SIZE_ID: UInt32 = 5 // 发出事件---用于接受主线程处理好的TotalSize
    public static var GET_ACCEPT_ID: UInt32 = 6 // 发出事件---向主线程询问该缓存文件是否需要删除
    public static var SEND_ACCEPT_ID: UInt32 = 7 // 发出事件---向子线程返回缓存文件是否需要删除的结论
    public static var SHUT_DOWN_TASKPOOL: UInt32 = 8 // 发出事件---关闭子线程
    public static var HTTP_URL_SOURCE_READY_ID: UInt32 = 10 // 发出事件---HttpUrlSource初始化成功，可以发起网络请求(初始化是异步的 所以必须等待初始化结束才可以进行下一步)
    public static var SERVER_READY_ID: UInt32 = 11 // 发出事件---代理服务器初始化成功，可以发起ping请求和获取处理之后的音视频url(初始化是异步的 所以必须等待初始化结束才可以进行下一步)
    public static var RENAME_FINISH_ID: UInt32 = 12 // 发出事件---文件重命名结束，可以进行后续的操作了(防止重命名未结束直接关闭文件导致的数据异常)
    public static var PING_RESPONSE: String = "ping ok" // 本地构造的用于本地代理服务器返回给播放器发起的ping请求的响应结果
    public static var PING_REQUEST: String = "ping" // 发出事件---用于构造播放器发起的ping请求

    init() {
    }
}
