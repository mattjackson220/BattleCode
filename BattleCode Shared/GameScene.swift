//
//  GameScene.swift
//  BattleCode Shared
//
//  Created by Matt Jackson on 3/14/22.
//

import SpriteKit
import UIKit

class GameScene: SKScene {
    
    fileprivate var label : SKLabelNode?
    fileprivate var startButton : SKLabelNode?

    fileprivate var spinnyNode : SKShapeNode?
        
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        scene.scaleMode = .aspectFill
                
        return scene
    }
}
