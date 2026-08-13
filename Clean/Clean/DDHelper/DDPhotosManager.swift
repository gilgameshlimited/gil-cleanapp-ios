import Foundation
import Photos
import CoreImage

class DDPhotosManager: NSObject {
    
    static let shared = DDPhotosManager()
    
    func requestPhotoLibraryAccess(completion: ((_ isAuthorized: Bool) -> Void)?) {
        // 检查当前的权限状态
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            // 用户已授权访问相册
            if let completion = completion {
                
                DispatchQueue.main.async {
                    completion(true)
                }
                
            }
        case .notDetermined:
            // 请求访问权限
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized {
                    if let completion = completion {
                        DispatchQueue.main.async {
                            
                            completion(true)
                            
                        }
                    }
                } else {
                    // 用户拒绝访问相册
                    if let completion = completion {
                        DispatchQueue.main.async {
                            
                            completion(false)
                            
                        }
                    }
                }
            }
        default:
            

            if let completion = completion {
                
                DispatchQueue.main.async {
                    
                    completion(false)
                    
                }
            }
            // 其他状态：如拒绝访问、限制访问等
        }
        
    }
    
    func getImagePHAssetsTotalFileSize(assets: [PHAsset], convertUnits: Bool = true, completion: @escaping (_ sizeStr: String) -> Void) {
        
        if assets.count < 1 {
            completion("0.00KB")
            return
        }
        
        let imageManager = PHImageManager.default()

        let options = PHImageRequestOptions()
        options.isSynchronous = true  // 同步获取

        var totalSize: Int = 0
        let dispatchGroup = DispatchGroup()

        for asset in assets {
            dispatchGroup.enter()
            imageManager.requestImageDataAndOrientation(for: asset, options: options) { data, dataUTI, orientation, info in
                
                if let data = data {
                    let sizeInBytes = data.count  // 图片的字节数
                    totalSize = totalSize + sizeInBytes
                }
                
                dispatchGroup.leave()
                
            }
            
        }
        
        dispatchGroup.notify(queue: .main) {
            
            if convertUnits {
                completion(Double(totalSize).getFileSizeStr())
            } else {
                completion(String(totalSize))
            }
            
        }

        
    }
    
    
    func deletePhotos(assets: [PHAsset], handler: ((_ success: Bool) -> Void)?) {
        
        if assets.count < 1 {
            if let handler = handler {
                handler(false)
            }

            return
        }
        
        self.requestPhotoLibraryAccess { isAuthorized in
            
            if isAuthorized {
                
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.deleteAssets(assets as NSArray)
                }, completionHandler: { success, error in
                    
                    if let handler = handler {
                        
                        DispatchQueue.main.async {
                            handler(success)
                        }
                        
                    }
                    
                    if success {
                       
                    } else {
                    }
                })
                
            } else {
                
                if let handler = handler {
                    
                    DispatchQueue.main.async {
                        handler(false)
                    }
                    
                }
            }
            
        }
        
       
    }
    
    
    // 通过 PHAsset 获取图片
    func loadImageFromPHAsset(asset: PHAsset, completion: ((_ image: UIImage?) -> Void)?) {
        let imageManager = PHImageManager.default()
        let imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.isSynchronous = false
        imageRequestOptions.deliveryMode = .highQualityFormat
        
        // 设置要获取图片的目标尺寸
        let targetSize = CGSize(width: 200, height: 200)  // 缩略图大小，可根据需要调整
        
        // 请求图片
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: imageRequestOptions) { (image, info) in
            
            if let image = image {
                // 处理获取到的图片，例如显示在 UIImageView 中
                
                if let completion = completion {
                    completion(image)
                }
                
            } else {
                if let completion = completion {
                    completion(nil)
                }
            }
            
        }
    }
    
    func fetchAllPhotos(completion: ((_ photosArray: [DDPhotosModel]) -> Void)?) {
        var allPhotos: [PHAsset] = []
        
        // 创建一个 PHFetchOptions 对象来设置过滤器或排序方式
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]  // 按创建日期排序
        
        // 从相册中获取所有照片
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        // 遍历结果
        fetchResult.enumerateObjects { (asset, index, stop) in
            allPhotos.append(asset)
        }
        
        // 处理获取到的照片
        var photosCount = allPhotos.count
        
        var photosArray: [DDPhotosModel] = []
        
        for asset in allPhotos {
            // 在这里可以加载缩略图或原始图像
            
            loadImageFromPHAsset(asset: asset) { image in
                
                photosCount = photosCount - 1
                
                if let image = image {
                    
                    let model = DDPhotosModel()
                    model.asset = asset
                    model.image = image
                    photosArray.append(model)
                    
                }
                
                if photosCount == 0 {
                    if let completion = completion {
                        completion(photosArray)
                    }
                }

                
            }

        }
        
    }
    
    
    // 获取相册中所有图片的 PHAsset
    func fetchAllPhotos() -> [PHAsset] {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        var photoAssets: [PHAsset] = []
        
        allPhotos.enumerateObjects { (asset, _, _) in
            photoAssets.append(asset)
        }
        
        return photoAssets
    }

    // 计算图片的哈希值
    func imageHash(image: UIImage) -> String? {
        guard let imageData = image.pngData() else { return nil }
        
        return imageData.base64EncodedString() // 简单的 base64 编码
    }

    // 获取图片并计算哈希值
    func fetchImageAndCalculateHash(asset: PHAsset, completion: @escaping (String?, PHAsset) -> Void) {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true // 同步获取图片数据
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: options) { (image, _) in
            if let image = image {
                let hash = self.imageHash(image: image)
                completion(hash, asset)
            } else {
                completion(nil, asset)
            }
        }
    }

    // 查找重复的图片，并返回一个二维数组，每个子数组包含重复的图片
    func findDuplicatePhotos(completion: @escaping ([[PHAsset]]) -> Void) {
        let allPhotos = fetchAllPhotos()
        var photoHashes: [String: [PHAsset]] = [:] // 哈希值到图片数组的映射
        var duplicatePhotos: [[PHAsset]] = [] // 用来存放最终的二维数组
        
        let group = DispatchGroup() // 用来处理异步操作的完成状态
        
        for asset in allPhotos {
            group.enter()
            
            fetchImageAndCalculateHash(asset: asset) { (hash, asset) in
                if let hash = hash {
                    if var existingAssets = photoHashes[hash] {
                        // 如果哈希值已存在，将这张图片添加到相应的数组中
                        existingAssets.append(asset)
                        photoHashes[hash] = existingAssets
                    } else {
                        // 创建一个新的数组存储相同哈希值的图片
                        photoHashes[hash] = [asset]
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            // 遍历 photoHashes，将其中含有多张图片的数组存储到最终的二维数组中
            for (_, assets) in photoHashes where assets.count > 1 {
                duplicatePhotos.append(assets)
            }
            
            completion(duplicatePhotos)
        }
    }

    
    // 获取 "Screenshots" 智能相册中的所有照片
    func fetchScreenshotPhotos() -> [PHAsset] {
        var screenshotPhotos: [PHAsset] = []
        
        // 获取 "Screenshots" 智能相册
        let screenshotAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumScreenshots, options: nil).firstObject
        
        if let album = screenshotAlbum {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]  // 可根据需要进行排序
            
            // 获取相册中的所有照片
            let assets = PHAsset.fetchAssets(in: album, options: fetchOptions)
            assets.enumerateObjects { (asset, _, _) in
                screenshotPhotos.append(asset)
            }
        } else {
        }
        
        return screenshotPhotos
    }
   
    
    func fetchBlurredPhotos(completion: @escaping ([PHAsset]) -> Void) {
        var blurredAssets: [PHAsset] = []

        // 请求相册权限
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                return
            }
            
            // 获取所有照片
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            
            let allPhotos = PHAsset.fetchAssets(with: fetchOptions)

            allPhotos.enumerateObjects { (asset, index, stop) in
                // 检测每张照片的模糊程度
                self.isImageBlurred(asset: asset) { isBlurred in
                    if isBlurred {
                        blurredAssets.append(asset)
                    }
                    
                    // 如果是最后一张照片，则返回结果
                    if index == allPhotos.count - 1 {
                        completion(blurredAssets)
                    }
                }
            }
        }
    }

    // 检测照片是否模糊
    func isImageBlurred(asset: PHAsset, completion: @escaping (Bool) -> Void) {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat

        imageManager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: options) { (image, info) in
            guard let image = image else {
                completion(false)
                return
            }

            // 使用拉普拉斯算子检测模糊
            let DimValue = UIImage.getDimValue(image)
            
            if DimValue < 500 {
                completion(true)
            } else {
                completion(false)
            }
        }
    }


