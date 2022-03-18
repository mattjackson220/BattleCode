public struct CardInfo {
    let cardId, cardTitle, cardDescription: String
    
    init(cardId: String, cardTitle: String, cardDescription: String) {
        self.cardId = cardId
        self.cardTitle = cardTitle
        self.cardDescription = cardDescription
    }
}

func getCardInfos() -> Array<CardInfo> {
        return [
            CardInfo(cardId: "1", cardTitle: "You Lose", cardDescription: "Better luck next time!"),
            CardInfo(cardId: "2", cardTitle: "You Win", cardDescription: "Congratulations!  Way to go!"),
            CardInfo(cardId: "3", cardTitle: "While Loop", cardDescription: "Loop forever!"),
            CardInfo(cardId: "4", cardTitle: "For Loop", cardDescription: "Loops through for each item in the for loop and performs the action for each loop"),
            CardInfo(cardId: "5", cardTitle: "If Statement", cardDescription: "Conditional statement to determine the next step in the logic"),
            CardInfo(cardId: "6", cardTitle: "Break", cardDescription: "Shut it down")
        ]
}
