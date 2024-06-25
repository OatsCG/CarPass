//
//  NotificationManager.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-23.
//

import Foundation


class NotificationManager {
    public static var shared: NotificationManager = NotificationManager()
    
    func registerToken() {
        let token: String? = UserDefaults.standard.string(forKey: "userDeviceNotificationToken")
        if let token = token {
            let userid: String? = UserDefaults.standard.string(forKey: "userID")
            if let userid = userid {
                fetchServerEndpoint(endpoint: "registerapn?userid=\(userid)&apn=\(token)", fetchHash: UUID(), decodeAs: Bool.self) { (result, returnHash) in
                    switch result {
                    case .success(let data):
                        if data == true {
                            UserDefaults.standard.setValue(true, forKey: "notificationsEnabled")
                        }
                    case .failure(_):
                        print("error registering key")
                    }
                }
            }
        }
    }
}


import UIKit
import UserNotifications


class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            guard granted else { return }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert device token to string
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        // Send the device token to your server
        sendDeviceTokenToServer(token)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }

    // Handle notification when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner])
    }
}

func sendDeviceTokenToServer(_ token: String) {
    UserDefaults.standard.setValue(token, forKey: "userDeviceNotificationToken")
    NotificationManager.shared.registerToken()
}
