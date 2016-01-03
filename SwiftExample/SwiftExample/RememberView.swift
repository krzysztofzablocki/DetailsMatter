//
//  RememberView.swift
//  SwiftExample
//
//  Created by Krzysztof Zabłocki on 16/12/15.
//  Copyright © 2015 pixle. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var kz_borderColor: UIColor? {
        get {
            if let colorRef = layer.borderColor {
                return UIColor(CGColor: colorRef)
            }

            return nil
        }
        set {
            layer.borderColor = newValue?.CGColor
        }
    }
}

class RememberView: UIView, UITextFieldDelegate {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var foldView: UIView!
    @IBOutlet weak var submitButton: UIButton!

    @IBOutlet weak var entryField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        var perspectiveTransform = CATransform3DIdentity
        perspectiveTransform.m34 = 1 / -900
        self.layer.sublayerTransform = perspectiveTransform
        entryField.delegate = self
    }

    @IBAction func valueChanges(check: UISwitch) {
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .AllowAnimatedContent, animations: {
            let angle = !check.on ? -90 : 0
            self.foldView.layer.transform = CATransform3DMakeRotation(self.toRadian(angle), 1.0, 0, 0)
            self.layoutStack()
            self.frame.size.height = CGRectGetMaxY(self.submitButton.frame) + 10
        }, completion: nil)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutStack()
    }

    func foldFrame(withTop top: CGFloat) -> CGRect {
        return CGRectMake(headerView.frame.origin.x, top, headerView.bounds.size.width, 80)
    }

    func layoutStack() {
        let margin: CGFloat = 10
        foldView.frame = foldFrame(withTop: CGRectGetMaxY(headerView.frame) - foldView.layer.borderWidth)
        submitButton.frame.origin.y = CGRectGetMaxY(foldView.frame) + margin
    }

    @IBAction func submitPressed(sender: UIButton) {
        if entryField.text?.characters.count > 0 {
            animateButton(sender, toTitle: "Sending...", color: UIColor.grayColor())
            delay(1.5, closure: { () -> () in
                self.animateButton(sender, toTitle: "Sent!", color: UIColor.greenColor())
            })
        } else {
            let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");
            translation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            translation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0]

            let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.y");
            rotation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            rotation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0].map {
                self.toRadian($0)
            }

            let shakeGroup: CAAnimationGroup = CAAnimationGroup()
            shakeGroup.animations = [translation, rotation]
            shakeGroup.duration = 0.6
            self.layer.addAnimation(shakeGroup, forKey: "shakeIt")
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func animateButton(button: UIButton, toTitle title: String, color: UIColor) {
        let transition = CATransition()
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        transition.duration = 0.5
        button.titleLabel?.layer.addAnimation(transition, forKey: kCATransition)
        button.setTitle(title, forState: .Normal)
        button.setTitleColor(color, forState: .Normal)
    }

    func toRadian(value: Int) -> CGFloat {
        return CGFloat(Double(value) / 180.0 * M_PI)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
    }
}
