//
//  Card.swift
//  
//
//  Created by Matt Jackson on 3/17/22.
//

import Foundation
import SpriteKit

public class CardObj: SKSpriteNode {
    public var height = 0
    public var width = 0
    public var xCoordinate = 0
    public var yCoordinate = 0
    public var cardTitle = ""
    public var cardDescription = ""
    public var cardLocation = CardConstants.CardLocation.Deck
    
    private func hideChildren(hide: Bool) {
        self.enumerateChildNodes(withName: CardConstants.DecriptionName) { node, _ in
            node.position = CGPoint(x: node.parent!.frame.midX, y: node.parent!.frame.midY)
            node.zPosition = CGFloat(node.parent!.zPosition + 1)
            node.isHidden = hide
        }
        self.enumerateChildNodes(withName: CardConstants.TitleName) { node, _ in
            node.position = CGPoint(x: node.parent!.frame.midX, y: node.parent!.frame.maxY - 30)
            node.zPosition = CGFloat(node.parent!.zPosition + 3)
            node.isHidden = hide
        }

    }
    
    public func showFront(completion block: @escaping () -> Void) {
        let moveToCenter = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.25)
        let narrow = SKAction.scaleX(to: 0, duration: 0.25)
        let clearImage = SKAction.run({
            self.texture = SKTexture.init(imageNamed: CardConstants.WhiteImageName)
            self.hideChildren(hide: false)
        })
        let widen = SKAction.scaleX(to: 1.0, duration: 0.25)
        let grow = SKAction.scale(to: 4.0, duration: 0.5)
        let sequence = SKAction.sequence([moveToCenter, narrow, clearImage, widen, grow])
        self.run(sequence, completion: block)
    }
    
    public func showBack(completion block: @escaping () -> Void) {
        let narrow = SKAction.scaleX(to: CGFloat(0), duration: 0.25)
        let widen = SKAction.scaleX(to: CGFloat(1.0), duration: 0.25)
        let addImage = SKAction.run({
            self.texture = SKTexture.init(imageNamed: CardConstants.CardBackgroundImageName)
            self.hideChildren(hide: true)
        })
        let shrink = SKAction.scale(to: CGFloat(1.0), duration: 0.5)
        let moveToBottom = SKAction.move(to: CGPoint(x: 0, y: Int(-UIScreen.main.bounds.height / 2) + self.height/2), duration: 0.25)
        let sequence = SKAction.sequence([shrink, narrow, addImage, widen, moveToBottom])
        self.run(sequence, completion: block)
    }
    
    public func discard(completion block: @escaping () -> Void) {
        let narrow = SKAction.scaleX(to: CGFloat(0), duration: 0.25)
        let widen = SKAction.scaleX(to: CGFloat(1.0), duration: 0.25)
        let addImage = SKAction.run({
            self.texture = SKTexture.init(imageNamed: CardConstants.CardBackgroundImageName)
            self.hideChildren(hide: true)
        })
        let shrink = SKAction.scale(to: CGFloat(1.0), duration: 0.5)
        
        let newX = -Int(UIScreen.main.bounds.width / 2) + (self.width / 2)
        let newY = Int(UIScreen.main.bounds.height / 2) - (self.height / 2)
        let moveToDiscard = SKAction.move(to: CGPoint(x: newX, y: newY), duration: 0.25)
                                          
        let sequence = SKAction.sequence([shrink, narrow, addImage, widen, moveToDiscard])
        self.run(sequence, completion: block)
    }
    
    public func swipeOffScreen(direction: UISwipeGestureRecognizer.Direction, completion block: @escaping () -> Void) {
        var directionMod = 1
        if direction == .left {
            directionMod = -1
        }
        let move = SKAction.moveBy(x: CGFloat(directionMod) * (UIScreen.main.bounds.width + CGFloat(self.width)), y: 0, duration: 0.5)
        self.run(move, completion: block)
    }
    
    public func swipeOnScreen(direction: UISwipeGestureRecognizer.Direction) {
        var directionMod = -1
        if direction == .left {
            directionMod = 1
        }
        
        self.position = CGPoint(x: CGFloat(directionMod) * (UIScreen.main.bounds.width + CGFloat(self.width)), y: 0)

        let move = SKAction.moveTo(x: CGFloat(0), duration: 0.5)
        self.run(move)
    }
    
    public func wiggleCard(direction: UISwipeGestureRecognizer.Direction) {
        var directionMod = 1
        if direction == .left {
            directionMod = -1
        }
        
        let moveOut = SKAction.moveTo(x: CGFloat(directionMod) * CGFloat(self.width), duration: 0.25)
        let moveBack = SKAction.moveTo(x: CGFloat(0), duration: 0.25)
        let sequence = SKAction.sequence([moveOut, moveBack])
        self.run(sequence)
    }
    
    public func showAsSelected() {
        self.texture = SKTexture.init(imageNamed: CardConstants.WhiteImageName)
        self.position = CGPoint(x: 0,y: 0)
        self.hideChildren(hide: false)
        if #available(iOS 10.0, *) {
            self.scale(to: CGSize(width: 4 * self.width, height: 4 * self.height))
        } else {
            // Fallback on earlier versions
            return
        }
    }
    
    public func returnToLocation(x: Int, y: Int) {
        self.texture = SKTexture.init(imageNamed: CardConstants.CardBackgroundImageName)
        self.position = CGPoint(x: x, y: y)
        self.hideChildren(hide: true)
        if #available(iOS 10.0, *) {
            self.scale(to: CGSize(width: self.width, height: self.height))
        } else {
            // Fallback on earlier versions
            return
        }
    }

}

@available(iOS 11.0, *)
public func createCard(cardId: String, cardTitle: String, cardDescription: String, deck: DeckObj) -> CardObj {
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
    cardLabel.numberOfLines = 2
    cardLabel.preferredMaxLayoutWidth = CGFloat(card.width - 10)
    cardLabel.text = card.cardTitle
    cardLabel.name = CardConstants.TitleName
    cardLabel.fontSize = 10
    cardLabel.fontColor = SKColor.green
    cardLabel.position = CGPoint(x: card.frame.midX, y: card.frame.midY + 50)
    cardLabel.isHidden = true
    cardLabel.zPosition = card.zPosition + 1
    card.addChild(cardLabel)
    
    let cardDescription = SKLabelNode(fontNamed: CardConstants.FontName)
    cardDescription.numberOfLines = 10
    cardDescription.preferredMaxLayoutWidth = CGFloat(card.width - 10)
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
