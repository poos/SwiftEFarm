//
//  UserInfo.swift
//  EFarmSwift
//
//  Created by n369 on 2017/9/4.
//  Copyright © 2017年 Shown. All rights reserved.
//

import UIKit

private let keyUserHistorySearch = "appKeyUserHistorySearch"

class UserInfo: NSObject {

    //计算属性
    static var searchArr : [String]? {
        
        //获取值
        get{
            return UserDefaults.standard.value(forKey: keyUserHistorySearch) as? [String]
        }
        //设置值
        set(arr){
            UserDefaults.standard.set(arr, forKey: keyUserHistorySearch)
        }
    }
    
    
    
}
