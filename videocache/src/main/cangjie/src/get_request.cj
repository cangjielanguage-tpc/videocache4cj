/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public class GetRequest {
    private let RANGE_HEADER_PATTERN: Regex = Regex("[R,r]ange:[ ]?bytes=(\\d*)-")
    private let URL_PATTERN: Regex = Regex("GET /(.*) HTTP")
    public var uri: String = ""
    public var rangeOffset: Int64 = 0
    public var partial: Bool = false

    init(request: String) {
        if (request.size < 1) {
            throw NoneValueException("request can not be empty")
        }
        let offset = findRangeOffset(request)
        this.rangeOffset = max(0, offset)
        this.partial = offset >= 0
        this.uri = findUri(request)
    }

    static func read(stringRequest: Array<UInt8>): GetRequest {
        return GetRequest(String.fromUtf8(stringRequest))
    }

    private func findRangeOffset(request: String): Int64 {
        try {
            let matcher: Option<Array<MatchData>> = this.RANGE_HEADER_PATTERN.matcher(request).findAll()
            if(let Some(i) <- matcher){
                if(i.size<1){
                    return -1
                }
                //"Range: bytes=10-"
                let rangeValue = i[0].matchStr()
                return Int64.parse(rangeValue.split("=")[1].split("-")[0])
            }else{
                return -1
            }
        } catch (e: Exception) {
        }
        return -1
    }

    private func findUri(request: String): String {
        let matcher: Option<Array<MatchData>> = this.URL_PATTERN.matcher(request).findAll()
        if(let Some(i) <- matcher){
            if(i.size<1 || (i[0].matchStr().size<1)){
                 throw IllegalArgumentException("Invalid request `")
            }
            return i[0].matchStr()[5..i[0].matchStr().size-5] //TODO 删前删后
        }else{
           throw IllegalArgumentException("Invalid request `" + request + "`: url not found!")
        }
    }

    func toString(): String {
        return "GetRequest{" + "rangeOffset=" + this.rangeOffset.toString() + ", partial=" + this.partial.toString() +
            ", uri='" + this.uri + '\'' + '}'
    }
}
