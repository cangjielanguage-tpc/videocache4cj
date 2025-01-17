/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache



func pingCallable(pingUrl: String) {
    var pingResult: Bool = false
    let source = HttpUrlSource(pingUrl)
    try {
        let expectedResponse = VideoCacheConstant.PING_RESPONSE
        source.setDataListener(TempPingDataBackListener(pingResult))
        source.open2()
    } catch (e: Exception) {
        AppLog.error("Error reading ping response,reason is " + e.message)
        pingResult = false
    } finally {
        source.close()
    }
}

public class Pinger {
    private var host: String
    private var port: UInt16

    init(host: String, port: UInt16) {
        this.host = host
        this.port = port
    }

    //要在lambda表达式里面赋值
    var pingData: Bool = false

    func ping(maxAttempts: Int64, startTimeout: Int64): Bool {
        if (maxAttempts < 1) {
            throw IllegalArgumentException("Illegal Argument")
        }

        if (startTimeout <= 0) {
            throw IllegalArgumentException("Illegal Argument")
        }
        var timeout = startTimeout
        var attempts = 0
        while (attempts < maxAttempts) {
            try {
                let syncCount = SyncCounter(1)
                let event: InnerEvent = InnerEvent(VideoCacheConstant.PING_EVENT_ID)

                var eventTemp: (EventData) -> Unit = {
                    data: EventData =>
                    let dataMap: HashMap<String, EventDataType> = data.data
                    let fileEventDataType: Option<EventDataType> = dataMap.get("content")
                    if (let Some(i) <- fileEventDataType) {
                        match (i) {
                            case BOOL(v3) => pingData = v3
                            case _ => ()
                        }
                    } else {
                        pingData = false
                    }
                    Emitter.off(VideoCacheConstant.PING_EVENT_ID)
                    syncCount.dec()
                }
                Emitter.on(event, EventCallback("PING_EVENT_ID", eventTemp))
                let url = getPingUrl()
                spawn {
                    pingCallable(url)
                }
                let closeTaskEvent: InnerEvent = InnerEvent(VideoCacheConstant.SHUT_DOWN_TASKPOOL)
                Emitter.on(
                    closeTaskEvent,
                    EventCallback(
                        "SHUT_DOWN_TASKPOOL",
                        {
                            data: EventData => try {
                                Emitter.off(VideoCacheConstant.PING_EVENT_ID)
                                Emitter.off(VideoCacheConstant.SHUT_DOWN_TASKPOOL)
                            } catch (e: Exception) {
                            }
                        }
                    )
                )
                syncCount.waitUntilZero(timeout: Duration.second * 6)
                //到上面为止停止
                if (pingData) {
                    break
                }
            } catch (e: Exception) {
                AppLog.warn(
                    "Error pinging server (attempt: " + attempts.toString() + ", timeout: " + timeout.toString() + "). "
                )
                AppLog.error("Error pinging server due to unexpected error,reason is " + e.message)
            }
            attempts++
            timeout *= 2
        }
        if (pingData) {
            return pingData
        } else {
            let proxy = getDefaultProxies()
            let error = "Error pinging server (attempts: ${attempts}, max timeout: ${timeout / 2})"
            AppLog.error(error + ProxyCacheException(error).toString())
            return false
        }
    }

    func isPingRequest(request: String): Bool {
        return VideoCacheConstant.PING_REQUEST == request
    }

    func responseToPing(socket: TcpSocket): Unit {
        socket.write("HTTP/1.1 200 OK\n\n".toArray())
        socket.write(VideoCacheConstant.PING_RESPONSE.toArray())
        return
    }

    private func getDefaultProxies(): HttpProxy {
        try {
            let result = getDefaultHttpProxy()
            return result
        } catch (e: Exception) {
            throw ProxyCacheException(e.message)
        }
    }

    private func getPingUrl(): String {
        return "http://${this.host}:${this.port}/${VideoCacheConstant.PING_REQUEST}"
    }
}
