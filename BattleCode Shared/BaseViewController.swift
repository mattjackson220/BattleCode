//
//  BaseViewController.swift
//  BattleCode iOS
//
//  Created by Matthew Creehan on 3/15/22.
//

import UIKit


class BaseViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
            
            UIView.animate(
                withDuration: 1.0,
                delay: TimeInterval(delay),
                options: UIView.AnimationOptions.curveEaseIn,
                animations: { label.alpha = 1.0 },
                completion: {
                    _ in UIView.animate(
                        withDuration: 1.0,
                        delay: delay + 1.0,
                        options: UIView.AnimationOptions.curveEaseOut,
                        animations: { label.alpha = 0.0 }
                    )
                }
            )
        }
    }
}
