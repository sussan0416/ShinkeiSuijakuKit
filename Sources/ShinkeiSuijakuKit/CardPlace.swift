import Foundation

/// カードが置かれている場所
public class CardPlace: ObservableObject, Hashable, CustomDebugStringConvertible {
    public static func == (lhs: CardPlace, rhs: CardPlace) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(isOpen)
        hasher.combine(card?.id)
    }

    private let id: UUID
    private(set) var card: Card? {
        didSet {
            hasCard = card != nil
        }
    }

    @Published public private(set) var isOpen: Bool

    @Published public private(set) var hasCard: Bool

    init(card: Card) {
        self.id = UUID()
        self.card = card
        self.hasCard = true
        self.isOpen = false
    }

    func open() throws -> Card {
        guard let card else {
            throw NoCardOnPlaceError()
        }

        isOpen = true

        return card
    }

    func close() {
        isOpen = false
    }

    func pickCard() -> Card {
        let card = card!
        self.card = nil

        return card
    }

    public var debugDescription: String {
        if let card {
            if isOpen {
                return card.debugDescription
            } else {
                return "[?]"
            }
        }

        return "[ ]"
    }
}
