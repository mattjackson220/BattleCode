//
//  Variables.swift
//  
//
//  Created by Matt Jackson on 3/17/22.
//

import Foundation

public struct CardConstants {
    static public let TitleName = "cardTitle"
    static public let DecriptionName = "cardDesc"
    static public let CardBackgroundImageName = "cardBackgroundImage"
    static public let WhiteImageName = "whiteSquare"
    static public let FontName = "Chalkduster"
    static public let PlayerHandName = "playerHand"
    
    public enum CardLocation {
        case PlayerHand
        case OpponentHand
        case Deck
        case Discard
    }
}

public struct DeckConstants {
    static public let DeckThreeCardImageName = "threeCardDeck"
    static public let DeckTwoCardImageName = "twoCardDeck"
    static public let DeckOneCardImageName = "singleCardDeck"
    static public let DeckNoCardsImageName = "noCardsLeft"
    
    static public let DeckName = "deck"
    static public let DiscardName = "discard"
}
