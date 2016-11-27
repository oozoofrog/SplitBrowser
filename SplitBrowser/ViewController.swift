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
    
    var showIndex: Int = 1
    
    lazy var webViews: [WKWebView] = []
    @IBOutlet weak var webSearchBar: UISearchBar!
    
    @IBOutlet weak var splitter: UIView!
    @IBOutlet var splitGesture: UIPinchGestureRecognizer!
    
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
            print(value)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.browserHeights.enumerated().forEach{
            index, height in
            if index == self.showIndex {
                height.constant = self.scrollView.bounds.height - self.splitter.bounds.size.height
            } else {
                height.constant = 0
            }
        }
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

