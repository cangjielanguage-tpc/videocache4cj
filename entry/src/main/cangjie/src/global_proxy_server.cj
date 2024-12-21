/**
 * Created on 2024/11/15
 */
package ohos_app_cangjie_entry

public class GlobalProxyServer {
    private let CONTEXT_STR: String = "getContext"
    private let SERVER_STR: String = "getServer"
    private static var instance: ?GlobalProxyServer = None
    private var _objects: HashMap<String, Object> = HashMap<String, Object>()

    private init() {
    }

    public static func getInstance(): GlobalProxyServer {
        if (GlobalProxyServer.instance.isNone()) {
            GlobalProxyServer.instance = GlobalProxyServer()
        }
        return GlobalProxyServer.instance.getOrThrow()
    }

    func getContext(): ?AbilityContext {
        return this._objects.get(this.CONTEXT_STR).getOrThrow() as AbilityContext
    }

    func setContext(context: AbilityContext) {
        this._objects.put(this.CONTEXT_STR, context)
    }

    func getServer(): HttpProxyCacheServer {
        return (this._objects.get(this.SERVER_STR).getOrThrow() as HttpProxyCacheServer).getOrThrow()
    }

    func setServer(server: HttpProxyCacheServer) {
        try {
            let currentServer: HttpProxyCacheServer = this.getServer()
            currentServer.shutdown()
        } catch (e: Exception) {
        }
        this._objects.put(this.SERVER_STR, server)
    }
}
