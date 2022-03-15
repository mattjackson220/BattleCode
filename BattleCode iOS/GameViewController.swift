//
//  GameViewController.swift
//  BattleCode iOS
//
//  Created by Matt Jackson on 3/14/22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene.newGameScene()

        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else {
//         return
//        }
//        let scene = (self.view as! SKView).scene!
//        let touchPosition = touch.location(in: scene)
//        let touchedNodes = nodes(at: touchPosition)
//        for node in touchedNodes {
//            if let mynode = node as? SKShapeNode, node.name == "triangle" {
//                //stuff here
//                mynode.fillColor = .orange //...
//            }
//        }
//
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let scene = (self.view as! SKView).scene!
        let touchPosition = touch!.location(in: scene)
        scene.enumerateChildNodes(withName: "card1") { node, _ in
            // do something with node
            if let p = (node as! SKShapeNode).path {
                if p.contains(touchPosition) {
                    let card = node as! SKShapeNode
                    
                    let xScale = card.xScale
                    
                    if xScale == 1 {
                        let narrow = SKAction.scaleX(to: 0, duration: 0.25)
                        let widen = SKAction.scaleX(to: 1.0, duration: 0.25)
                        let clearImage = SKAction.run({
                            card.fillTexture = SKTexture.init(imageNamed:"whiteSquare")
                        })
                        let grow = SKAction.scale(to: 2.0, duration: 0.5)
                        let sequence = SKAction.sequence([narrow, clearImage, widen, grow])
                        card.run(sequence)
                    } else {
                        let narrow = SKAction.scaleX(to: 0, duration: 0.25)
                        let widen = SKAction.scaleX(to: 1.0, duration: 0.25)
                        let addImage = SKAction.run({
                            card.fillTexture = SKTexture.init(imageNamed:"backgroundImage")
                        })
                        let shrink = SKAction.scale(to: 1.0, duration: 0.5)
                        let sequence = SKAction.sequence([shrink, narrow, addImage, widen])
                        card.run(sequence)
                    }
                }
            }
        }
    }
    
}
