import UIKit

class DDCalendarController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selBtn: UIButton!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var delBtn: UIButton!
    @IBOutlet var nodataView: UIView!
    var handler: (() -> Void)?

    var calendarDic: [Int: [DDCalendarEvent]] = [:]
    var yearKeys: [Int] = []
    var delArr: [DDCalendarEvent] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fd_prefersNavigationBarHidden = true
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.nodataView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarAndStatusBarHeight - kBottomSafeHeight)
        self.tableView.tableHeaderView = self.nodataView
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "DDCalendarListCell", bundle: nil), forCellReuseIdentifier: "DDCalendarListCell")
        self.tableView.register(UINib(nibName: "DDCalendarHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "DDCalendarHeaderView")
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0.0
        }
        
        // 注册 KVO 监听 tableView 的 contentSize
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        setupLocalization()
        updateSelectViews()
        loadData()
        
    }
    
    func setupLocalization() {
        
        self.titleLab.text = DDlocal("DDCalendar")
        
        
    }
    
    func updateSelectViews() {
        
        if self.delArr.count > 0 {
            self.delBtn.backgroundColor = UIColor(hexString: "#3863FF")
            self.delBtn.setTitle("\(DDlocal("DDClean")) \(self.delArr.count) \(DDlocal("DDSmallevents"))", for: .normal)
        } else {
            self.delBtn.backgroundColor = UIColor(hexString: "#3863FF", alpha: 0.5)
            self.delBtn.setTitle("\(DDlocal("DDClean")) \(DDlocal("DDSmallevents"))", for: .normal)
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadData() {
        DDCalendarManager.shared.checkCalendarAuthorizationStatus { success in
            
            if success {
                
                DDCalendarManager.shared.fetchEventsForLastThreeYears { calendarDic in
                    
                    self.calendarDic = calendarDic
                    self.yearKeys = calendarDic.keys.sorted(by: >)
                    self.tableView.reloadData()
                    
                }
                
            }
            
        }
    }
    
    // 实现观察者方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize", let tableView = object as? UITableView {
            let newHeight = tableView.contentSize.height
            
            if newHeight > SCREEN_HEIGHT - kNavBarHeight - kBottomSafeHeight - 51 - 11 {
                
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 51 + 11, right: 0)

            } else {
                
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                
            }
            
        }
    }

    
    @IBAction func selClick(_ sender: Any) {
        
        if !self.selBtn.isSelected {
            
            var allCalender: [DDCalendarEvent] = []
            for key in self.yearKeys {
                
                if let arr = self.calendarDic[key] {
                    for calender in arr {
                        
                        allCalender.append(calender)
                        
                    }
                    
                }
                
                
            }
            
            self.delArr = allCalender
            
        } else {
            
            self.delArr = []
            
        }
        
        self.selBtn.isSelected = !self.selBtn.isSelected
        updateSelectViews()

        
    }
    @IBAction func backClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteClick(_ sender: UIButton) {
        
        if self.delArr.count > 0 {
            let alert = UIAlertController(title: "\(DDlocal("DDClean")) \(self.delArr .count) \(DDlocal("DDSelected_events"))", message: DDlocal("DDItems_will_be_removed_from_the_Calendar"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: DDlocal("DDDelete"), style: .default, handler: { action in
                
                
                DDCalendarManager.shared.deleteCalendarEvents(events: self.delArr) { success in
                    
                    if success {
                        
                        DDshowToast(DDlocal("DDSuccess"))
                        
                        
                        if let handler = self.handler {
                            handler()
                        }
                        
                        self.calendarDic = [:]
                        self.yearKeys = []
                        self.delArr = []
                        self.tableView.reloadData()
                        self.loadData()
                        
                    } else {
                        
                        DDshowToast(DDlocal("DDFail"))

                    }
                    
                    
                }
                

            }))
            alert.addAction(UIAlertAction(title: DDlocal("DDCancel"), style: .cancel))
            self.present(alert, animated: true)
        }
        

        
        
    }
    
    
    // MARK: - TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        
        DispatchQueue.main.async {
        
            if self.calendarDic.count < 1 {
                self.tableView.tableHeaderView = self.nodataView
                self.tableView.backgroundColor = UIColor(hexString: "#EBF3FF")
                self.view.backgroundColor = UIColor(hexString: "#EBF3FF")
            } else {
                self.tableView.tableHeaderView = UIView()
                self.tableView.backgroundColor = .white
                self.view.backgroundColor = .white
            }
            
        }
        
        return self.calendarDic.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let arr = self.calendarDic[self.yearKeys[section]]
        
        return arr?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DDCalendarListCell") as! DDCalendarListCell
        cell.selectionStyle = .none
        
        let calendar = self.calendarDic[self.yearKeys[indexPath.section]]?[indexPath.row]
        
        cell.titleLab.text = calendar?.title ?? ""
        cell.subTitleLab.text = calendar?.calendarTitle ?? ""
        cell.dateLab.text = String.getDateString(formatterStr: "MMM dd, yyyy", date: calendar?.startDate ?? Date())
      
        if let calendar = calendar, self.delArr.contains(calendar) {
            cell.selBtn.isSelected = true
        } else {
            cell.selBtn.isSelected = false
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let calendar = self.calendarDic[self.yearKeys[indexPath.section]]?[indexPath.row] {
            
            
            if let index = self.delArr.firstIndex(of: calendar) {
                self.delArr.remove(at: index)
            } else {
                self.delArr.append(calendar)
            }
            
            updateSelectViews()

        }

      
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DDCalendarHeaderView") as! DDCalendarHeaderView
        
        headerView.titleLab.text = String(self.yearKeys[section])

        
        return headerView


    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude // 或者返回 0
    }
    

    deinit {
        // 记得在销毁时移除观察者
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
}
