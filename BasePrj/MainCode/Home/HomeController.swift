
//  HomeController.swift
//  EFarmSwift
//
//  Created by n369 on 2017/8/30.
//  Copyright © 2017年 Shown. All rights reserved.
//

import UIKit
import PKHUD


class HomeController: UIViewController {
    
    var isTouch = false
    
    var panGesButton : UIView = {
        let view = UIImageView.init(image: UIImage.init(named: "user_icon"))
        view.frame = CGRect.init(x: 10, y: 20, width: 28, height: 28)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    fileprivate let homeControl : HomeControl = HomeControl()
    fileprivate var homeData : HomeModelList = HomeModelList(page: 1, haveNextPage: false, news: [])
    fileprivate var tableHeight : [CGFloat] = []
    
    let tableView : UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), style: UITableViewStyle.grouped)
        table.backgroundColor = BackColor
        return table
    }()
    
    fileprivate var searchCircleView = UIView()
    fileprivate var searchTextField = UITextField()
    fileprivate var searchCancleButton = UIButton()
    fileprivate var headerView = UIView()
    
    fileprivate var searchHistoryView : UIView = {
        var frame : CGRect = CGRect.init(x: 0, y: 50+44, width: ScreenWidth, height: ScreenHeight-50)
        if UIDevice.current.isIPhoneX() {
            frame.origin.y = 70 + (44-20)
        } else {
            frame.origin.y = 70
        }
        let view = UIView.init(frame: frame)
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    private func createNav() -> Void {
        let barItem = UIBarButtonItem.init(customView: panGesButton)
        
        self.navigationItem.leftBarButtonItem = barItem
//        self.view.addSubview(panGesButton)
        
        let titleLable = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 30))
        titleLable.text = "农头条"
        titleLable.textAlignment  = NSTextAlignment.center
        titleLable.textColor = TitleColor
        titleLable.font = UIFont.boldSystemFont(ofSize: 18)
        self.navigationItem.titleView = titleLable
        
        self.title = "返回"
    }
    
    //因为OC类NJRefresh调用,所以使用@objc开放给OC类
    @objc private func configData() -> Void {
        //使用swiftNotice提醒
        PKHUD.sharedHUD.dimsBackground = false
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = true
        HUD.show(.progress, onView: self.view)
        homeControl.loadHomeListInfo(page: 1, complate: { (list) in
            if list != nil {
                self.homeData = list!
            }
            self.tableView.reloadData()
            
            self.tableView.mj_header.endRefreshing(completionBlock: {
                //mjrefresh动画完成之后调用
                self.tableView.setContentOffset(CGPoint.init(x: 0, y: 50-64), animated: true)
            })
            
            self.tableView.mj_footer.isHidden = !self.homeData.haveNextPage
            
            HUD.flash(.success, onView: self.view, delay:1)
        })
    }
    
    @objc private func nextPageData() -> Void {
        print(self.homeData.page + 1)
        homeControl.loadHomeListInfo(page: self.homeData.page + 1 , complate: { (list) in
            if list != nil {
                var news : [HomeModel] = self.homeData.news!
                self.homeData = list!
                let addNews : [HomeModel] = list!.news!
                //数组相加
                news += addNews
                self.homeData.news = news
            }
            self.tableView.reloadData()
            
            self.tableView.mj_footer.endRefreshing(completionBlock: {
                //mjrefresh动画完成之后调用
                self.tableView.mj_footer.endRefreshing()
            })
            
            //隐藏加载按钮
            self.tableView.mj_footer.isHidden = !self.homeData.haveNextPage
            
        })
    }
    
    // MARK: - 生命周期
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = BackColor
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        tableView.register(HomeTableCell.self, forCellReuseIdentifier: identifierTitle)
        tableView.register(HomeTableCell.self, forCellReuseIdentifier: identifierOnePic)
        tableView.register(HomeTableCell.self, forCellReuseIdentifier: identifierThreePic)
        
        //ios 11tableview安全距离
