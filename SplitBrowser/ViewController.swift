//
//  ViewController.swift
//  SplitBrowser
//
//  Created by mayjay on 2016. 11. 27..
//  Copyright © 2016년 Kwanghoon Choi. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var splitter: UIView!
    @IBOutlet weak var spilitHeight: NSLayoutConstraint!

    
    @IBOutlet var browsers: [WKWebView]!
    
    @IBOutlet var browserHeights: [NSLayoutConstraint]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

