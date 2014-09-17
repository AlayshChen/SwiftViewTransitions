//
//  ViewController.swift
//  SwiftViewTransitions
//
//  Created by Alaysh on 8/14/14.
//  Copyright (c) 2014 Alaysh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var previousConstraints: [AnyObject]!
    @IBOutlet weak var frontView: UIImageView!
    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var fadeButtonItem: UIBarButtonItem!
    @IBOutlet weak var flipButtonItem: UIBarButtonItem!
    @IBOutlet weak var bounceButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(frontView)
        previousConstraints = constrain(frontView, toMatchWithSuperview: view)
        let buttonItems = [fadeButtonItem, flipButtonItem, bounceButtonItem]
        toolbarItems = buttonItems
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func constrain(subview: UIView, toMatchWithSuperview superview: UIView) -> [AnyObject]! {
        subview.setTranslatesAutoresizingMaskIntoConstraints(false)
        let dic = ["subview": subview]
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[subview]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: dic)
        let constraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|[subview]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: dic).last as NSLayoutConstraint
        constraints.append(constraint)
        superview.addConstraints(constraints)
        return constraints
    }
    
    @IBAction func fadeAction(sender: AnyObject) {
        performTransition(UIViewAnimationOptions.TransitionCrossDissolve)
    }
    
    @IBAction func flipAction(sender: AnyObject) {
        if frontView.superview != nil {
            performTransition(UIViewAnimationOptions.TransitionFlipFromLeft)
        }
        else {
            performTransition(UIViewAnimationOptions.TransitionFlipFromRight)
        }
    }
    
    @IBAction func bounceAction(sender: AnyObject) {
        navigationController!.toolbar.userInteractionEnabled = false
        var fromView, toView: UIView
        if frontView.superview != nil {
            fromView = frontView
            toView = backView
        }
        else {
            fromView = backView
            toView = frontView
        }
        var startFrame = view.frame
        var endFrame = view.frame
        startFrame.origin.y -= startFrame.size.height
        endFrame.origin.y = 0
        toView.frame = startFrame
        let constraints = previousConstraints
        view.addSubview(toView)
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            toView.frame = endFrame
            }) { (finished) -> Void in
                if constraints != nil {
                    self.view.removeConstraints(constraints)
                }
                fromView.removeFromSuperview()
                self.navigationController!.toolbar.userInteractionEnabled = true
        }
        previousConstraints = constrain(toView, toMatchWithSuperview: view)
    }
    
    func performTransition(options: UIViewAnimationOptions) {
        navigationController!.toolbar.userInteractionEnabled = false
        var fromView, toView: UIView
        if frontView.superview != nil {
            fromView = frontView
            toView = backView
        }
        else {
            fromView = backView
            toView = frontView
        }
        let constraints = previousConstraints
        UIView.transitionFromView(fromView, toView: toView, duration: 1.0, options: options) { (finished) -> Void in
            if constraints != nil {
                self.view.removeConstraints(constraints)
            }
            self.navigationController!.toolbar.userInteractionEnabled = true
        }
        previousConstraints = constrain(toView, toMatchWithSuperview: view)
    }
}

