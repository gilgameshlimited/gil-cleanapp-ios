import Foundation
import CoreImage

extension UIColor {
    convenience init!(hexString: String, alpha: CGFloat = 1.0) {
        var value = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if value.hasPrefix("0X") {
            value.removeFirst(2)
        } else if value.hasPrefix("#") {
            value.removeFirst()
        }

        guard value.count == 6 else { return nil }

        let scanner = Scanner(string: value)
        var rgbValue: UInt64 = 0
        guard scanner.scanHexInt64(&rgbValue) else { return nil }

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

extension NSString {
    static func getTextHeight(withText text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let bounds = (text as NSString).boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        return ceil(bounds.height)
    }
}

extension FileManager {
    
    class func fileSize(path: String?) -> String {
        guard let path = path else {
            return ""
        }
        
        guard let size = try? FileManager.default.attributesOfItem(atPath: path)[FileAttributeKey.size],
        let fileSize = size as? UInt64 else {
            return ""
        }
        
        // bytes
        if fileSize < 1023 {
            return String(format: "%lubytes", CUnsignedLong(fileSize))
        }
        // KB
        var floatSize = Float(fileSize / 1024)
        if floatSize < 1023 {
            return String(format: "%.1fKB", floatSize)
        }
        // MB
        floatSize = floatSize / 1024
        if floatSize < 1023 {
            return String(format: "%.1fMB", floatSize)
        }
        // GB
        floatSize = floatSize / 1024
        return String(format: "%.1fGB", floatSize)
    }
    
    
    // 将数据写入沙盒目录
    func writeDataToSandbox(data: Data, fileURL: URL) -> Bool {
        
        do {
            try data.write(to: fileURL)
            return true
        } catch {
            return false
        }
        
    }

    
    
}


extension String {
    
    var validURL: Bool {
        let urlRegEx = "(https?://)?([\\w\\d\\-_]+\\.)+[\\w\\d\\-_]+(/[\\w\\d\\-_.?=&]*)?"
        let urlTest = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
        return urlTest.evaluate(with: self)
    }
    
    var validTrimSpaces: Bool {
        // 过滤空格和回车
        let trimmedStr = self.trimmingCharacters(in: .whitespacesAndNewlines)

        // 判断过滤后的字符串是否为空
        if !trimmedStr.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func jsonStringToArray() -> [[String]]? {
        
        if let jsonData = self.data(using: .utf8) {
            do {
                if let array = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String]] {
                    return array
                }
            } catch {
            }
            
            
        }
        
        return nil
        
    }
    
    
    func generateQRCode() -> UIImage? {
        // 将字符串转换为Data
        let data = self.data(using: .utf8)
        
        // 创建一个二维码滤镜
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("Q", forKey: "inputCorrectionLevel")
            
            // 获取滤镜输出的图像
            if let qrCodeImage = filter.outputImage {
                // 调整图像的比例，以便显示更清晰的二维码
                let transform = CGAffineTransform(scaleX: 10, y: 10)
                let scaledQrCodeImage = qrCodeImage.transformed(by: transform)
                
                // 将CIImage转换为UIImage
                return UIImage(ciImage: scaledQrCodeImage)
            }
        }
        
        return nil
    }
    
    
    func generateQRCode(foregroudColor: UIColor, backgroudColor: UIColor) -> UIImage? {
        // 将字符串转换为数据
        guard let data = self.data(using: String.Encoding.utf8) else { return nil }

        // 创建二维码滤镜
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")
        
        // 获取滤镜输出的二维码图像
        guard let qrImage = filter.outputImage else { return nil }
        
        // 创建颜色滤镜，设置二维码颜色
        guard let colorFilter = CIFilter(name: "CIFalseColor", parameters: [
            "inputImage": qrImage,
            "inputColor0": CIColor(color: foregroudColor), // 二维码颜色
            "inputColor1": CIColor(color: backgroudColor) // 背景颜色
        ]) else { return nil }
        
        // 获取滤镜输出的带颜色二维码图像
        guard let coloredQRImage = colorFilter.outputImage else { return nil }
        
        // 将 CIImage 转换为 UIImage
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQRImage = coloredQRImage.transformed(by: transform)
        let uiImage = UIImage(ciImage: scaledQRImage)
        
        return uiImage
    }

    
    static func canGenerateQRCode(from string: String, version: Int, errorCorrectionLevel: String) -> Bool {
        
        let maxLength = maxCharacters(forVersion: version, errorCorrectionLevel: errorCorrectionLevel)
        return string.count <= maxLength
    }
    
    static func maxCharacters(forVersion version: Int, errorCorrectionLevel: String) -> Int {
        switch version {
        case 1:
            switch errorCorrectionLevel {
            case "L": return 25
            case "M": return 20
            case "Q": return 16
            case "H": return 10
            default: return 0
            }
        case 40:
            switch errorCorrectionLevel {
            case "L": return 4296
            case "M": return 3391
            case "Q": return 2953
            case "H": return 2048
            default: return 0
            }
        default:
            return 2953 // 默认假设最高版本
        }
    }
    
    
    static func getDateString(formatterStr: String, date: Date = Date()) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatterStr
        return dateFormatter.string(from: date)
    }
    
    static func getFilePathTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        return dateFormatter.string(from: Date())
    }

}



extension UIImage {
    
    

    
    /// pdf文件缩略图
    class func thumbnailIFromPDF(Url url: URL, _ pageNumber: Int = 1, _ width: CGFloat = 120) -> UIImage? {
        guard
            let pdf = CGPDFDocument(url as CFURL),
            let page = pdf.page(at: pageNumber)
        else { return nil }

        var pageRect = page.getBoxRect(.mediaBox)
        let pdfScale = width / pageRect.size.width
        pageRect.size = CGSize(width: pageRect.size.width * pdfScale, height: pageRect.size.height * pdfScale)
        pageRect.origin = .zero

        UIGraphicsBeginImageContext(pageRect.size)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(UIColor.white.cgColor)
            context.fill(pageRect)
            context.saveGState()

            context.translateBy(x: 0.0, y: pageRect.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.concatenate(page.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))

            context.drawPDFPage(page)
            context.restoreGState()
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        defer { UIGraphicsEndImageContext() }
        return image
    }
}



extension Array {
    
    func toJsonString() -> String? {

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .fragmentsAllowed)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            
        }
        
        return nil

    }
    
    
    
}


extension Double {
    
    func getFileSizeStr() -> String {
        var bytes = self
        // bytes
        if bytes < 1000.0 {
            return String(format: "%.2fB", bytes)
        }
        // KB
        var kb = bytes / 1000.0
        if kb < 1000.0 {
            return String(format: "%.2fKB", kb)
        }
        // MB
        var mb = kb / 1000.0
        if mb < 1000.0 {
            return String(format: "%.1fMB", mb)
        }
        // GB
        var gb = mb / 1000.0
        return String(format: "%.1fGB", gb)
    }

}
