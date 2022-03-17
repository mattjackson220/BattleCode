//
//  GameViewController.swift
//  BattleCode iOS
//
//  Created by Matt Jackson on 3/14/22.
//

import UIKit
import SpriteKit
import GameplayKit
import BattleCodeCommon

class GameViewController: UIViewController {
    
    var selectedCard: CardObj?
    var playerHand = PlayerHandObj(path: CGMutablePath())
    var showingPlayerHand = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene.newGameScene()
        scene.addChild(createDeck(screenWidth: Int(UIScreen.main.bounds.width), screenHeight: Int(UIScreen.main.bounds.height)))
        let playerHand = createPlayerHand(screenWidth: Int(UIScreen.main.bounds.width), screenHeight: Int(UIScreen.main.bounds.height))
        self.playerHand = playerHand
        scene.addChild(playerHand)

        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .up
        self.view.addGestureRecognizer(swipeDown)
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeUp.direction = .down
        self.view.addGestureRecognizer(swipeUp)
        
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
        if self.selectedCard == nil {
            scene.enumerateChildNodes(withName: CardConstants.DeckName) { node, _ in
                // do something with node
                if let p = (node as! SKShapeNode).path {
                    if p.contains(touchPosition) {
                        let deck = node as! DeckObj
                        let card = deck.getTopCard()
                    
                        if card != nil {
                            scene.addChild(card!)

                            card!.showFront()
                            self.selectedCard = card!
                        }
                    }
                }
            }
            scene.enumerateChildNodes(withName: CardConstants.PlayerHandName) { node, _ in
                // do something with node
                if let p = (node as! SKShapeNode).path {
                    if p.contains(touchPosition) {
                        let hand = node as! PlayerHandObj
                        let card = hand.getTopCard()
                    
                        if card != nil {
                            scene.addChild(card!)

                            card!.showFront()
                            self.selectedCard = card!
                            self.showingPlayerHand = true
                        }
                    }
                }
            }
        } else if !showingPlayerHand {
            scene.enumerateChildNodes(withName: (self.selectedCard?.name)!) { node, _ in
                let scaledPath = CGPath(rect: CGRect(x: node.frame.minX, y: node.frame.minY, width: node.frame.width, height: node.frame.height), transform: nil)
                if scaledPath.contains(touchPosition) {
                    let card = node as! CardObj
                    card.showBack(completion: {self.addCardToPlayerHand(card: card)})
                }
            }
        }
    }
    
    func addCardToPlayerHand(card: CardObj) {
        self.selectedCard = nil
        self.playerHand.addCardToDeck(card: card)
        self.playerHand.determineFillTexture()
        card.cardLocation = CardConstants.CardLocation.PlayerHand
        card.removeFromParent()
    }
    
    func returnCardToPlayerHand(card: CardObj) {
        self.selectedCard = nil
        self.playerHand.determineFillTexture()
        card.cardLocation = CardConstants.CardLocation.PlayerHand
        card.removeFromParent()
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            if showingPlayerHand {
                switch swipeGesture.direction {
                case .right:
                    print("Swiped right")
                case .left:
                    print("Swiped left")
                case .up:
                    print("Swiped up")
                case .down:
                    print("Swiped down")
                    self.selectedCard!.showBack(completion: {self.returnCardToPlayerHand(card: self.selectedCard!)})
                    self.showingPlayerHand = false
                default:
                    break
                }
            }
        }
    }
}
