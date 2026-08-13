import UIKit
import FMDB


@objcMembers class DDDataBaseManager: NSObject {
    
    static let shared = DDDataBaseManager()
    private let databaseFileName = "database.sqlite"
    private var databasePath: String!
    private var database: FMDatabase!
    
    private override init() {
        super.init()
        
        // 获取应用程序的文档目录路径
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        databasePath = documentsDirectory.appendingPathComponent(databaseFileName).path
        createDatabaseIfNeeded()
        
    }
    
    private func createDatabaseIfNeeded() {
        // 如果数据库文件不存在，则创建数据库
        if !FileManager.default.fileExists(atPath: databasePath) {
            database = FMDatabase(path: databasePath)
            if database != nil {
                if database.open() {
                    
                    // 创建表格和设置表格结构
                    let secretAlbumQuery = "CREATE TABLE IF NOT EXISTS secretAlbum (id integer primary key autoincrement, image blob)"

                    do {
                        
                        try database.executeUpdate(secretAlbumQuery, values: nil)


                    } catch {
                    }
                    database.close()
                } else {
                }
            }
        }
    }
    
    func saveSecretAlbum(model: DDSecretAlbumModel) -> Bool {
        
        database = FMDatabase(path: databasePath)
        if database != nil {
            if database.open() {
                let insertQuery = "INSERT INTO secretAlbum(image) VALUES (?)"
                do {
                    let data = model.image?.pngData()
                    
                    try database.executeUpdate(insertQuery, values: [data ?? Data()])
                    database.close()
                    return true
                } catch {
                }
            } else {
            }
        }
        return false
    }
    
    
    func getSecretAlbumList() -> [DDSecretAlbumModel] {
        var secretAlbumList: [DDSecretAlbumModel] = []
        database = FMDatabase(path: databasePath)
        if database != nil {
            if database.open() {
                let selectQuery = "SELECT * FROM secretAlbum"
                do {
                    let resultSet = try database.executeQuery(selectQuery, values: nil)
                    while resultSet.next() {
                        let model = DDSecretAlbumModel()
                        
                        model.id = resultSet.string(forColumn: "id") ?? ""
                        let imgData = resultSet.data(forColumn: "image") ?? Data()
                        model.image = UIImage(data: imgData)
                        
                        
                        secretAlbumList.append(model)
                        
                    }
                    resultSet.close()
                } catch {
                }
                database.close()
            } else {
            }
        }
        return secretAlbumList
    }
    
    
    
    
    func deleteSecretAlbumList(model: DDSecretAlbumModel) -> Bool {
        database = FMDatabase(path: databasePath)
        if database != nil {
            if database.open() {
                let deleteQuery = "DELETE FROM secretAlbum WHERE id = ?"
                do {
                    try database.executeUpdate(deleteQuery, values: [model.id ?? ""])
                    database.close()
                    return true
                } catch {
                }
            } else {
            }
        }
        return false
    }
}


class DDSecretAlbumModel: Equatable {
    static func == (lhs: DDSecretAlbumModel, rhs: DDSecretAlbumModel) -> Bool {
        return lhs.id == rhs.id && lhs.image == rhs.image
    }
    
    var id: String?
    var image: UIImage?
    
}


