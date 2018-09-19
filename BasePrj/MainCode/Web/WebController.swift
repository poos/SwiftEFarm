//
//  WebController.swift
//  EFarmSwift
//
//  Created by n369 on 2017/9/1.
//  Copyright © 2017年 Shown. All rights reserved.
//

import UIKit
import WebKit

class WebController: UIViewController {
    
    var model : HomeModel? = HomeModel() {
        didSet {
            var url = ""
            
            let typeStr = model?.type
            if (typeStr == ModelType.product) {
                url = WebProduct
            } else if (typeStr == ModelType.productNews) {
                url = WebProductNews
            } else if (typeStr == ModelType.productCases) {
                url = WebProductCases
            } else if (typeStr == ModelType.productVideo) {
                url = WebProductVideo
            } else if (typeStr == ModelType.farmNews) {
                url = WebFarmNews
            }
            url = url.appendingFormat("%d", (model?.id)!)
            
            self.webView.load(URLRequest.init(url: URL.init(string: url)!))
        }
    }
    
    
    var newModel : SearchResultModel?  {
        didSet {
            var url = WebProductNews
            url = url.appendingFormat("%d", (newModel?.id)!)
            
            self.webView.load(URLRequest.init(url: URL.init(string: url)!))
        }
    }
    
    let webView : WKWebView = {
        let web = WKWebView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        return web
    }()
    
    
    fileprivate let active : UIActivityIndicatorView = {
        let act : UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        act.frame = CGRect.init(x: ScreenWidth/2 - 20, y: ScreenHeight/2 - 20, width: 40, height: 40)
        return act
    }()
    
    //直接初始化时候self还没有,会导致没法绑定方法 ,所以在viewdidload初始化
    fileprivate var backBtn : UIBarButtonItem = UIBarButtonItem()
    fileprivate var closeBtn : UIBarButtonItem = UIBarButtonItem()
    
    //MARK: - actions
    
    @objc func closeBtnAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func backBtnAction() -> Void {
        if (self.webView.canGoBack) {
            self.webView.goBack()
            self.navigationItem.leftBarButtonItems = [backBtn, closeBtn]
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    
    //MARK: - life
    override func viewDidLoad() {
        super.viewDidLoad()
        self.active.startAnimating()
        
        let view = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 44))
        let back = UIImageView.init(frame: CGRect.init(x: -5, y: 13, width: 10.5, height: 18.5))
        back.image = UIImage.init(named: "back_icon")
        view.addSubview(back)
        let label = UILabel.init(frame: CGRect.init(x: 10, y: 0, width: 40, height: 44))
        label.text = "返回"
        label.textColor = TitleColor
        label.font = UIFont.systemFont(ofSize: 17)
        view.addTarget(self, action: #selector(WebController.backBtnAction), for: UIControlEvents.touchUpInside)
        view.addSubview(label)
        backBtn = UIBarButtonItem.init(customView: view)
        
        let labelShut = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 44))
        labelShut.setTitle("关闭", for: UIControlState.normal)
        labelShut.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        labelShut.setTitleColor(TitleColor, for: UIControlState.normal)
        labelShut.addTarget(self, action: #selector(WebController.closeBtnAction), for: UIControlEvents.touchUpInside)
        closeBtn = UIBarButtonItem.init(customView: labelShut)
        
        self.navigationItem.leftBarButtonItem = backBtn
//        self.navigationItem.leftBarButtonItem = nil
        
        
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        self.view.addSubview(webView)
        
        self.view.addSubview(active)
        
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        
        
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


//MARK: - webDel
extension WebController : WKNavigationDelegate {
    
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.active.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.active.stopAnimating()
        
        webView.evaluateJavaScript("document.title") { (title : Any?, err : Error?) in
            self.title = title as? String
        }
        if (webView.canGoBack) {
            self.navigationItem.leftBarButtonItems = [backBtn, closeBtn]
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.active.stopAnimating()
    }
}
