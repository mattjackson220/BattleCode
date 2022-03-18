//
//  GameViewController.swift
//  BattleCode macOS
//
//  Created by Matt Jackson on 3/14/22.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {

    override func viewDidLoad() {
        @IBOutlet weak var settingsButton: UIImageView!
        super.viewDidLoad()
        
        let scene = GameScene.newGameScene()
        
        // Present the scene
        let skView = self.view as! SKView
        @IBOutlet weak var settingsButton: UIButton!
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

}

