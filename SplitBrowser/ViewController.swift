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

