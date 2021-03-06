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
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBAction func settingsButtonClick(_ sender: Any) {
        let alert = UIAlertController(title:"Options", message: "Please select an option below:", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Back", style: UIAlertAction.Style.default, handler: {(action) -> Void in
            let mainMenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "mainMenuViewController") as! BaseViewController
            mainMenuViewController.modalPresentationStyle = .fullScreen
            self.present(mainMenuViewController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    var selectedCard: CardObj?
    var discard: DiscardObj?
    var playerHand = PlayerHandObj(path: CGMutablePath())
    var showingPlayerHand = false
    var showingDrawnCard = false
    var playerHandIndex = 0
    var inAction = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let scene = GameScene.newGameScene()
        
        let deck = createDeck(screenWidth: Int(UIScreen.main.bounds.width), screenHeight: Int(UIScreen.main.bounds.height))
        self.discard = deck.discard
        scene.addChild(deck)
        scene.addChild(deck.discard)
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
            scene.enumerateChildNodes(withName: DeckConstants.DeckName) { node, _ in
                // do something with node
                if let p = (node as! SKShapeNode).path {
                    if p.contains(touchPosition) {
                        self.inAction = true
                        let deck = node as! DeckObj
                        let card = deck.getTopCard()
                    
                        if card != nil {
                            scene.addChild(card!)

                            card!.showFront(completion: {self.inAction = false})
                            self.selectedCard = card!
                            self.showingDrawnCard = true;
                        }
                    }
                }
            }
            scene.enumerateChildNodes(withName: CardConstants.PlayerHandName) { node, _ in
                // do something with node
                if let p = (node as! SKShapeNode).path {
                    if p.contains(touchPosition) {
                        self.inAction = true
                        let hand = node as! PlayerHandObj
                        let card = hand.getTopCard()
                    
                        if card != nil {
                            scene.addChild(card!)

                            card!.showFront(completion: {self.inAction = false})
                            self.selectedCard = card!
                            self.showingPlayerHand = true
                        }
                    }
                }
            }
        }
    }
    
    func addCardToDiscardPile(card: CardObj) {
        self.selectedCard = nil
        card.cardLocation = CardConstants.CardLocation.Discard
        self.discard!.cards.append(card)
        self.discard!.determineFillTexture()
        self.inAction = false
        card.removeFromParent()
        card.returnToLocation(x: (Int(UIScreen.main.bounds.width) / 2) - card.width, y: Int(UIScreen.main.bounds.height / 2) - card.height)
    }
    
    func addCardToPlayerHand(card: CardObj) {
        self.selectedCard = nil
        self.playerHand.addCardToHand(card: card)
        self.playerHand.determineFillTexture()
        card.cardLocation = CardConstants.CardLocation.PlayerHand
        self.inAction = false
        card.removeFromParent()
    }
    
    func returnCardToPlayerHand(card: CardObj) {
        self.selectedCard = nil
        self.playerHand.determineFillTexture()
        card.cardLocation = CardConstants.CardLocation.PlayerHand
        card.removeFromParent()
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        let scene = (self.view as! SKView).scene!
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            if !self.inAction {
                if showingPlayerHand {
                    self.handlePlayerHandGesture(scene: scene, swipeGesture: swipeGesture)
                } else if showingDrawnCard {
                    self.handleDrawnCardGesture(scene: scene, swipeGesture: swipeGesture)
                }
            }
        }
    }
    
    private func handlePlayerHandGesture(scene: SKScene, swipeGesture: UISwipeGestureRecognizer) {
        self.inAction = true
        switch swipeGesture.direction {
            case .right:
                if self.playerHand.getCardCount() > 1 {
                    self.playerHandIndex = playerHand.getPreviousCardIndex(currentIndex: playerHandIndex)
                    let newCard = self.playerHand.getCard(index: playerHandIndex, selected: true)
                    scene.enumerateChildNodes(withName: (self.selectedCard?.name)!) { node, _ in
                        let oldCard = node as! CardObj
                        oldCard.swipeOffScreen(direction: .right, completion: {
                            oldCard.returnToLocation(x: 0, y: Int(self.playerHand.frame.minY))
                            oldCard.removeFromParent()
                        })
                        scene.addChild(newCard)
                        self.selectedCard = newCard
                        newCard.swipeOnScreen(direction: .right)
                    }
                } else if self.playerHand.getCardCount() == 1 {
                    scene.enumerateChildNodes(withName: (self.selectedCard?.name)!) { node, _ in
                        let oldCard = node as! CardObj
                        oldCard.wiggleCard(direction: .right)
                    }
                }
            case .left:
                if self.playerHand.getCardCount() > 1 {
                    self.playerHandIndex = playerHand.getNextCardIndex(currentIndex: playerHandIndex)
                    let newCard = self.playerHand.getCard(index: playerHandIndex, selected: true)
                    scene.enumerateChildNodes(withName: (self.selectedCard?.name)!) { node, _ in
                        let oldCard = node as! CardObj
                        oldCard.swipeOffScreen(direction: .left, completion: {
                            oldCard.returnToLocation(x: 0, y: Int(self.playerHand.frame.minY))
                            oldCard.removeFromParent()
                        })
                        scene.addChild(newCard)
                        self.selectedCard = newCard
                        newCard.swipeOnScreen(direction: .left)
                    }
                } else if self.playerHand.getCardCount() == 1 {
                   scene.enumerateChildNodes(withName: (self.selectedCard?.name)!) { node, _ in
                       let oldCard = node as! CardObj
                       oldCard.wiggleCard(direction: .left)
                   }
               }

            case .up:
                self.inAction = true
                self.selectedCard?.discard(completion: {
                    self.addCardToDiscardPile(card: self.selectedCard!)
                    self.playerHand.removeCard(index: self.playerHandIndex)
                    self.playerHand.determineFillTexture()
                    self.playerHandIndex = 0
                    self.showingPlayerHand = false
                    self.inAction = false
                })
            case .down:
                self.selectedCard?.showBack(completion: {self.returnCardToPlayerHand(card: self.selectedCard!)})
                self.showingPlayerHand = false
            default:
                break
        }
        self.inAction = false
    }
    
    private func handleDrawnCardGesture(scene: SKScene, swipeGesture: UISwipeGestureRecognizer) {
        switch swipeGesture.direction {
            case .up:
                self.inAction = true
                self.selectedCard?.discard(completion: {
                    self.addCardToDiscardPile(card: self.selectedCard!)
                    self.showingDrawnCard = false
                    self.inAction = false
                })
            case .down:
                self.inAction = true
                self.selectedCard?.showBack(completion: {
                    self.addCardToPlayerHand(card: self.selectedCard!)
                    self.showingDrawnCard = false
                    self.inAction = false
                })
            default:
                break
        }
    }
}
