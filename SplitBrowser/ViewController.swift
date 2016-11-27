//
//  ViewController.swift
//  SplitBrowser
//
//  Created by mayjay on 2016. 11. 27..
//  Copyright © 2016년 Kwanghoon Choi. All rights reserved.
//

import UIKit
import WebKit
import RxCocoa
import RxSwift

class ViewController: UIViewController, UIScrollViewDelegate, WKNavigationDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentsView: UIView!
    
    @IBOutlet var browsers: [UIView]!
    @IBOutlet var browserHeights: [NSLayoutConstraint]!
    
    var showIndex: Int = 1 {
        willSet {
            switch newValue {
            case 0:
                self.switchLabelItem.title = "translate"
            case 1:
                self.switchLabelItem.title = "web"
            default: break
            }
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.25, animations: {
                    self.browserHeights.enumerated().forEach{
                        index, height in
                        if index == newValue {
                            height.constant = self.scrollView.bounds.height - self.splitter.bounds.size.height - 20
                        } else {
                            height.constant = 20
                        }
                    }
                })
            }
        }
    }
    
    lazy var webViews: [WKWebView] = []
    @IBOutlet weak var webSearchBar: UISearchBar!
    
    @IBOutlet weak var splitter: UIView!
    @IBOutlet var splitGesture: UIPinchGestureRecognizer!
    
    @IBOutlet weak var switchLabelItem: UIBarButtonItem!
    @IBOutlet weak var switchBrowser: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        browserHeights.first?.constant = 0
        
        browsers.forEach{
            view in
            let web = WKWebView(frame: view.bounds)
            web.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.insertSubview(web, at: 0)
        }
        
        if let first = self.browsers.first?.subviews.first as? WKWebView {
            first.load(URLRequest(url: URL(string: "https://translate.google.com")!))
        }
        if let second = self.browsers.first?.subviews.first as? WKWebView {
            second.navigationDelegate = self
        }
        
        let _ = webSearchBar.rx.text.throttle(1, scheduler: MainScheduler.instance)
        .distinctUntilChanged(==)
        .subscribe { (event) in
            guard let event = event.element, let value = event else {
                return
            }
            guard let url = URL(string: value) else {
                return
            }
            second.
        }
        
        
        _ = self.switchBrowser.rx.value.subscribe {
            event in
            self.showIndex = event.element ?? false ? 1 : 0
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.showIndex = self.switchBrowser.isOn ? 1 : 0
    }
    
    @IBAction func switchBrowser(_ sender: UISwitch) {
    }
    
    //MARK:- WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    //MARK:- UIPanGesture
    var beganCenter: CGPoint = CGPoint()
    @IBAction func pan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            self.beganCenter = self.splitter.center
        case .changed:
            let translation = sender.translation(in: sender.view)
            let newCenter = CGPoint(x: self.beganCenter.x, y: self.beganCenter.y + translation.y)
            guard newCenter.y > 20 else {
                return
            }
            self.splitter.center = newCenter
            self.browserHeights.first?.constant = self.splitter.frame.origin.y
        case .ended:
            self.beganCenter = CGPoint()
            break
        default: break
        }
    }

    
}

