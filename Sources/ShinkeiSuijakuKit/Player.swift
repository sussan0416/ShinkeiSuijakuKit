import Foundation

/// プレイヤー
public class Player: Identifiable, Equatable {
    public static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }

    public var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }

    public let name: String
    public var matchedCards: [Card]

    public init(name: String) {
        self.name = name
        self.matchedCards = []
    }

    func takeMatchedCards(_ c1: Card, _ c2: Card) {
        matchedCards.append(contentsOf: [c1, c2])
    }

    func pickCard(from place: CardPlace) {
        let card = place.pickCard()
        matchedCards.append(card)
    }
}
