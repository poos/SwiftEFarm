//
//  HomeControl.swift
//  EFarmSwift
//
//  Created by n369 on 2017/8/31.
//  Copyright © 2017年 Shown. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class HomeControl {
    
//      func requestData(urlString:String,succeed: ((Any?)->(Void))?,failure:((Any?)->(Void))?){  
    
    func loadHomeListInfo(page : Int, complate :@escaping (_ listData : HomeModelList?)->Void, failure:((Any?)->(Void)?)? = nil){
        
        //网络请求时显示小菊花
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        //带参数
        Alamofire.request(UrlNews,  parameters : ["current_page" : page]).responseJSON { (responce) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//            if let result : Any = responce.result.value {
//                let json = JSON.init(result)
                //28-35行模拟数据
                let path = Bundle.main.path(forResource: "UrlData", ofType: "json")
                var jsons = ""
                do {
                    jsons = try String.init(contentsOfFile: path!)
                }catch {
                    jsons = ""
                }
                let json = JSON.init(parseJSON: jsons)
                
                let jsonData = json["data"]
                
                if (jsonData.dictionary != nil) {
                    
                    let page = jsonData["current_page"].int!
                    let haveNextPage = jsonData["has_next_page"].bool!
                    
                    let modelList : [HomeModel]? = self.getDataList(jsonData["list"].array)
                    
                    let homeModelList = HomeModelList.init(page: page, haveNextPage: haveNextPage, news: modelList)
                    
                    complate(homeModelList)
                } else {
                    complate(nil)
                }
                
//            } else {
//                if (failure != nil) {
//                    failure!("error")
//                }
//            }
        }
        
        
        
    }
    
    fileprivate func getDataList(_ dataList:[JSON]?) -> [HomeModel]? {
        var modelList = [HomeModel]()
        
        if dataList != nil {
            for data in dataList! {
                let model = self.getModel(data)
                if model.type != ModelType.other {
                    modelList.append(model)
                }
            }
        }
        return modelList
    }

    
    fileprivate func getModel(_ json:JSON) -> HomeModel {
        let id = json["id"].int!
        let title = json["title"].string!
        let detail = json["manufacturer"]["full_name"].string!
        
        var images = [String]()
        
        let imageJson = json["content_thumbs"].array!
        if imageJson.count > 0 {
            for url in imageJson {
                let str = url.string!
                images.append(str)
            }
        }
        
        var type : ModelType
        let typeStr = json["entity_type"].string
        if (typeStr == "PRODUCT") {
            type = ModelType.product
        } else if (typeStr == "MANUFACTURER_NEWS") {
            type = ModelType.productNews
        } else if (typeStr == "PRODUCT_CASE") {
            type = ModelType.productCases
        } else if (typeStr == "PRODUCT_VIDEO") {
            type = ModelType.productVideo
        } else if (typeStr == "PORTAL_NEWS") {
            type = ModelType.farmNews
        } else {
            type = ModelType.other
        }
        
        let time = json["publish_time"].string!
        
        return HomeModel.init(id: id, title: title, detail: detail, images: images, type: type, time: time)
    }
    
}




