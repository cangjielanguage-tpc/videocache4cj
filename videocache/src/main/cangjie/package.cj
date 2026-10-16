/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package videocache

internal import ohos.ability.*
internal import ohos.file_fs.*
internal import ohos.base.*
internal import ohos.emitter.*
internal import ohos.relational_store.*
internal import ohos.net.http.HttpRequest
internal import ohos.net.http.HttpRequestOptions
internal import ohos.net.http.DataReceiveProgressInfo
internal import ohos.net.http.createHttp
internal import ohos.net.http.RequestMethod
internal import ohos.net.http.HttpProtocol
internal import ohos.net.connection.*
internal import std.random.*
internal import std.regex.*
internal import std.convert.*
internal import std.io.*
internal import std.math.*
internal import std.sync.*
internal import std.collection.concurrent.*
internal import std.crypto.digest.*
internal import std.time.*
internal import std.collection.*
internal import ohos.hilog.*
internal import ohos.ark_interop_helper.*
internal import ohos.system_date_time.SystemDateTime

internal import std.net.*
internal import stdx.net.http.HttpRequest as stdHttpRequest
internal import stdx.net.http.Client
internal import stdx.net.http.HttpHeaders
internal import stdx.net.http.HttpRequestBuilder
internal import stdx.net.http.ClientBuilder
internal import stdx.net.http.Protocol
internal import stdx.net.tls.TlsClientConfig
internal import stdx.crypto.digest.*
internal import stdx.encoding.hex.*