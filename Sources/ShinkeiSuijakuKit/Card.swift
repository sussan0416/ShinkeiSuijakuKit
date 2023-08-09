import Foundation

/// カード
public struct Card: Identifiable, Equatable, CustomDebugStringConvertible {
    public static func == (lhs: Card, rhs: Card) -> Bool {
        lhs.id == rhs.id
    }

    public let id: UUID
    public let label: String
    public let group: CardGroup

    public init(label: String, group: CardGroup) {
        self.id = UUID()
        self.label = label
        self.group = group
    }

    public func isMatched(_ other: Card) -> Bool {
        return self.group == other.group
    }

    public var debugDescription: String {
        "\(label)(\(group.identifier))"
    }
}
