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
    static public let BackgroundImageName = "backgroundImage"
    static public let WhiteImageName = "whiteSquare"
    static public let FontName = "Chalkduster"
}

public class CardObj: SKShapeNode {
    let height = 400
    let width = 200
    public var cardTitle = ""
    public var cardDescription = ""
    
    override init () {
        super.init()
        let path = CGMutablePath()
        path.addRect(CGRect(x: -width / 2, y: -height / 2, width: width, height: height))
        self.path = path
        self.lineWidth = 1
        self.fillColor = .white
        self.strokeColor = .black
        self.glowWidth = 0.5
        self.fillTexture = SKTexture.init(imageNamed: CardConstants.BackgroundImageName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public func createCard(cardTitle: String, cardDescription: String) -> CardObj {
    let card = CardObj()
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
