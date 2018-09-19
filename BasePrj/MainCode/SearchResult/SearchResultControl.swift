//
//  SearchHistoryControl.swift
//  EFarmSwift
//
//  Created by n369 on 2017/9/4.
//  Copyright © 2017年 Shown. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SearchResultControl {
    
    //      func requestData(urlString:String,succeed: ((Any?)->(Void))?,failure:((Any?)->(Void))?){
    
    func loadListInfo(keyWord : String, complate :@escaping (_ listData : SearchResultModelList?)->Void, failure:((Any?)->(Void)?)? = nil){
        
//        let request = Alamofire.request
//        request
        
        Alamofire.request(UrlSearchNews,  parameters : ["keyword" : keyWord]).responseJSON { (responce) in
            if let result : Any = responce.result.value {
                let json = JSON.init(result)
                
                let jsonData = json["data"]
                
                if (jsonData.dictionary != nil) {
                    
                    let page = jsonData["current_page"].int!
                    let haveNextPage = jsonData["has_next_page"].bool!
                    
                    let modelList : [SearchResultModel]? = self.getDataList(jsonData["list"].array)
                    
                    let homeModelList = SearchResultModelList.init(page: page, haveNextPage: haveNextPage, news: modelList)
                    
                    complate(homeModelList)
                } else {
                    complate(nil)
                }
                
            } else {
                if (failure != nil) {
                    failure!("error")
                }
            }
        }
        
        
        
    }
    
    fileprivate func getDataList(_ dataList:[JSON]?) -> [SearchResultModel]? {
        var modelList = [SearchResultModel]()
        
        if dataList != nil {
            for data in dataList! {
                let model = self.getModel(data)
                modelList.append(model)
            }
        }
        return modelList
    }
    
    
    fileprivate func getModel(_ json:JSON) -> SearchResultModel {
        let id = json["id"].int!
        let title = json["title"].string!
        let detail = json["manufacturer"]["full_name"].string!
        
        let image = json["pic_url"].string!
        
        let time = json["publish_time"].string!
        
        return SearchResultModel.init(id: id, title: title, detail: detail, image: image, time: time)
    }
    
}

