//
//  GameScene.swift
//  BattleCode Shared
//
//  Created by Matt Jackson on 3/14/22.
//

import UIKit

class NewGameViewController: UIViewController {
    
    @IBOutlet weak var tutorialButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0...200 {
            let randomIntX = Int.random(in: 10..<Int(self.view.frame.size.height-200))
            let randomIntY = Int.random(in: 50..<Int(self.view.frame.size.height-50))

            let label = UILabel(frame: CGRect(x: randomIntX, y: randomIntY, width: 200, height: 30))
            label.textColor = .green
            label.textAlignment = .center
            label.text = String(Int.random(in: 0..<2))
            label.sizeToFit()
            
            label.alpha = 0

            self.view.addSubview(label)
            self.view.sendSubviewToBack(label)
            UIView.animate(withDuration: 3.0, delay: TimeInterval(Int.random(in: 0..<5)), options: UIView.AnimationOptions.curveEaseIn, animations: {
            label.alpha = 1.0
            })
        }
    }
}
