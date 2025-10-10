import Foundation

extension Notification.Name {
    static let balanceVisibilityChanged = Notification.Name("BalanceVisibilityChanged")
}

struct BalanceVisibility {
    private static let key = "BalanceVisibility.isHidden"

    static var isHidden: Bool {
        get { UserDefaults.standard.bool(forKey: key) }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
            NotificationCenter.default.post(name: .balanceVisibilityChanged, object: nil, userInfo: ["isHidden": newValue])
        }
    }
}
