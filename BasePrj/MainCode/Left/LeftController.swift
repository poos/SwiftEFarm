//
//  LeftController.swift
//  EFarmSwift
//
//  Created by n369 on 2017/8/29.
//  Copyright © 2017年 Shown. All rights reserved.
//

import UIKit

class LeftController: UIViewController {
    
    private let userBackImageView : UIImageView = {
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 200))
        let image = UIImage.init(named: "img")
        imageView.image = image?.sx_blurredImageDefault()
        return imageView
    }()
    
    private let userImageView : UIImageView = {
        let imageView = UIImageView.init(frame: CGRect.init(x: 10, y: 100, width: 50, height: 50))
        imageView.image = UIImage.init(named: "img")
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let userNameLab : UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 70, y: 100, width: ScreenWidth*3/4 - 170, height: 50))
        label.adjustsFontSizeToFitWidth = true
        label.text = "还没有登录哦"
        label.textColor = UIColor.white
        label.numberOfLines = 2;
        label.font = UIFont.systemFont(ofSize: 48)
        return label
    }()
    
    private let menuScroll : UIScrollView = {
        let scroll = UIScrollView.init(frame: CGRect.init(x: 0, y: 200, width: ScreenWidth, height: ScreenHeight - 250))
        scroll.alwaysBounceVertical = true
        return scroll
    }()
    
    private let quitButton : UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: 15, y: ScreenHeight-40, width: 90, height: 30))
        button.setTitleColor(DetailColor, for: UIControlState.normal)
        button.setTitle("退出登录", for: UIControlState.normal)
        button.isEnabled = false
        if UIDevice.current.isIPhoneX() {
            button.frame.origin.y = ScreenHeight-40 - 40
        }
        return button
    }()
    
    
    // MARK: - life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        
        
        self.view.addSubview(userBackImageView)
        self.view.addSubview(userImageView)
        self.view.addSubview(userNameLab)
        
        userBackImageView.isUserInteractionEnabled = true
        userBackImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(userTypeAction)))
        
        self.view.addSubview(menuScroll)
        
        self.createMenu()
        
        self.view.addSubview(quitButton)
    }
    
    func createMenu() -> Void {
        let menus = ["我的评论", "我的收藏", "设置" ,"关于", "帮助"]
        let images = ["my_comment", "my_fav", "my_setting", "my_help", "my_about"]
        
        var a = 0
        for str in menus {
            let image = UIImageView.init(frame: CGRect.init(x: 13, y: 30 + a*50, width: 20, height: 24))
            image.image = UIImage.init(named: images[a])
            menuScroll.addSubview(image)
            
            let label = UILabel.init(frame: CGRect.init(x: 50, y: 20 + a * 50, width: Int(ScreenWidth*3/4-70), height: 40))
            label.text = str
            menuScroll.addSubview(label)
            
            a += 1
        }
    }
    
    
    @objc func userTypeAction() -> Void {
        
        RootController.hideLeftView()
        
        let vc = UserInfoController()
        
        let root : UINavigationController = RootController.shareSingleton.mainVC as! UINavigationController
        root.pushViewController(vc, animated: true)
        
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

// MARK: - userView

extension LeftController {
    
    private
    
    func createUserView() -> Void {
        
    }
}


