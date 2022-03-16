public struct CardInfo {
    let cardId, cardTitle, cardDescription: String
    
    init(cardId: String, cardTitle: String, cardDescription: String) {
        self.cardId = cardId
        self.cardTitle = cardTitle
        self.cardDescription = cardDescription
    }
}

func getCardInfos() -> Array<CardInfo> {
        return [CardInfo(cardId: "1", cardTitle: "You Lose", cardDescription: "Better luck next time!"),
                CardInfo(cardId: "2", cardTitle: "You Win", cardDescription: "Congratulations!  Way to go!")]
}
