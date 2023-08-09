//
//  CardTests.swift
//  
//
//  Created by 鈴木孝宏 on 2023/08/09.
//
@testable import ShinkeiSuijakuKit
import XCTest

final class CardTests: XCTestCase {
    func test_同じグループのカードはマッチ() {
        let group = CardGroup(identifier: "group 1")
        let cardA = Card(label: "A", group: group)
        let cardB = Card(label: "B", group: group)

        XCTAssertTrue(cardA.isMatched(cardB))
    }

    func test_別のグループのカードはアンマッチ() {
        let group1 = CardGroup(identifier: "group 1")
        let group2 = CardGroup(identifier: "group 2")
        let cardA = Card(label: "A", group: group1)
        let cardB = Card(label: "B", group: group2)

        XCTAssertFalse(cardA.isMatched(cardB))
    }
}
