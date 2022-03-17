//
//  PlayerHand.swift
//  
//
//  Created by Matt Jackson on 3/17/22.
//

import Foundation
import SpriteKit

public func createPlayerHand(screenWidth: Int, screenHeight: Int) -> PlayerHandObj {
    let hand = PlayerHandObj()
    let path = CGMutablePath()
    
    let startingX = -(hand.width/2)
    let startingY = -(screenHeight / 2)
    path.addRect(CGRect(x: startingX, y: startingY, width: hand.width, height: hand.height))
    
    hand.path = path
    hand.strokeColor = .clear
    hand.fillColor = .white
    hand.determineFillTexture()
    
    return hand;
}

public class PlayerHandObj: SKShapeNode {
    let height = 200
    let width = 100
    
    var cards = Array<CardObj>()
    
    override init() {
        super.init()
        self.name = CardConstants.PlayerHandName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func determineFillTexture() {
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
    
    public func addCardToDeck(card: CardObj) {
        self.cards.append(card)
    }
    
    public func getTopCard() -> CardObj? {
        if self.cards.count == 0 {
            return nil
        }
        return self.cards[0]
    }
}
