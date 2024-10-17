/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public class TempPingDataBackListener <: DataBackListener {
    let expectedResponse = VideoCacheConstant.PING_RESPONSE
    var pingResult: Bool

    init(pingResult: Bool) {
        this.pingResult = pingResult
    }

    public override func onDataEnd() {
    }

    public override func onDataStart() {
    }

    public override func onDataReceive(data: ByteArrayStream) {
        if (data.bytes().size > 0) {
            let response: String = data.readString()
            AppLog.info("Ping response: `" + response + "`, pinged? " + pingResult.toString())
            pingResult = expectedResponse == response
            let p = HashMap<String, EventDataType>()
            p.put("content", BOOL(pingResult))
            p.put("id", INT64(Int64(VideoCacheConstant.PING_EVENT_ID)))
            let eventData: EventData = EventData(p)
            let event: InnerEvent = InnerEvent(VideoCacheConstant.PING_EVENT_ID, priority: EventPriority.IMMEDIATE)
            Emitter.emit(event, data: eventData)
        }
    }

    public override func onDataProgress(progress: DataReceiveProgressInfo) {
    }
}