// MARK: - Videos

    func fetchShortVideos(maxDuration: Double = 15, completion: @escaping ([PHAsset]) -> Void) {
        // 请求相册访问权限
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                completion([])
                return
            }

            // 配置筛选条件
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)
            
            // 获取相册中的所有视频
            let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
            var shortVideos: [PHAsset] = []

            // 遍历所有视频，筛选出时长小于 maxDuration 的视频
            fetchResult.enumerateObjects { (asset, _, _) in
                if asset.duration <= maxDuration {
                    shortVideos.append(asset)
                }
            }

            // 返回筛选后的短视频
            DispatchQueue.main.async {
                completion(shortVideos)
            }
        }
    }

    
    func fetchVideoFileSize(asset: PHAsset, completion: @escaping (Int64) -> Void) {
        let resources = PHAssetResource.assetResources(for: asset)
        guard let videoResource = resources.first(where: { $0.type == .video }) else {
            completion(0)
            return
        }

        let resourceManager = PHAssetResourceManager.default()
        let options = PHAssetResourceRequestOptions()
        options.isNetworkAccessAllowed = true

        var totalFileSize: Int64 = 0
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        resourceManager.requestData(for: videoResource, options: options, dataReceivedHandler: { data in
            totalFileSize += Int64(data.count)
        }, completionHandler: { _ in
            dispatchGroup.leave()
        })

        dispatchGroup.notify(queue: .main) {
            completion(totalFileSize)
        }
    }

    func findDuplicateVideos(completion: @escaping ([[PHAsset]]) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                completion([])
                return
            }

            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)

            let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)

            var videoSizes: [String: [PHAsset]] = [:]
            let dispatchGroup = DispatchGroup()

            fetchResult.enumerateObjects { (asset, _, _) in
                dispatchGroup.enter()
                self.fetchVideoFileSize(asset: asset) { fileSize in
                    
                    let resources = PHAssetResource.assetResources(for: asset)
                    let resource = resources.first
                    
                    // 根据视频的文件大小、时长、创建日期生成唯一标识符
                    let key = "\(resource?.originalFilename ?? "0")_\(fileSize)_\(asset.duration)_\(asset.creationDate ?? Date())"
                    
                    
                    // 将视频资产按文件大小分组
                    if videoSizes[key] != nil {
                        videoSizes[key]?.append(asset)
                    } else {
                        videoSizes[key] = [asset]
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                // 筛选出重复的视频
                let duplicateGroups = videoSizes.values.filter { $0.count > 1 }
                completion(duplicateGroups)
            }
        }
    }
    
    
    func getVideoPHAssetsTotalFileSize(assets: [PHAsset], convertUnits: Bool = true, completion: @escaping (_ sizeStr: String) -> Void) {
        
        if assets.count < 1 {
            completion("0.00KB")
            return
        }
        
        var totalSize: Int64 = 0
        let dispatchGroup = DispatchGroup()

        for asset in assets {
            dispatchGroup.enter()
            self.fetchVideoFileSize(asset: asset) { fileSize in
                totalSize += fileSize // 累加文件大小
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            
            if convertUnits {
                // 返回总文件大小
                completion(Double(totalSize).getFileSizeStr())
            } else {
                // 返回总文件大小
                completion(String(totalSize))
            }
        }
    }
    

    
    func fetchAllVideos(completion: @escaping ([PHAsset]) -> Void) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)

        let allVideos = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        var videoAssets: [PHAsset] = []

        allVideos.enumerateObjects { (asset, _, _) in
            videoAssets.append(asset)
        }

        completion(videoAssets)
    }
    
    func isVideoNamedRPReplay(asset: PHAsset, completion: @escaping (Bool) -> Void) {
        let resources = PHAssetResource.assetResources(for: asset)

        // 获取视频资源的文件名
        if let resource = resources.first {
            let fileName = resource.originalFilename
            completion(fileName.hasPrefix("RPReplay"))
        } else {
            completion(false)
        }
    }
    
    func fetchScreenRecordingVideos(completion: @escaping ([PHAsset]) -> Void) {
        requestPhotoLibraryAccess { granted in
            guard granted else {
                completion([])
                return
            }

            self.fetchAllVideos { allVideos in
                var rpReplayVideos: [PHAsset] = []
                let dispatchGroup = DispatchGroup()

                for asset in allVideos {
                    dispatchGroup.enter()
                    self.isVideoNamedRPReplay(asset: asset) { isRPReplay in
                        if isRPReplay {
                            rpReplayVideos.append(asset)
                        }
                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    completion(rpReplayVideos)
                }
            }
        }
    }



    
}
