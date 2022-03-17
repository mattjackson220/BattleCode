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
    
    static public let DeckName = "deck"
}

public class CardObj: SKSpriteNode {
    public var height = 0
    public var width = 0
    public var xCoordinate = 0
    public var yCoordinate = 0
    public var cardTitle = ""
    public var cardDescription = ""
    
    private func hideChildren(hide: Bool) {
        self.enumerateChildNodes(withName: CardConstants.TitleName) { node, _ in
            node.position = CGPoint(x: node.parent!.frame.midX, y: node.parent!.frame.maxY - 30)
            node.isHidden = hide
        }
        self.enumerateChildNodes(withName: CardConstants.DecriptionName) { node, _ in
            node.position = CGPoint(x: node.parent!.frame.midX, y: node.parent!.frame.midY)
            node.zPosition = CGFloat(node.parent!.zPosition + 1)
            node.isHidden = hide
        }
    }
    
    public func showFront() {
        let moveToCenter = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 1.0)
        let narrow = SKAction.scaleX(to: 0, duration: 0.25)
        let clearImage = SKAction.run({
            self.texture = SKTexture.init(imageNamed: CardConstants.WhiteImageName)
            self.hideChildren(hide: false)
        })
        let widen = SKAction.scaleX(to: 1.0, duration: 0.25)
        let grow = SKAction.scale(to: 4.0, duration: 0.5)
        let sequence = SKAction.sequence([moveToCenter, narrow, clearImage, widen, grow])
        self.run(sequence)
    }
    
    public func showBack() {
        let narrow = SKAction.scaleX(to: CGFloat(0), duration: 0.25)
        let widen = SKAction.scaleX(to: CGFloat(1.0), duration: 0.25)
        let addImage = SKAction.run({
            self.texture = SKTexture.init(imageNamed: CardConstants.CardBackgroundImageName)
            self.hideChildren(hide: true)
        })
        let shrink = SKAction.scale(to: CGFloat(1.0), duration: 0.5)
        let sequence = SKAction.sequence([shrink, narrow, addImage, widen])
        self.run(sequence, completion: ({
            self.removeFromParent()
        }))
    }
}

private func createCard(cardId: String, cardTitle: String, cardDescription: String, deck: DeckObj) -> CardObj {
    let card = CardObj(texture: SKTexture(imageNamed: CardConstants.CardBackgroundImageName),
                       size: CGSize(width: CGFloat(deck.width), height: CGFloat(deck.height)))
    card.name = cardId
    card.cardDescription = cardDescription
    card.cardTitle = cardTitle

    card.position = CGPoint(x: deck.frame.midX, y: deck.frame.midY)
    card.width = deck.width
    card.height = deck.height
    card.xCoordinate = Int(deck.frame.minX)
    card.yCoordinate = Int(deck.frame.minY)
    
    card.color = .white
    
    let cardLabel = SKLabelNode(fontNamed: CardConstants.FontName)
    cardLabel.text = card.cardTitle
    cardLabel.name = CardConstants.TitleName
    cardLabel.fontSize = 10
    cardLabel.fontColor = SKColor.green
    cardLabel.position = CGPoint(x: card.frame.midX, y: card.frame.midY + 50)
    cardLabel.isHidden = true
    cardLabel.zPosition = card.zPosition + 1
    card.addChild(cardLabel)
    
    let cardDescription = SKLabelNode(fontNamed: CardConstants.FontName)
    cardDescription.text = card.cardDescription
    cardDescription.name = CardConstants.DecriptionName
    cardDescription.fontSize = 5
    cardDescription.fontColor = SKColor.green
    cardDescription.position = CGPoint(x: card.frame.midX, y: card.frame.midY)
    cardDescription.isHidden = true
    cardDescription.zPosition = card.zPosition + 1
    card.addChild(cardDescription)
        
    return card
}

public func createDeck(screenWidth: Int, screenHeight: Int) -> DeckObj {
    let deck = DeckObj()
    let path = CGMutablePath()
    
    let startingX = (screenWidth / 2) - deck.width
    let startingY = (screenHeight / 2) - deck.height
    path.addRect(CGRect(x: startingX, y: startingY, width: deck.width, height: deck.height))
    
    deck.path = path
    deck.strokeColor = .clear
    deck.fillColor = .white
    for cardInfo in getCardInfos() {
        deck.cards.append(createCard(cardId: cardInfo.cardId, cardTitle: cardInfo.cardTitle, cardDescription: cardInfo.cardDescription, deck: deck))
    }
    deck.reshuffleDeck()
    return deck;
}

public class DeckObj: SKShapeNode {
    
    let height = 200
    let width = 100
    
    var cards = Array<CardObj>()
    var discard = Array<CardObj>()
    
    override init() {
        super.init()
        self.name = CardConstants.DeckName
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
