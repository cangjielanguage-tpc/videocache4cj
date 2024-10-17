/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public class MessageCallBackBean {
    public var message: ?Array<UInt8> = None
    //TCP还是UDP
    //public var remoteInfo //socket库没提供
    public var address: String = "" //本地绑定的ip地址。
    public var family: Int64 = 0 //网络协议类型，可选类型：- IPv4 - IPv6 默认为IPv4。
    public var port: UInt16 = 0 //端口号，范围0~65535。
    public var size: Int64 = 0 //服务器响应信息的字节长度。

    init() {
    }
}
