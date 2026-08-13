import Foundation
import EventKit

// 定义一个结构来保存事件信息
struct DDCalendarEvent: Equatable {
    let title: String
    let startDate: Date
    let endDate: Date
    let calendarTitle: String
    let eventId: String // 添加事件ID属性
}

class DDCalendarManager: NSObject {
    
    static let shared = DDCalendarManager()
    
    func checkCalendarAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        // 创建 EKEventStore 实例
        let eventStore = EKEventStore()
        
        // 检查日历权限的当前状态
        let status = EKEventStore.authorizationStatus(for: .event)
        
        switch status {
        case .notDetermined:
            // 用户尚未作出选择，请求权限
            eventStore.requestAccess(to: .event) { (granted, error) in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        case .authorized:
            // 已经获得权限
            completion(true)
            
            // 在此处继续处理日历数据
        case .restricted, .denied:
            // 用户已拒绝或访问受限制
            completion(false)
            
        @unknown default:
            completion(false)
            
        }
    }
    
    
    // 定义一个函数来获取日历事件
    func fetchEventsForLastThreeYears(completion: @escaping ([Int: [DDCalendarEvent]]) -> Void) {
        let eventStore = EKEventStore()
        // 获取当前日期
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let currentDate = Date() // 当前日期
        
        // 获取今年、去年和前年
        let yearsToFetch = [currentYear, currentYear - 1, currentYear - 2]
        var eventsByYear: [Int: [DDCalendarEvent]] = [:]
        
        for year in yearsToFetch {
            // 定义时间范围
            let startDate = calendar.date(from: DateComponents(year: year, month: 1, day: 1))!
            
            // 对于今年，结束日期为当前日期，其他年份为下一年1月1日
            let endDate: Date
            if year == currentYear {
                endDate = currentDate // 今年截止到当前日期
            } else {
                endDate = calendar.date(from: DateComponents(year: year + 1, month: 1, day: 1))! // 其他年份到下一年1月1日
            }
            
            // 创建谓词以获取指定时间段内的事件
            let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
            
            // 获取事件
            let events = eventStore.events(matching: predicate)
            
            // 仅当事件非空时才将其添加到字典中
            if !events.isEmpty {
                // 对事件按开始日期降序排序
                eventsByYear[year] = events.map { event in
                    DDCalendarEvent(title: event.title ?? "",
                                    startDate: event.startDate,
                                    endDate: event.endDate,
                                    calendarTitle: event.calendar.title,
                                    eventId: event.eventIdentifier)
                }.sorted { $0.startDate > $1.startDate } // 按开始日期降序排序
            }
        }
        // 调用 completion 处理结果
        completion(eventsByYear)
        
        
    }
    
    func deleteCalendarEvents(events: [DDCalendarEvent], completion: @escaping (Bool) -> Void) {
        let eventStore = EKEventStore()
        
        // 请求访问日历权限
        eventStore.requestAccess(to: .event) { (granted, error) in
            guard granted, error == nil else {
                completion(false)
                return
            }

            // 批量删除事件
            
            let disGroup = DispatchGroup()

            for event in events {
                disGroup.enter()
                // 根据事件 ID 查找事件
                if let ekevent = eventStore.event(withIdentifier: event.eventId) {
                    
                    try? eventStore.remove(ekevent, span: .thisEvent)
                    
                    disGroup.leave()
                    
                }
                
            }
            
            disGroup.notify(queue: .main) {
                completion(true)

            }
            
            
        }
    }
    
    
    
    
    
}
