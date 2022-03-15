//
//  GameViewController.swift
//  BattleCode iOS
//
//  Created by Matt Jackson on 3/14/22.
//

import UIKit

class StartViewController: UIViewController {
    var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0...500 {
            let randomIntX = Int.random(in: 10..<Int(self.view.frame.size.width-10))
            let randomIntY = Int.random(in: 10..<Int(self.view.frame.size.height-10))

            let label = UILabel(frame: CGRect(x: randomIntX, y: randomIntY, width: 200, height: 30))
            label.textColor = .green
            label.textAlignment = .center
            label.text = String(Int.random(in: 0..<2))
            label.sizeToFit()
            
            label.alpha = 0

            self.view.addSubview(label)
            self.view.sendSubviewToBack(label)
            let delay = Double.random(in: 0..<5)
            UIView.animate(withDuration: 1.0, delay: TimeInterval(delay), options: UIView.AnimationOptions.curveEaseInOut, animations: {
            label.alpha = 1.0
            }, completion: {_ in
            UIView.animate(withDuration: 1.0, delay: delay + 1.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            label.alpha = 0.0
            })
            })
        }
    }
    
}

extension UIView {


    func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 3.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
        self.alpha = 1.0
        }, completion: completion)  }

    func fadeOut(duration: TimeInterval = 1.0, delay: TimeInterval = 5.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
        self.alpha = 0.0
        }, completion: completion)
}

}
