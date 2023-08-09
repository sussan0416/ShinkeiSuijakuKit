import XCTest
@testable import ShinkeiSuijakuKit

final class ShinkeiSuijakuGameTests: XCTestCase {
    let players = [
        Player(name: "Player 1"),
        Player(name: "Player 2")
    ]

    let groups: [CardGroup] = [
        CardGroup(identifier: "0"),
        CardGroup(identifier: "1"),
        CardGroup(identifier: "2")
    ]

    lazy var cards: [Card] = [
        Card(label: "0", group: groups[0]),
        Card(label: "0", group: groups[0]),
        Card(label: "1", group: groups[1]),
        Card(label: "1", group: groups[1]),
        Card(label: "2", group: groups[2]),
        Card(label: "2", group: groups[2])
    ]

    var game: ShinkeiSuijakuGame!

    override func setUp() {
        game = ShinkeiSuijakuGame(players: players, cards: cards)
    }

    func test_ゲームを開始したとき_CardPlaceがカードと同じ数だけ用意されている() {
        var salt = FixedSortedSalt()
        let places = game.start(salt: &salt)

        XCTAssertEqual(places.count, cards.count)
    }

    func test_カードをオープンすると_その場所にあるカードが取得できる() {
        var salt = FixedSortedSalt()
        let places = game.start(salt: &salt)
        let _ = try! game.startTurn()

        let card = try! game.open(place: places[0])

        XCTAssertEqual(card, cards[0])
    }

    func test_ターンを切り替えずに3回openするとエラーになる() {
        var salt = FixedSortedSalt()
        let cardPlacees = game.start(salt: &salt)
        let _ = try! game.startTurn()

        let _ = try! game.open(place: cardPlacees[0])
        let _ = try! game.open(place: cardPlacees[2])

        XCTAssertThrowsError(try game.open(place: cardPlacees[4]))
    }

    func test_ターンを切り替えたとき_全てのカードが裏返されていること() {
        var salt = FixedSortedSalt()
        let cardPlaces = game.start(salt: &salt)
        let _ = try! game.startTurn()
        let _ = try! game.open(place: cardPlaces[0])
        let _ = try! game.open(place: cardPlaces[2])
        let _ = try! game.endTurn()
        let _ = try! game.startTurn()

        XCTAssertEqual(cardPlaces.filter({ $0.isOpen }).count, 0)
    }

    func test_プレイヤーが正しく切り替わること() {
        var salt = FixedSortedSalt()
        let cardPlaces = game.start(salt: &salt)

        for p in [players[0], players[1], players[0], players[1]] {
            let firstPlayer = try! game.startTurn()
            XCTAssertEqual(firstPlayer, p)

            let _ = try! game.open(place: cardPlaces[0])
            let _ = try! game.open(place: cardPlaces[2])
            let result = try! game.endTurn()
            XCTAssertEqual(result, .unmatched)
        }
    }

    func test_カードがマッチした時_次のターンもプレイヤーはそのまま() {
        var salt = FixedSortedSalt()
        let cardPlaces = game.start(salt: &salt)
        let currentPlayer = try! game.startTurn()

        let _ = try! game.open(place: cardPlaces[0])
        let _ = try! game.open(place: cardPlaces[1])
        let _ = try! game.endTurn()
        let nextPlayer = try! game.startTurn()

        XCTAssertEqual(nextPlayer, currentPlayer)
    }

    func test_カードがマッチしたとき_プレイヤーはマッチしたカードを持っている() {
        var salt = FixedSortedSalt()
        let cardPlaces = game.start(salt: &salt)
        let currentPlayer = try! game.startTurn()
        let firstCard = try! game.open(place: cardPlaces[0])
        let secondCard = try! game.open(place: cardPlaces[1])
        let _ = try! game.endTurn()

        XCTAssertEqual(currentPlayer.matchedCards, [firstCard, secondCard])
    }

    func test_全てのカードが盤面からなくなったとき_ターンを開始せずエラー() {
        var salt = FixedSortedSalt()
        let cardPlaces = game.start(salt: &salt)

        let combinations = [
            (cardPlaces[0], cardPlaces[1]),
            (cardPlaces[2], cardPlaces[3]),
            (cardPlaces[4], cardPlaces[5])
        ]

        combinations.forEach { p1, p2 in
            let _ = try! game.startTurn()
            let _ = try! game.open(place: p1)
            let _ = try! game.open(place: p2)
            let _ = try! game.endTurn()
        }

        XCTAssertThrowsError(try game.startTurn())
    }
}

final class FixedSortedSalt: RandomNumberGenerator {
    private var number: UInt64 = 0
    func next() -> UInt64 {
        defer {
            number = number + 1
        }

        return number
    }
}
