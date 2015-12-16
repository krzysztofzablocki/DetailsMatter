import Foundation
import KZPlayground

class KZPPlaygroundExample : KZPPlayground, KZPActivePlayground, UIScrollViewDelegate
{
    var fold: UIView!
    var check: UISwitch!
    var container: UIView!
    var button: UIButton!

    override func run() {
        
        var perspectiveTransform = CATransform3DIdentity
        perspectiveTransform.m34 = 1 / -900
        self.worksheetView.layer.sublayerTransform = perspectiveTransform
        runViewScene("RememberView")
    }
    
    func runViewScene(nibName: String) {
        guard let rememberView = UINib(nibName: nibName, bundle: nil).instantiateWithOwner(nil, options: nil)[0] as? RememberView else {
            print("Oh no, something went wrong with \(nibName) loading")
            return
        }
        
        rememberView.center = CGPointMake(CGRectGetMidX(self.worksheetView.bounds), CGRectGetMidY(self.worksheetView.bounds))
        self.worksheetView.addSubview(rememberView)
    }
}