//        if #available(iOS 11.0, *) {
//            tableView.contentInsetAdjustmentBehavior = .never
//            tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0)
//            tableView.scrollIndicatorInsets = tableView.contentInset
//        }
        
        self.testData()
        
        self.createNav()
        
        self.createRefresh()
        
        self.configData()
    }
    
    
    func createRefresh() -> Void {
        self.tableView.mj_header = MJRefreshNormalHeader()
        self.tableView.mj_header.setRefreshingTarget(self, refreshingAction: #selector(HomeController.configData))
        
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.nextPageData()
        })
        self.tableView.mj_footer.isHidden = true
    }
    
    func testData() {
        
        UserInfo.searchArr = ["苹果", "农民", "农药", "病虫"]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: -
// MARK: - emptyDelegate
extension HomeController : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let attStr = NSAttributedString.init(string: "暂时还没有数据哦")
//        attStr.att
        return attStr
    }
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -120
    }
}

// MARK: -
// MARK: - tableDel&dat

extension HomeController : UITableViewDelegate, UITableViewDataSource {
    
    //分类不可创建成员属性
//    var isShowSearchHeader : Bool = false
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (homeData.news?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model : HomeModel = (homeData.news?[indexPath.row])!
        
        var cell : HomeTableCell = HomeTableCell()
        if model.cellHeight == CellHeightTitle {
            cell = tableView.dequeueReusableCell(withIdentifier: identifierTitle) as! HomeTableCell
            cell.setTitleView(model: model)
        }
        if model.cellHeight == CellHeightOnePic {
            cell = tableView.dequeueReusableCell(withIdentifier: identifierOnePic) as! HomeTableCell
            cell.setOnePicView(model: model)
        }
        if model.cellHeight == CellHeightThreePic {
            cell = tableView.dequeueReusableCell(withIdentifier: identifierThreePic) as! HomeTableCell
            cell.setThreePicView(model: model)
        }
        
        if !cell.isSetTouch {
            if #available(iOS 9.0, *) {
                if self.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
                    self.registerForPreviewing(with: self, sourceView: cell)
                }
            }
            cell.isSetTouch = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model : HomeModel = homeData.news![indexPath.row]
        return model.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = WebController()
        //测试
//        vc.model = homeData.news?[indexPath.row]
        //临时
        vc.webView.load(URLRequest.init(url: URL.init(string: "https://t.ynet.cn/baijia/15160544.html#verision=b400967d&innerIframe=1")!))
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //header/footer
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let search = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 50))
        search.backgroundColor = BackColor
        
        let circle = UIView.init(frame: CGRect.init(x: 10, y: 10, width: ScreenWidth-20, height: 30))
        circle.layer.cornerRadius = 4
//        circle.layer.borderColor = UIColor.lightGray.cgColor
//        circle.layer.borderWidth = 0.5
        circle.backgroundColor = UIColor.white
        search.addSubview(circle)
        self.searchCircleView = circle
        
        let img = UIImageView.init(frame: CGRect.init(x: 18, y: 16, width: 16, height: 16))
        img.image = UIImage.init(named: "search")
        search.addSubview(img)
        
        let field = UITextField.init(frame: CGRect.init(x: 40, y: 10, width: ScreenWidth-50, height: 30))
        field.placeholder = "请输入信息进行查询"
        field.textColor = DetailColor
        field.font = TitleFont
        field.delegate = self
        field.returnKeyType = UIReturnKeyType.done
        search.addSubview(field)
        self.searchTextField = field
        
        let cancleBtn = UIButton.init(frame: CGRect.init(x: ScreenWidth-60, y: 10, width: 50, height: 30))
        cancleBtn.setTitle("取消", for: UIControlState.normal)
        cancleBtn.setTitleColor(NomalColor, for: UIControlState.normal)
        cancleBtn.addTarget(self, action: #selector(cancleBtnAction), for: UIControlEvents.touchUpInside)
        cancleBtn.alpha = 0
        search.addSubview(cancleBtn)
        self.searchCancleButton = cancleBtn
        
        //3dtouch进入, 当没在页面显示的时候初始化
        if isTouch {
            self.searchCancleButton.alpha = 1
            self.searchCircleView.frame.size = CGSize.init(width: ScreenWidth-20-60, height: 30)
            self.searchTextField.frame.size.width = ScreenWidth-20-90
            self.searchTextField.becomeFirstResponder()
        }
        
        headerView = search
        return search
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print(scrollView.contentOffset.y)
        if (self.tableView.contentOffset.y <= 50-64 && self.tableView.contentOffset.y >= 0-64) {
            if (self.tableView.contentOffset.y >= 25-64) {
                self.tableView.setContentOffset(CGPoint.init(x: 0, y: 50-64), animated: true)
            } else {
                self.tableView.setContentOffset(CGPoint.init(x: 0, y: 0-64), animated: true)
            }
        }
    }
    
    
    @objc func cancleBtnAction() -> Void {
        self.searchTextField.endEditing(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tableView.isScrollEnabled = true
        self.hideSearchHistoryView()
        
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.searchCircleView.frame.size = CGSize.init(width: ScreenWidth-20, height: 30)
            self.searchCancleButton.alpha = 0
        }) { (true) in
            self.tableView.mj_header.isHidden = false
        }
    }
    
    
}

