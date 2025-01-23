/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package videocache

public class DatabaseSourceInfoStorage <: SourceInfoStorage {
    private let DB_NAME: String = "VideoCache.db"
    private let TABLE: String = "SourceInfo"
    private let COLUMN_ID: String = "ID"
    private let COLUMN_URL: String = "URL"
    private let COLUMN_LENGTH: String = "LENGTH"
    private let COLUMN_MIME: String = "MIME"
    private let ALL_COLUMNS: Array<String> = [this.COLUMN_ID, this.COLUMN_URL, this.COLUMN_LENGTH, this.COLUMN_MIME]
    private let CREATE_SQL: String = "CREATE TABLE " + this.TABLE + " (" + this.COLUMN_ID +
        " INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL," + this.COLUMN_URL + " TEXT NOT NULL," + this.COLUMN_MIME +
        " TEXT," + this.COLUMN_LENGTH + " INTEGER" + ");"
    private var store: ?RdbStore = None

    init(context: StageContext) {
        let STORE_CONFIG: StoreConfig = StoreConfig(this.DB_NAME, SecurityLevel.S1)
        var rdbStore: RdbStore = getRdbStore(context, STORE_CONFIG)
        this.store = rdbStore
        createTable()
    }

    private func createTable() {
        if (let Some(i) <- store) {
            try {
                i.executeSql(this.CREATE_SQL)
            } catch (e: Exception) {
                AppLog.error("message ${e.message}")
            }
        }
    }

    func onCreate(): Unit {
        this.createTable()
    }

    func onUpgrade(): Unit {
        throw IllegalStateException("Should not be called. There is no any migration")
    }

    public override func release(): Unit {
        // close(); 关闭数据库
    }

    public override func put(url: String, sourceInfo: SourceInfo): Unit {
        let storeTemp = this.store.getOrThrow {=> NoneValueException("store is not create")}
        try {
            let sourceInfoFromDb = get(url)
            let exist = sourceInfoFromDb.isSome()
            let contentValues = convert(sourceInfo)
            if (exist) {
                let predicates = RdbPredicates(this.TABLE)
                predicates.equalTo(this.COLUMN_URL, ValueType.string(url))
                storeTemp.update(contentValues, predicates)
            } else {
                storeTemp.insert(this.TABLE, contentValues)
            }
            return
        } catch (e: Exception) {
            throw e
        }
    }

    public override func get(url: String): ?SourceInfo {
        let storeTemp = this.store.getOrThrow {=> NoneValueException("store is null")}
        var resultSet: ?ResultSet = None
        try {
            let predicates = RdbPredicates(this.TABLE)
            predicates.equalTo(this.COLUMN_URL, ValueType.string(url))
            resultSet = storeTemp.query(predicates, this.ALL_COLUMNS)
            if (resultSet.isNone()) {
                return None
            }
            var resultSetNotNone = resultSet.getOrThrow()
            let isExit = resultSetNotNone.goToFirstRow()
            if (!isExit) {
                return None
            }
            let columnUrl = resultSetNotNone.getString(resultSetNotNone.getColumnIndex(this.COLUMN_URL))
            let length = resultSetNotNone.getLong(resultSetNotNone.getColumnIndex(this.COLUMN_LENGTH))
            let mime = resultSetNotNone.getString(resultSetNotNone.getColumnIndex(this.COLUMN_MIME))
            let info = SourceInfo(columnUrl, length, mime)
            return info
        } catch (e: Exception) {
            throw e
        } finally {
            if (resultSet.isSome()) {
                resultSet.getOrThrow().close()
            }
        }
    }

    private func convert(sourceInfo: SourceInfo): Map<String, ValueType> {
        let values: HashMap<String, ValueType> = HashMap<String, ValueType>()
        values.put("URL", ValueType.string(sourceInfo.url))
        values.put("LENGTH", ValueType.integer(sourceInfo.length))
        values.put("MIME", ValueType.string(sourceInfo.mime))
        return values
    }
}
