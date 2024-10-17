/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

var totalSize: Int64 = 0
var accepted: Bool = false

func TouchCallable(file: String) {
    Files.setLastModifiedNow(file)
    let last = file.lastIndexOf("/")
    let directory: String = file[0..last.getOrThrow()]
    let files = Files.getLruListFiles(directory)
    let eventStart: InnerEvent = InnerEvent(VideoCacheConstant.COUNT_TOTAL_SIZE_START_ID,
        priority: EventPriority.IMMEDIATE)
    Emitter.emit(eventStart)
    for (i in 0..files.size) {
        let singleFile = files.get(i).getOrThrow()
        let p = HashMap<String, EventDataType>()
        p.put("id", INT64(Int64(VideoCacheConstant.COUNT_TOTAL_SIZE_ID)))
        p.put("content", STRING(singleFile))
        let eventData: EventData = EventData(p)
        let event: InnerEvent = InnerEvent(VideoCacheConstant.COUNT_TOTAL_SIZE_ID, priority: EventPriority.IMMEDIATE)
        Emitter.emit(event, data: eventData)
    }
    let event: InnerEvent = InnerEvent(VideoCacheConstant.COUNT_TOTAL_SIZE_END_ID, priority: EventPriority.IMMEDIATE)
    Emitter.emit(event)
    let sendSizeEvent: InnerEvent = InnerEvent(VideoCacheConstant.SEND_TOTAL_SIZE_ID)
    Emitter.on(
        sendSizeEvent,
        EventCallback(
            "SEND_TOTAL_SIZE_ID",
            {
                data: EventData => try {
                    let dataMap: HashMap<String, EventDataType> = data.data
                    let fileEventDataType: Option<EventDataType> = dataMap.get("totalSize")

                    if (let Some(i) <- fileEventDataType) {
                        match (i) {
                            case INT64(v2) => totalSize = v2
                            case _ => ()
                        }
                    } else {
                        totalSize = 0
                    }
                } catch (e: Exception) {
                    totalSize = 0
                }
            }
        )
    )
    var totalCount = files.size
    for (i in 0..files.size) {
        let file: String = files[i]

        let p = HashMap<String, EventDataType>()
        p.put("id", INT64(Int64(VideoCacheConstant.GET_ACCEPT_ID)))
        p.put("file", STRING(file))
        p.put("totalSize", INT64(totalSize))
        p.put("totalCount", INT64(totalCount))
        let eventData: EventData = EventData(p)
        let event: InnerEvent = InnerEvent(VideoCacheConstant.GET_ACCEPT_ID, priority: EventPriority.IMMEDIATE)
        Emitter.emit(event, data: eventData)

        let acceptEvent: InnerEvent = InnerEvent(VideoCacheConstant.SEND_ACCEPT_ID)
        Emitter.on(
            acceptEvent,
            EventCallback(
                "SEND_ACCEPT_ID",
                {
                    data: EventData => try {
                        let dataMap: HashMap<String, EventDataType> = data.data
                        let fileEventDataType: Option<EventDataType> = dataMap.get("accept")

                        if (let Some(i) <- fileEventDataType) {
                            match (i) {
                                case BOOL(v3) => accepted = v3
                                case _ => ()
                            }
                        } else {
                            accepted = false
                        }
                    } catch (e: Exception) {
                        accepted = false
                    }
                }
            )
        )

        if (!accepted) {
            let fileSize = FileFs.stat(file).size
            FileFs.unlink(file)
            totalCount--
            totalSize -= fileSize
        }
    }
}

public open class LruDiskUsage <: DiskUsage {
    private var list: ArrayList<String> = ArrayList()
    private var file: String = ""
    private var totalSize: Int64 = 0
    private var totalCount: Int64 = 0

    func callbackCountTotalSizeId(data: EventData): Unit {
        let contentOpt: Option<EventDataType> = data.data.get("content")
        if (let Some(i) <- contentOpt) {
            match (i) {
                case STRING(v1) => this.list.append(v1)
                case INT64(v2) => ()
                case BOOL(v3) => ()
            }
        }
    }

    public open func accept(file: String, totalSize: Int64, totalCount: Int64): Bool {
        return false
    }

    func callbackCountTotalSizeStartId(data: EventData): Unit {
        this.list.clear()
    }

    func countTotalSize(files: ArrayList<String>): Int64 {
        var totalSize = 0
        for (i in 0..files.size) {
            let file: String = files[i]
            if (!FileFs.access(file)) {
                continue
            }
            let tempSize = FileFs.stat(file).size
            totalSize += tempSize
        }
        return totalSize
    }

