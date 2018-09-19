//
//  PublicConstant.swift
//  EFarmSwift
//
//  Created by n369 on 2017/8/29.
//  Copyright © 2017年 Shown. All rights reserved.
//


import UIKit



let identifierTitle = "TableViewCellIdentifierTitle"
let identifierOnePic = "TableViewCellIdentifierOnePic"
let identifierThreePic = "TableViewCellIdentifierThreePic"


let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height

let APPDelegate = UIApplication.shared.delegate as! AppDelegate
let Namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String//获取命名空间

let BackColor = UIColor.init(red: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1)
let NomalColor = UIColor.init(red: 0, green: 122/255.0, blue: 233/255.0, alpha: 1)
let CancleColor = UIColor.init(red: 0, green: 122/255.0, blue: 233/255.0, alpha: 1)
let TitleColor = UIColor.init(red: 68/255.0, green: 68/255.0, blue: 68/255.0, alpha: 1)
let DetailColor = UIColor.init(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)

let TitleFont = UIFont.systemFont(ofSize: 16)
let DetailFont = UIFont.systemFont(ofSize: 12)




public func ColorRGB(_ r: Int, _ g: CGFloat, _ b: CGFloat) -> UIColor {
    return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1)
}

public func ColorRGB_(_ v: Int) -> UIColor {
    return UIColor.init(red: CGFloat(v)/255.0, green: CGFloat(v)/255.0, blue: CGFloat(v)/255.0, alpha: 1)
}


public extension UIView {
    //只读属性, 不写set就是只读
    var left : CGFloat {
        get{
            return self.frame.origin.x
        }
//        set{
//            
//        }
    }
    //上述方式的简写
    var right : CGFloat {
        return self.frame.origin.x + self.frame.size.width
    }
    
    var top : CGFloat {
        return self.frame.origin.y
    }
    
    var bottom : CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
    
    var width : CGFloat {
        return self.frame.size.width
    }
    
    var height : CGFloat {
        return self.frame.size.height
    }
    
}

extension UIDevice {
    public func isIPhoneX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        
        return false
    }
}


