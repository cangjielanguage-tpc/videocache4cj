
## videocache4cj

### 介绍
videoCache4cj是一个支持边播放边缓存的库，只需要将音视频的url传递给videoCache4cj处理之后再设置给播放器，videoCache4cj就可以一边下载音视频数据并保存在本地，一遍读取本地缓存返回给播放器，使用者无需进行其他操作。

### 1 videocache4cj 视频缓存库

#### 1.1 HttpProxyCacheServer 代理缓存服务类

```cangjie
public class HttpProxyCacheServer {
    
    /**
     * 获取服务端代理url
     * 
     * @参数 url - String数据类型，原视频的url
     * @参数 allowCachedFileUri - Bool数据类型，这个指的是缓存结束后是不是直接用本地的缓存还是继续通过网络去读取，
            如果是true，表示从本地缓存读取视频数据，如果fasle表示继续从网络读取数据
     * @返回值 Future<String> 服务端代理url地址
     */
    public func getProxyUrl(url: String, allowCachedFileUri: Bool): Future<String>
    
    
    /**
     * 关闭代理服务器
     * 
     */
    public func shutdown(): Unit
    
    
    /**
     * 注册缓存监听
     *
     * @参数 cacheListener - CacheListener数据类型，缓存监听
     * @参数 url - String数据类型，下载的视频url
     */
    public func registerCacheListener(cacheListener: CacheListener, url: String): Unit 

    
    /**
     * 取消注册缓存监听
     *
     * @参数 cacheListener - CacheListener数据类型，缓存监听
     * @参数 url - String数据类型，下载的视频url
     */
    public func unregisterCacheListener(cacheListener: CacheListener, url: String): Unit

}
```

#### 1.2 HttpProxyCacheServerBuilder 代理缓存服务构建类

```cangjie
public class HttpProxyCacheServerBuilder {
    
    /**
     * 生成代理缓存服务类对象
     * 
     * @返回值 HttpProxyCacheServer 代理缓存服务类对象
     */
    public func build(): HttpProxyCacheServer 
    
    
    /**
     * 设置缓存目录
     * 
     * @参数 file - String缓存文件的目录
     * @返回值 HttpProxyCacheServerBuilder 代理缓存服务类构建对象
     */
    public func cacheDirectory(file: String): HttpProxyCacheServerBuilder
    
    
    /**
     * 设置文件名生成规则
     * 
     * @参数 fileNameGenerator - FileNameGenerator文件名生成规则类
     * @返回值 HttpProxyCacheServerBuilder 代理缓存服务类构建对象
     */
    public func setFileNameGenerator(fileNameGenerator: FileNameGenerator): HttpProxyCacheServerBuilder


    /**
     * 设置缓存目录下允许的最大大小，即所有缓存文件之和最大为多少
     * 
     * @参数 maxSize - Int64最大缓存大小 单位字节
     * @返回值 HttpProxyCacheServerBuilder 代理缓存服务类构建对象
     */
    public func maxCacheSize(maxSize: UInt64): HttpProxyCacheServerBuilder

    
    /**
     * 设置最大可添加缓存文件个数
     * 
     * @参数 count - 缓存文件的数量
     * @返回值 HttpProxyCacheServerBuilder 代理缓存服务类构建对象
     */
    public func maxCacheFilesCount(count: UInt64): HttpProxyCacheServerBuilder


    /**
     * 设置自定义缓存清理策略,只有缓存在程序默认位置时候才会触发清理策略
     * 
     * @参数 diskUsage - DiskUsage 自定义缓存策略
     * @返回值 HttpProxyCacheServerBuilder 代理缓存服务类构建对象
     */
    public func setDiskUsage(diskUsage: DiskUsage): HttpProxyCacheServerBuilder
    
    
     /**
     * 设置自定义请求头
     * 
     * @参数 headerInjector - HeaderInjector 自定义请求头
     * @返回值 HttpProxyCacheServerBuilder 代理缓存服务类构建对象
     */
    public func setHeaderInjector(headerInjector: HeaderInjector): HttpProxyCacheServerBuilder

}
```
#### 1.3 DiskUsage 自定义缓存清理策略类

```cangjie
public interface DiskUsage {    
    /**
     * 缓存清理方法
     * 
     * @参数 filePath - String 缓存文件路径
     */
    func touch(filePath: String): Unit
    
}
```


#### 1.4 HeaderInjector 自定义添加请求头类

```cangjie
public interface HeaderInjector {
    /**
     * 自定义添加请求头方法
     * 
     * @参数 url - String 请求的url网络地址
     * @返回值 HashMap<String, String> 自定义添加的请求头
     */
    func addHeaders(url: String): HashMap<String, String>
    
}
```

#### 1.5 FileNameGenerator 自定义缓存文件名字生成类

```cangjie
public interface FileNameGenerator {
    /**
     * 自定义缓存文件名字生成方法
     * 
     * @参数 url - String 请求的url视频网络地址
     * @返回值 String 生成的缓存文件的名字
     */
    func generate(url: String): String
    
}
```

#### 1.6 CacheListener 缓存下载进度监听类

```cangjie
public interface CacheListener {
    /**
     * 缓存下载进度监听方法
     * 
     * @参数 cacheFilePath - String 缓存文件的路径
     * @参数 url - String 视频的url地址
     * @参数 percentsAvailable - Int64 视频的下载进度百分比
     */
    func onCacheAvailable(cacheFilePath: String, url: String, percentsAvailable: Int64): Unit
    
}
```