// MARK: -
// MARK: - textFieldDelegate
extension HomeController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.beginShowSearchView()
        
    }
    
    //3dtouch静态调整searchView
    func configSearchView() -> Void {
        
        let nav : UINavigationController = RootController.shareSingleton.mainVC as! UINavigationController
        nav.popToRootViewController(animated: false)
        
        RootController.shareSingleton.hideLeftView()
        UIView.animate(withDuration: 0.01, animations: {
            nav.setNavigationBarHidden(true, animated: true)
        }) { (true) in
            self.tableView.setContentOffset(CGPoint.init(x: 0, y: -20), animated: false)
            self.tableView.isScrollEnabled = false
        }
        self.tableView.mj_header.isHidden = true
        
        //textfield设置无效时候在tableviewHeaderView初始化的时候设置一个tag用来支持
        //3dtouch进入, 在页面显示的时候初始化
        self.searchCancleButton.alpha = 1
        self.searchCircleView.frame.size = CGSize.init(width: ScreenWidth-20-60, height: 30)
        self.searchTextField.frame.size.width = ScreenWidth-20-90
        self.searchTextField.becomeFirstResponder()
        
        self.view.addSubview(self.searchHistoryView)
        if UIDevice.current.isIPhoneX() {
            self.searchHistoryView.frame.origin.y = 70 + (44-20)
        } else {
            self.searchHistoryView.frame.origin.y = 70
        }
        self.searchHistoryView.alpha = 1
        
        self.refreshHistoryView()
        
    }
    
    func beginShowSearchView() -> Void {
        if !(self.navigationController?.isNavigationBarHidden)! {
            
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.tableView.isScrollEnabled = false
            self.tableView.mj_header.isHidden = true
            self.showSearchHistoryView()
            
            searchTextField.frame.size.width = ScreenWidth-20-90
            UIView.animate(withDuration: 0.3, animations: {
                self.searchCancleButton.alpha = 1
                self.searchCircleView.frame.size = CGSize.init(width: ScreenWidth-20-60, height: 30)
            }, completion: { (true) in
                self.searchCircleView.frame.size = CGSize.init(width: ScreenWidth-20-60, height: 30)
                self.searchTextField.becomeFirstResponder()
                self.searchCancleButton.alpha = 1
            })
            
        }
        self.searchTextField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text == "" {
            return false
        } else {
            self.beginSearch(string: textField.text!)
            return true
        }
    }
    
    //开始搜索
    func beginSearch(string : String) -> Void {
        
        //记录历史
        var searchArr = UserInfo.searchArr
        
        let searchStr = string
        if searchArr == nil {
            UserInfo.searchArr = [searchStr]
        } else {
            if searchArr!.contains(searchStr) {
                searchArr!.remove(at: (searchArr?.index(of: searchStr))!)
            }
            searchArr!.insert(searchStr, at: 0)
            UserInfo.searchArr = searchArr
        }
        
        //界面恢复
        self.searchTextField.text = ""
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.cancleBtnAction()
        
        //跳转界面
        let vc = SearchResultController.init()
        vc.keyword = string
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

// MARK: -
// MARK: - 搜索view部分
//搜索视图
extension HomeController : UIScrollViewDelegate {
    
    func showSearchHistoryView() -> Void {
        self.view.addSubview(self.searchHistoryView)
        self.searchHistoryView.alpha = 0
        
        self.refreshHistoryView()
        
        UIView.animate(withDuration: 0.3) {
            if UIDevice.current.isIPhoneX() {
                self.searchHistoryView.frame.origin.y = 70 + (44-20)
            } else {
                self.searchHistoryView.frame.origin.y = 70
            }
            
            self.searchHistoryView.alpha = 1
        }
    }
    func hideSearchHistoryView() -> Void {
        self.isTouch = false
        UIView.animate(withDuration: 0.3, animations: {
            if UIDevice.current.isIPhoneX() {
                self.searchHistoryView.frame.origin.y = 70 + (44-20) + 44
            } else {
                self.searchHistoryView.frame.origin.y = 70 + 44
            }
            self.searchHistoryView.alpha = 0
            
        }) { (true) in
            self.searchTextField.frame.size.width = ScreenWidth-50
            self.searchHistoryView.removeFromSuperview()
        }
    }
    
    func refreshHistoryView() -> Void {
        
        for subView in searchHistoryView.subviews {
            subView.removeFromSuperview()
        }
        
        var userHistoryArr : [String]? = UserInfo.searchArr
        
        if userHistoryArr == nil {
            let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 160))
            label.text = "还没有搜索记录哦"
            label.textAlignment = NSTextAlignment.center
            label.textColor = DetailColor
            label.font = TitleFont
            searchHistoryView.addSubview(label)
        } else {
            
            let scoll = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: searchHistoryView.width, height: searchHistoryView.height))
            scoll.delegate = self
            searchHistoryView.addSubview(scoll)
            
            var height : CGFloat = 0
            
            let label = UILabel.init(frame: CGRect.init(x: 10, y: 0, width: 100, height: 40))
            label.text = "搜索记录"
            label.textColor = DetailColor
            label.font = DetailFont
            scoll.addSubview(label)
            
            /*
             let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 2, width: 40, height: 40))
             let image = UIImage.init(named: "history_delete")
             imageView.image = image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
             imageView.tintColor = UIColor.red
             deleteAllButton.addSubview(imageView)
             //            image?.resizableImage(withCapInsets:UIImageRenderingMode.alwaysTemplate, resizingMode: UIImageRenderingMode.alwaysTemplate)
             */
            
            let deleteAllButton = UIButton.init(frame: CGRect.init(x: ScreenWidth - 50, y: 2, width: 40, height: 40))
            deleteAllButton.setImage(UIImage.init(named: "history_delete"), for: UIControlState.normal)
            scoll.addSubview(deleteAllButton)
            deleteAllButton.addTarget(self, action: #selector(deleteALLHistory), for: UIControlEvents.touchUpInside)
            
            height += 44
            
            //for循环,用于替代 (int i = 0; i <= count; i++)
            for i in 0...userHistoryArr!.count-1 {
                
                let x : CGFloat = 10 + ((ScreenWidth - 30)/2 + 10) * CGFloat(i%2)
                
                //数值类型的强转,double,int,float,cgfloat等都可以用这种方式
                let y : CGFloat = CGFloat(44 + 45*(i/2))
                let wid : CGFloat = (ScreenWidth - 30)/2
                let hig : CGFloat = 35
                
                let button = UIButton.init(frame: CGRect.init(x: x, y: y, width: wid, height: hig))
                button.setTitle(userHistoryArr![i], for: UIControlState.normal)
                button.setTitleColor(TitleColor, for: UIControlState.normal)
                button.titleLabel?.font = DetailFont
                button.backgroundColor = BackColor
                button.layer.cornerRadius = 4
                button.clipsToBounds = true
                scoll.addSubview(button)
                
                button.addTarget(self, action: #selector(clickOneHistory(button:)), for: UIControlEvents.touchUpInside)
                
                height += 45
            }
            height += 5
            
            scoll.contentSize = CGSize.init(width: ScreenWidth, height: height)
        }
        
        
    }
    
    //MARK: - action
    @objc func clickOneHistory(button : UIButton) -> Void {
        let str : String = (button.titleLabel?.text)!
        
        self.beginSearch(string: str)
    }
    
    @objc func deleteALLHistory() -> Void {
        
        UserInfo.searchArr = nil
        self.refreshHistoryView()
        
    }
    
    
    //MARK: - scolldel
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         self.view.endEditing(true)
    }
}
//MARK: -
//MARK: - 设置3dtouch
extension HomeController : UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if #available(iOS 9.0, *) {
            let index : IndexPath = self.tableView.indexPath(for: previewingContext.sourceView as! UITableViewCell)!
            //设定预览的界面
            let vc = WebController()
//            vc.model = homeData.news?[index.row]
            
            //临时
            vc.webView.load(URLRequest.init(url: URL.init(string: "https://t.ynet.cn/baijia/15160544.html#verision=b400967d&innerIframe=1")!))
            return vc
        } else {
            // Fallback on earlier versions
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.show(viewControllerToCommit, sender: self)
    }
}


