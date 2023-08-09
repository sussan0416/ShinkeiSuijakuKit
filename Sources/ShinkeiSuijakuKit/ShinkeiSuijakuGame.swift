import Foundation

/// 神経衰弱ゲーム
public class ShinkeiSuijakuGame {
    public let players: [Player]
    public private(set) var cards: [Card]
    public private(set) var cardPlaces: [CardPlace]

    public init(players: [Player], cards: [Card]) {
        self.players = players
        self.cards = cards
        self.cardPlaces = []
    }

    // MARK: - Begin a game

    public func start() -> [CardPlace] {
        cards.shuffle()

        cards.forEach { c in
            cardPlaces.append(CardPlace(card: c))
        }

        return cardPlaces
    }

    public func start(salt: inout some RandomNumberGenerator) -> [CardPlace] {
        cards.shuffle(using: &salt)

        layoutCards()

        return cardPlaces
    }

    private func layoutCards() {
        cards.forEach { c in
            cardPlaces.append(CardPlace(card: c))
        }
    }

    // MARK: Start a turn

    private var currentPlayer: Player? = nil
    private var shouldChangePlayer = true

    public func startTurn() throws -> Player {
        closeAllCards()

        if isGameOver() {
            throw GameOverError()
        }

        return getNextTurnPlayer()
    }

    private func getNextTurnPlayer() -> Player {
        defer {
            shouldChangePlayer = false
        }

        guard let currentPlayer else {
            self.currentPlayer = players.first
            return players.first!
        }

        if !shouldChangePlayer {
            return currentPlayer
        }

        let index = players.firstIndex(of: currentPlayer)!
        let nextIndex = players.index(after: index)

        guard players.indices.contains(nextIndex) else {
            self.currentPlayer = players.first
            return players.first!
        }

        self.currentPlayer = players[nextIndex]
        return players[nextIndex]
    }

    private func closeAllCards() {
        cardPlaces.forEach { p in
            p.close()
        }
    }

    private func isGameOver() -> Bool {
        cardPlaces.filter({ $0.hasCard }).isEmpty
    }

    // MARK: - Open a card

    public func open(place: CardPlace) throws -> Card {
        guard openedPlaces().count < 2 else {
            throw MultipleAttemptError()
        }

        let card = try place.open()

        return card
    }

    private func openedPlaces() -> [CardPlace] {
        cardPlaces.filter { $0.isOpen }
    }

    // MARK: - End a turn

    public func endTurn() throws -> TurnResult {
        guard let currentPlayer else {
            throw NoPlayerError()
        }

        guard openedPlaces().count == 2 else {
            throw NoOpenedPlacesError()
        }

        if openedCardsAreMatched() {
            openedPlaces().forEach { place in
                currentPlayer.pickCard(from: place)
            }
            return .matched
        }

        shouldChangePlayer = true
        return .unmatched
    }

    private func openedCardsAreMatched() -> Bool {
        let openedCards = openedPlaces().compactMap { p in p.card }
        let isMatched = openedCards[0].isMatched(openedCards[1])

        return isMatched
    }
}
