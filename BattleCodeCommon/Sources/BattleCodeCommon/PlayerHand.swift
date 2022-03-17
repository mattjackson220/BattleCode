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
        var cardImageName = DeckConstants.DeckThreeCardImageName
        
        if (self.cards.count == 2) {
            cardImageName = DeckConstants.DeckTwoCardImageName
        } else if (self.cards.count == 1) {
            cardImageName = DeckConstants.DeckOneCardImageName
        } else if (self.cards.isEmpty) {
            cardImageName = DeckConstants.EmptyPlayerHandImageName
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
    
    public func getNextCardIndex(currentIndex: Int) -> Int {
        if self.cards.count - 1 == currentIndex {
            return 0
        } else {
            return currentIndex + 1
        }
    }
    
    public func getPreviousCardIndex(currentIndex: Int) -> Int {
        if currentIndex == 0 {
            return self.cards.count - 1
        } else {
            return currentIndex - 1
        }
    }
    
    public func getCard(index: Int, selected: Bool) -> CardObj {
        let card = self.cards[index]
        
        if selected {
            card.showAsSelected()
        }
        
        return card
    }
    
    public func removeCard(index: Int) {
        self.cards.remove(at: index)
    }
}
