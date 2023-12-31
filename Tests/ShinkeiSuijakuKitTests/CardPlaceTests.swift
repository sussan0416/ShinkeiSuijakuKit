//
//  CardPlaceTests.swift
//  
//
//  Created by 鈴木孝宏 on 2023/08/09.
//
@testable import ShinkeiSuijakuKit
import XCTest

final class CardPlaceTests: XCTestCase {
    func test_CardPlaceの状態が変わるとハッシュ値が変わっていること() {
        let card = Card(label: "A", group: .init(identifier: "A"))
        let place = CardPlace(card: card)
        let originalHashValue = place.hashValue

        let _ = try! place.open()

        let afterOpenedHashValue = place.hashValue

        XCTAssertNotEqual(originalHashValue, afterOpenedHashValue)

        let pickedCard = place.pickCard()

        XCTAssertNotNil(pickedCard)

        let afterPickedHashValue = place.hashValue

        XCTAssertNotEqual(originalHashValue, afterPickedHashValue)
        XCTAssertNotEqual(afterOpenedHashValue, afterPickedHashValue)
    }

    func test_Cardがなくなった場所を開こうとするとエラー_isOpenは変化なし() {
        let card = Card(label: "A", group: .init(identifier: "A"))
        let place = CardPlace(card: card)

        let _ = place.pickCard()

        XCTAssertThrowsError(try place.open())
        XCTAssertFalse(place.isOpen)
    }

    func test_初期化時はhasCardはtrue_pick後はhasCardはfalse() {
        let card = Card(label: "A", group: .init(identifier: "A"))
        let place = CardPlace(card: card)

        XCTAssertTrue(place.hasCard)

        let _ = place.pickCard()

        XCTAssertFalse(place.hasCard)
    }
}
