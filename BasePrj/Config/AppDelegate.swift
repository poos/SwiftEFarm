//
//  AppDelegate.swift
//  EFarmSwift
//
//  Created by n369 on 2017/8/29.
//  Copyright © 2017年 Shown. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        // 设置窗口的根控制器
        // LXFUserViewController()
        window?.backgroundColor = UIColor.white
        // 显示窗口
        window?.makeKeyAndVisible()
        
        //同oc一样要在plist添加属性方生效
//        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        let rootVC = RootController.shareSingleton
        
        let leftVC = LeftController()
        let homeVC : HomeController = HomeController()
        
        rootVC.leftVC = leftVC
        
        let nav = UINavigationController.init(rootViewController: homeVC)
        
        nav.navigationBar.barStyle = UIBarStyle.default
        nav.navigationBar.barTintColor = ColorRGB_(245)
        nav.navigationBar.tintColor = TitleColor
        rootVC.mainVC = nav
        rootVC.panGesbutton = homeVC.panGesButton
        
        self.window?.rootViewController = rootVC
        
        //设置3dtouch
        let notTouch : Bool = self.touchConfig(launchOptions: launchOptions)
        
        return notTouch
    }
    
    func touchConfig(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        if #available(iOS 9.0, *) {
            
            let icon = UIApplicationShortcutIcon.init(type: .search)
            let icon2 = UIApplicationShortcutIcon.init(templateImageName: "user_icon")
            
            let item = UIApplicationShortcutItem.init(type: "com.efarm.search", localizedTitle: "搜索", localizedSubtitle: "快速进入搜索", icon: icon, userInfo: nil)
            let item2 = UIApplicationShortcutItem.init(type: "com.efarm.user", localizedTitle: "用户", localizedSubtitle: "快速进入个人中心", icon: icon2, userInfo: nil)
            UIApplication.shared.shortcutItems = [item, item2]
            
            
            let launchShortcutItem:UIApplicationShortcutItem? = launchOptions?[(UIApplicationLaunchOptionsKey.shortcutItem as NSObject) as! UIApplicationLaunchOptionsKey] as? UIApplicationShortcutItem
            
            if  launchShortcutItem?.type == "com.efarm.search" {
                //说明是使用3DTouch启动的,那么当页面启动的时候就需要直接跳转到新闻详细中
                let nav : UINavigationController = RootController.shareSingleton.mainVC as! UINavigationController
                let vc : HomeController = nav.viewControllers.first as! HomeController
                vc.beginShowSearchView()
                return false
            }
            if  launchShortcutItem?.type == "com.efarm.user" {
                
            }
        } else {
            // Fallback on earlier versions
        }
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {

            let launchShortcutItem:UIApplicationShortcutItem? = shortcutItem
            
            if  launchShortcutItem?.type == "com.efarm.search" {
                let nav : UINavigationController = RootController.shareSingleton.mainVC as! UINavigationController
                let vc : HomeController = nav.viewControllers.first as! HomeController
                vc.isTouch = true
                vc.tableView.setContentOffset(CGPoint.init(x: 0, y: -64), animated: false)
                vc.configSearchView()
                //dispatch系列
                //http://www.jianshu.com/p/de4c990f64e9
//                        DispatchQueue.main.async {
//                        }
            }
            if  launchShortcutItem?.type == "com.efarm.user" {

            }
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

