import UIKit

class HapticManager {
    static let shared = HapticManager()

    private init() {}

    func impact(style: ImpactStyle) {
        let generator: UIImpactFeedbackGenerator

        switch style {
        case .light:
            generator = UIImpactFeedbackGenerator(style: .light)
        case .medium:
            generator = UIImpactFeedbackGenerator(style: .medium)
        case .heavy:
            generator = UIImpactFeedbackGenerator(style: .heavy)
        }

        generator.prepare()
        generator.impactOccurred()
    }

    func notification(type: NotificationType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()

        switch type {
        case .success:
            generator.notificationOccurred(.success)
        case .error:
            generator.notificationOccurred(.error)
        case .warning:
            generator.notificationOccurred(.warning)
        }
    }

    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }

    enum ImpactStyle {
        case light
        case medium
        case heavy
    }

    enum NotificationType {
        case success
        case error
        case warning
    }
}