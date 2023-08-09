/// 2回以上カードを開いたエラー
public struct MultipleAttemptError: Error {}
/// 開かれたカードが2つ未満のエラー
public struct NoOpenedPlacesError: Error {}
/// プレイヤーがいないエラー（ターンが開始していない）
public struct NoPlayerError: Error {}
/// 全てのカードがマッチし、カードが残っていない状態のエラー
public struct GameOverError: Error {}
/// 開こうとした場所にカードがなかった時のエラー
public struct NoCardOnPlaceError: Error {}
