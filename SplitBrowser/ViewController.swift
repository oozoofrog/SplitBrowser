//
//  ViewController.swift
//  SplitBrowser
//
//  Created by mayjay on 2016. 11. 27..
//  Copyright © 2016년 Kwanghoon Choi. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentsView: UIView!
    
    @IBOutlet var browsers: [UIView]!
    @IBOutlet var browserHeights: [NSLayoutConstraint]!
    
    @IBOutlet weak var splitter: UIView!
    @IBOutlet var splitGesture: UIPinchGestureRecognizer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pinch(_ sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .began:
            break
        case .changed:
            print(sender.location(in: sender.view))
            break
        case .ended:
            break
        default: break
        }
    }

    
}

