//
//  SearchHistoryController.swift
//  EFarmSwift
//
//  Created by n369 on 2017/9/4.
//  Copyright © 2017年 Shown. All rights reserved.
//

import UIKit
import PKHUD

fileprivate let identifier = "SearchResultTableViewCellIdentifier"
fileprivate let cellHeight = 120-72+72/375*ScreenWidth

class SearchResultController: UIViewController {
    
    //跳转时候应当设置 搜索关键字
    var keyword = ""
    
    fileprivate var tableData : SearchResultModelList = SearchResultModelList(page: 1, haveNextPage: false, news: [])
    
    fileprivate let tableView : UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), style: UITableViewStyle.grouped)
        table.backgroundColor = BackColor
        return table
    }()
    
    private let searchControl = SearchResultControl()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = BackColor
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        self.title = "搜索结果"
        
        self.configData()
    }
    
    
    func configData() -> Void {
        
        HUD.show(.progress, onView: self.view)
        searchControl.loadListInfo(keyWord: keyword, complate: { (list) in
            if list != nil {
                self.tableData = list!
                self.tableView.reloadData()
            }
            HUD.flash(.success, onView: self.view, delay:1)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - tableDel&dat

extension SearchResultController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableData.news?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if(cell == nil){
            cell = SearchResultCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier);
        }
        let realCell = cell as! SearchResultCell
        realCell.setView(model: (tableData.news?[indexPath.row])!)
        return realCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = WebController()
        vc.newModel = tableData.news?[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}


// MARK: -
// MARK: - emptyDelegate
extension SearchResultController : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let attStr = NSAttributedString.init(string: "暂时还没有数据哦")
        //        attStr.att
        return attStr
    }
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -120
    }
//    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
//        let view = UIView.init()
//        view.backgroundColor = UIColor.white
//        
//        return view
//    }
}


