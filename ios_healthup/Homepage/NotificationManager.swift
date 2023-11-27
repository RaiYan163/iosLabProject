import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print("Error: \(error)")
            } else if success {
                print("Permission granted")
            } else {
                print("Permission denied")
            }
        }
    }
    
    func scheduleNotification(medicineName: String, intakeTimes: [Date]) {
        for (index, intakeTime) in intakeTimes.enumerated() {
            let content = UNMutableNotificationContent()
            content.title = "Medicine Reminder"
            content.body = "Time to take your medicine: \(medicineName)"
            content.sound = .default

            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: intakeTime)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

            let requestIdentifier = "\(medicineName)_\(index)"
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                } else {
                    print("Successfully scheduled notification for \(medicineName) at \(intakeTime)")
                }
            }
        }
    }
}
