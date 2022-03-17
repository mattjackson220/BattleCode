//
//  File.swift
//  
//
//  Created by Matthew Creehan on 3/17/22.
//

import Foundation
import SpriteKit

public class DiscardObj: SKShapeNode {
    
    let height = 200
    let width = 100
    
    public var cards = Array<CardObj>()
    
    override init() {
        super.init()
        self.name = DeckConstants.DiscardName
        
        let path = CGMutablePath()
        
        let startingX = -Int(UIScreen.main.bounds.width / 2)
        let startingY = Int(UIScreen.main.bounds.height / 2) - self.height
        path.addRect(CGRect(x: startingX, y: startingY, width: self.width, height: self.height))
        
        self.path = path
        self.strokeColor = .clear
        self.fillColor = .white
        
        self.determineFillTexture()
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
            cardImageName = DeckConstants.DeckNoCardsImageName
        }
        
        self.fillTexture = SKTexture.init(imageNamed: cardImageName)
    }
}
