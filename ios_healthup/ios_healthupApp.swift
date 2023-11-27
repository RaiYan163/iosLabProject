//
//  ios_healthupApp.swift
//  ios_healthup
//
//  Created by kuet on 5/11/23.
//

import SwiftUI
import FirebaseCore;
import UserNotifications

@main
struct ios_healthupApp: App {
    init() {
            FirebaseApp.configure()
        }
    var body: some Scene {
        WindowGroup {
            ContentView().onAppear(perform: {
                NotificationManager.shared.requestAuthorization()
            })

        }
    }
}
