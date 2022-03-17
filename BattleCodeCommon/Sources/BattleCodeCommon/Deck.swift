//
//  Deck.swift
//  BattleCode iOS
//
//  Created by Matt Jackson on 3/15/22.
//

import Foundation
import SpriteKit

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
    
}
