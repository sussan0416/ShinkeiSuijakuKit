import Foundation

/// カードの組み合わせグループを表す
///
/// 例えば、ハート1・ダイヤ1・スペード1・クローバー1を同じ"1"として識別するために使用する
public struct CardGroup: Equatable {
    public let identifier: String

    public init(identifier: String) {
        self.identifier = identifier
    }
}
