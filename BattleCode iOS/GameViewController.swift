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
    
    var selectedCardName = ""
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let scene = (self.view as! SKView).scene!
        let touchPosition = touch!.location(in: scene)
        if self.selectedCardName == "" {
            scene.enumerateChildNodes(withName: CardConstants.DeckName) { node, _ in
                // do something with node
                if let p = (node as! SKShapeNode).path {
                    if p.contains(touchPosition) {
                        let deck = node as! DeckObj
                        let card = deck.getTopCard()
                    
                        if card != nil {
                            scene.addChild(card!)

                            card!.showFront()
                            self.selectedCardName = card!.name!
                        }
                    }
                }
            }
        } else {
            scene.enumerateChildNodes(withName: self.selectedCardName) { node, _ in
                // do something with node
                if let p = (node as! SKShapeNode).path {
                    let newWidth = p.boundingBox.width * node.xScale
                    let newHeight = p.boundingBox.height * node.yScale
                    let newX = -(newWidth/2)
                    let newY = -(newHeight/2)
                    let scaledPath = CGPath(rect: CGRect(x: newX, y: newY, width: newWidth, height: newHeight), transform: nil)
                    if scaledPath.contains(touchPosition) {
                        let card = node as! CardObj
                        card.showBack()
                        self.selectedCardName = ""
                    }
                }
            }
        }
    }
    
}
