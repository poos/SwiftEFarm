//
//  SearchResultModel.swift
//  EFarmSwift
//
//  Created by n369 on 2017/9/4.
//  Copyright © 2017年 Shown. All rights reserved.
//

import Foundation

class SearchResultModel {
    
    /// ID
    let id :Int
    
    /// 标题
    let title : String
    
    /// 副标题
    let detail : String
    
    /// 图片
    let image : String
    
    /// 时间
    var time : String
    
    init(id:Int,title:String,detail:String,image:String,time:String) {
        self.id = id
        self.title = title
        self.detail = detail
        self.image = image
        self.time = time
    }
    
//    init?() {
//        print("can not create model")
//        return nil
//    }
}

class SearchResultModelList {
    
    var page : Int!
    
    var haveNextPage : Bool
    
    var news : [SearchResultModel]?
    
    init(page:Int, haveNextPage:Bool, news:[SearchResultModel]?){
        self.page = page
        
        self.haveNextPage = haveNextPage
        
        self.news = news
    }
}