    func callbackCountTotalEndEvent(data: EventData): Unit {
        let totalSize = countTotalSize(this.list)
        let p = HashMap<String, EventDataType>()
        p.put("id", INT64(Int64(VideoCacheConstant.SEND_TOTAL_SIZE_ID)))
        p.put("totalSize", INT64(totalSize))
        let endData: EventData = EventData(p)
        let endEvent: InnerEvent = InnerEvent(VideoCacheConstant.SEND_TOTAL_SIZE_ID, priority: EventPriority.IMMEDIATE)
        Emitter.emit(endEvent, data: endData)
    }

    func callbackAcceptEvent(data: EventData): Unit {
        let dataMap: HashMap<String, EventDataType> = data.data
        //赋值file
        let fileEventDataType: Option<EventDataType> = dataMap.get("file")
        if (let Some(i) <- fileEventDataType) {
            this.file = match (i) {
                case STRING(v1) => v1
                case INT64(v2) => ""
                case BOOL(v3) => ""
            }
        }
        //赋值totalSize
        let totalSizeEventDataType: Option<EventDataType> = dataMap.get("totalSize")
        if (let Some(i) <- totalSizeEventDataType) {
            this.totalSize = match (i) {
                case STRING(v1) => 0
                case INT64(v2) => v2
                case BOOL(v3) => 0
            }
        }
        //赋值totalCount
        let totalCountEventDataType: Option<EventDataType> = dataMap.get("totalCount")
        if (let Some(i) <- totalCountEventDataType) {
            this.totalCount = match (i) {
                case STRING(v1) => 0
                case INT64(v2) => v2
                case BOOL(v3) => 0
            }
        }

        let accept: Bool = accept(file, totalSize, totalCount)
        let p = HashMap<String, EventDataType>()
        p.put("id", INT64(Int64(VideoCacheConstant.SEND_ACCEPT_ID)))
        p.put("accept", BOOL(accept))
        let endData: EventData = EventData(p)
        let endEvent: InnerEvent = InnerEvent(VideoCacheConstant.SEND_ACCEPT_ID, priority: EventPriority.IMMEDIATE)
        Emitter.emit(endEvent, data: endData)
    }

    init() {
        this.list = ArrayList()
    }

    //初始化后调用下这个方法，在构造中不允许
    func initEmitter() {
        let countTotalSizeEvent: InnerEvent = InnerEvent(VideoCacheConstant.COUNT_TOTAL_SIZE_ID)
        Emitter.on(countTotalSizeEvent, EventCallback("callbackCountTotalSizeId", callbackCountTotalSizeId))
        let countTotalStratEvent: InnerEvent = InnerEvent(VideoCacheConstant.COUNT_TOTAL_SIZE_START_ID)
        Emitter.on(countTotalStratEvent, EventCallback("callbackCountTotalSizeStartId", callbackCountTotalSizeStartId))
        let countTotalEndEvent: InnerEvent = InnerEvent(VideoCacheConstant.COUNT_TOTAL_SIZE_END_ID)
        Emitter.on(countTotalEndEvent, EventCallback("callbackCountTotalEndEvent", callbackCountTotalEndEvent))
        let acceptEvent: InnerEvent = InnerEvent(VideoCacheConstant.GET_ACCEPT_ID)
        Emitter.on(acceptEvent, EventCallback("callbackAcceptEvent", callbackAcceptEvent))
    }

    func callbackShutDownTaskPool(data: EventData): Unit {
        //TODO
        //    if (task) {
        //      taskpool.cancel(task)
        //    }
        Emitter.off(VideoCacheConstant.SEND_TOTAL_SIZE_ID)
        Emitter.off(VideoCacheConstant.SEND_ACCEPT_ID)
        Emitter.off(VideoCacheConstant.COUNT_TOTAL_SIZE_ID)
        Emitter.off(VideoCacheConstant.COUNT_TOTAL_SIZE_START_ID)
        Emitter.off(VideoCacheConstant.COUNT_TOTAL_SIZE_END_ID)
        Emitter.off(VideoCacheConstant.GET_ACCEPT_ID)
        Emitter.off(VideoCacheConstant.SHUT_DOWN_TASKPOOL)
    }

    public func touch(filePath: String): Unit {
        if (filePath.size < 1 || !filePath.startsWith(StorageUtils.DEFAULT_DIR)) {
            return
        }
        //let task: taskpool.Task = new taskpool.Task(TouchCallable, filePath)
        //taskpool.execute(task, taskpool.Priority.HIGH)
        //线程里执行这个方法
        spawn {
            TouchCallable(filePath)
        }
        //TODO
        let closeTaskEvent: InnerEvent = InnerEvent(VideoCacheConstant.SHUT_DOWN_TASKPOOL)
        Emitter.on(closeTaskEvent, EventCallback("callbackShutDownTaskPool", callbackShutDownTaskPool))
    }
}
