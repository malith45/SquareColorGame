import Foundation

class HapticManager {
    static let shared = HapticManager()

    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    func success() {
        notification(type: .success)
    }

    func error() {
        notification(type: .error)
    }

    func warning() {
        notification(type: .warning)
    }
}