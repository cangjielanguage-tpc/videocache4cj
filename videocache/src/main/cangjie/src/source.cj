/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public interface Source {
    /**
     * Opens source. Source should be open before using
     *
     * @param offset offset in bytes for source.
     * @throws ProxyCacheException if error occur while opening source.
     */
    func setDataListener(listener: DataBackListener): Unit

    /**
     * Opens source. Source should be open before using
     *
     * @param offset offset in bytes for source.
     * @throws ProxyCacheException if error occur while opening source.
     */
    func open(offset: Int64): Unit

    /**
     * Returns length bytes or <b>negative value</b> if length is unknown.
     *
     * @return bytes length
     * @throws ProxyCacheException if error occur while fetching source data.
     */
    func length(): Int64

    // /**
    //  * Read data to byte buffer from source with current offset.
    //  *
    //  * @param buffer a buffer to be used for reading data.
    //  * @return a count of read bytes
    //  * @throws ProxyCacheException if error occur while reading source.
    //  */
    // read(buffer: ArrayBuffer): number

    /**
     * Closes source and release resources. Every opened source should be closed.
     *
     * @throws ProxyCacheException if error occur while closing source.
     */
    func close(): Unit
}
