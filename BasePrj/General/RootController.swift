//
//  RootController.swift
//  EFarmSwift
//
//  Created by n369 on 2017/8/29.
//  Copyright © 2017年 Shown. All rights reserved.
//

import UIKit

//swift 是严谨的语言,所有成员变量都要初始化
class RootController: UIViewController {
    
    // MARK: - 单例写法
    //单例/类成员变量,只读,访问获取单例
    static let shareSingleton = RootController();
    
    // MARK: - 外部变量,var,外部可以设置
    //main vc
    var mainVC : UIViewController = UIViewController() {
        //普通属性示例,可以监听 willSet 和 didSet 方法
        //替代OC中重写setter方法，didSet没有代码提示
        //区别：不用考虑 _成员变量 = 值！
        //OC中如果是copy属性，应该 _成员变量 = 值 copy
        //初始化时候不会调用
        
        didSet {
            //此时已经有值，做一些处理
            self.view.addSubview(mainVC.view)
            
            mainVC.view.addSubview(leftPanGesView)
            
            
            if mainVC.isKind(of: UINavigationController.self) {
                let nvc : UINavigationController = mainVC as! UINavigationController
                let mvc : UIViewController = nvc.viewControllers.first!
                mvc.view.addSubview(leftPanGesView)
            } else {
                mainVC.view.addSubview(leftPanGesView)
            }
            
            let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(RootController.panGestureActionShow(gesture:)))
            leftPanGesView.addGestureRecognizer(panGesture)
        }
    }
    //left vc
    var leftVC = UIViewController() {
        didSet {
            leftVC.view.frame.origin.x = -ScreenWidth/2
        }
    }
    //需要添加手势的view
    var panGesbutton = UIView() {
        didSet {
            let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(RootController.panGestureActionShow(gesture:)))
            panGesbutton.addGestureRecognizer(panGesture)
            
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(RootController.showLeftView))
            panGesbutton.addGestureRecognizer(tapGesture)
        }
    }
    
    // MARK: - 私有变量,内部访问
    
    private var leftPanGesView : UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 64, width: 20, height: ScreenHeight-64))
        return view
    }()
    
    //main vc的遮罩层
    private var mainVCView : UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        view.backgroundColor = UIColor.black
        view.alpha = 0
        return view
        }()
    
    
    // MARK: - 外部方法(类方法) class
    //展示左侧
    @objc class func showLeftView() -> Void {
        self.shareSingleton.showLeftView()
    }
    //展示左侧
    @objc class func hideLeftView() -> Void {
        self.shareSingleton.hideLeftView()
    }
    // MARK: - 普通方法
    func scrollView(gesture : UIPanGestureRecognizer, isShow : Bool) -> Void {
        
        //得到拖的过程中的xy坐标
        let translation : CGPoint = gesture.translation(in: self.view)
        
        if (gesture.state == UIGestureRecognizerState.began && isShow) {
            self.view.addSubview(leftVC.view)
            self.view.insertSubview(leftVC.view, belowSubview:mainVC.view)
            self.mainVC.view.addSubview(mainVCView)
            mainVCView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(RootController.hideLeftView)))
            mainVCView.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(RootController.panGestureActionHide(gesture:))))
        }
        
        let tranX = translation.x
        
        if (gesture.state == UIGestureRecognizerState.changed && isShow) {
            if (tranX > 0 && tranX < ScreenWidth*3/4) {
                
                self.mainVC.view.frame.origin.x = tranX;
                self.leftVC.view.frame.origin.x = -ScreenWidth/2 + (tranX / (ScreenWidth*3/4)) * ScreenWidth/2;
                self.mainVCView.alpha = (tranX / (ScreenWidth*3/4)) * 0.3
            }
        }
        if (gesture.state == UIGestureRecognizerState.changed && !isShow) {
            if (tranX < 0 && tranX > -ScreenWidth*3/4) {
                
                self.mainVC.view.frame.origin.x = (ScreenWidth*3/4) + tranX;
                self.leftVC.view.frame.origin.x = ScreenWidth/2 - (1 - (tranX / (ScreenWidth*3/4))) * ScreenWidth/2;
                self.mainVCView.alpha = 0.3+(tranX / ((ScreenWidth*3/4) + tranX)) * 0.3
            }
        }
        
        if (gesture.state == UIGestureRecognizerState.ended) {
            let mainX = self.mainVC.view.frame.origin.x
            if (mainX > 0 && mainX <= ScreenWidth*3/4/2) {
                self.hideLeftView()
            } else {
                self.showLeftView()
            }
        }
        
    }
    
    @objc func panGestureActionHide(gesture : UIPanGestureRecognizer) -> Void {
        self.scrollView(gesture: gesture, isShow: false)
    }
    @objc func panGestureActionShow(gesture : UIPanGestureRecognizer) -> Void {
        self.scrollView(gesture: gesture, isShow: true)
    }
    
    
    
    
    @objc func showLeftView() -> Void {
        
        self.view.addSubview(leftVC.view)
        self.view.insertSubview(leftVC.view, belowSubview:mainVC.view)
        
        mainVC.view.addSubview(mainVCView)
        
        mainVCView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(RootController.hideLeftView)))
        mainVCView.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(RootController.panGestureActionHide(gesture:))))
        
        UIView.animate(withDuration: 0.3) {
            self.mainVC.view.frame.origin.x = ScreenWidth*3/4
            self.leftVC.view.frame.origin.x = 0
            self.mainVCView.alpha = 0.3
        }
    }
    
    @objc func hideLeftView() -> Void {
        UIView.animate(withDuration: 0.3, animations: {
            self.mainVC.view.frame.origin.x = 0
            self.leftVC.view.frame.origin.x = -ScreenWidth/2
            self.mainVCView.alpha = 0
        }) { (true) in
            self.mainVCView.removeFromSuperview()
            self.leftVC.view.removeFromSuperview()
        }
    }

    
    
    
    // MARK: - 生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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


// MARK: - 手势代理delegate
//一般采用分类的方式
//extension RootController : UIGestureRecognizerDelegate {
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if (panGesture == gestureRecognizer) {
//            let translation = panGesture.translation(in: self.view);
//            if (panGesture.velocity(in: self.view).x < 600 && abs(translation.x) / abs(translation.y) > 1) {
//                if((translation.x>0)||(translation.x<0)){
//                    return true;
//                }
//            }
//            return false;
//        }
//        return true;
//    }
//}

