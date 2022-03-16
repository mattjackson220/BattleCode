//
//  GameObjects.swift
//  BattleCode iOS
//
//  Created by Matt Jackson on 3/15/22.
//

import Foundation
import SpriteKit

public struct CardConstants {
    static public let TitleName = "cardTitle"
    static public let DecriptionName = "cardDesc"
    static public let CardBackgroundImageName = "cardBackgroundImage"
    static public let WhiteImageName = "whiteSquare"
    static public let FontName = "Chalkduster"
    
    static public let DeckThreeCardImageName = "threeCardDeck"
    static public let DeckTwoCardImageName = "twoCardDeck"
    static public let DeckOneCardImageName = "singleCardDeck"
    static public let DeckNoCardsImageName = "noCardsLeft"
}

public class CardObj: SKShapeNode {
    let height = 400
    let width = 200
    public var cardTitle = ""
    public var cardDescription = ""
    
    private func hideChildren(hide: Bool) {
        self.enumerateChildNodes(withName: CardConstants.TitleName) { node, _ in
            node.isHidden = hide
        }
        self.enumerateChildNodes(withName: CardConstants.DecriptionName) { node, _ in
            node.isHidden = hide
        }
    }
    
    public func showFront() {
        let narrow = SKAction.scaleX(to: 0, duration: 0.25)
        let widen = SKAction.scaleX(to: 1.0, duration: 0.25)
        let clearImage = SKAction.run({
            self.fillTexture = SKTexture.init(imageNamed: CardConstants.WhiteImageName)
            self.hideChildren(hide: false)
        })
        let grow = SKAction.scale(to: 2.0, duration: 0.5)
        let sequence = SKAction.sequence([narrow, clearImage, widen, grow])
        self.run(sequence)
    }
    
    public func showBack() {
        let narrow = SKAction.scaleX(to: 0, duration: 0.25)
        let widen = SKAction.scaleX(to: 1.0, duration: 0.25)
        let addImage = SKAction.run({
            self.fillTexture = SKTexture.init(imageNamed: CardConstants.CardBackgroundImageName)
            self.hideChildren(hide: true)
        })
        let shrink = SKAction.scale(to: 1.0, duration: 0.5)
        let sequence = SKAction.sequence([shrink, narrow, addImage, widen])
        self.run(sequence)
    }
    
    override init () {
        super.init()
        let path = CGMutablePath()
        path.addRect(CGRect(x: -width / 2, y: -height / 2, width: width, height: height))
        self.path = path
        self.lineWidth = 1
        self.fillColor = .white
        self.strokeColor = .white
        self.glowWidth = 0.5
        self.fillTexture = SKTexture.init(imageNamed: CardConstants.CardBackgroundImageName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public func createCard(cardId: String, cardTitle: String, cardDescription: String) -> CardObj {
    let card = CardObj()
    card.name = cardId
    card.cardDescription = cardDescription
    card.cardTitle = cardTitle
    
    let cardLabel = SKLabelNode(fontNamed: CardConstants.FontName)
    cardLabel.text = card.cardTitle
    cardLabel.name = CardConstants.TitleName
    cardLabel.fontSize = 30
    cardLabel.fontColor = SKColor.green
    cardLabel.position = CGPoint(x: card.frame.midX, y: card.frame.midY + 50)
    cardLabel.isHidden = true
    card.addChild(cardLabel)
    
    let cardDescription = SKLabelNode(fontNamed: CardConstants.FontName)
    cardDescription.text = card.cardDescription
    cardDescription.name = CardConstants.DecriptionName
    cardDescription.fontSize = 10
    cardDescription.fontColor = SKColor.green
    cardDescription.position = CGPoint(x: card.frame.midX, y: card.frame.midY)
    cardDescription.isHidden = true
    card.addChild(cardDescription)
    
    return card
}

public class DeckObj: SKShapeNode {
    
    let height = 400
    let width = 200
    
    var cards = Array<CardObj>()
    var discard = Array<CardObj>()
    
    override init() {
        super.init()
        self.name = "deck"
        let path = CGMutablePath()
        path.addRect(CGRect(x: -width / 2, y: -height / 2, width: width, height: height))
        self.path = path
        self.strokeColor = .clear
        self.fillColor = .white
        cards.append(createCard(cardId: "1", cardTitle: "You Lose", cardDescription: "Better luck next time!"))
        cards.append(createCard(cardId: "2", cardTitle: "You Win", cardDescription: "Congratulations!  Way to go!"))
        self.reshuffleDeck()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getTopCard() -> CardObj? {
        if self.cards.count == 0 {
            self.reshuffleDeck()
        }
        if self.cards.count == 0 {
            return nil
        }
        let card = self.cards[0]
        self.cards.remove(at: 0)
        self.determineFillTexture()
        return card
    }
    
    public func reshuffleDeck() {
        self.cards.append(contentsOf: self.discard)
        self.cards.shuffle()
        self.determineFillTexture()
    }
    
    private func determineFillTexture() {
        var cardImageName = CardConstants.DeckThreeCardImageName
        
        if (self.cards.count == 2) {
            cardImageName = CardConstants.DeckTwoCardImageName
        } else if (self.cards.count == 1) {
            cardImageName = CardConstants.DeckOneCardImageName
        } else if (self.cards.isEmpty) {
            cardImageName = CardConstants.DeckNoCardsImageName
        }
        
        self.fillTexture = SKTexture.init(imageNamed: cardImageName)
    }
}
