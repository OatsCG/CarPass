//
//  NotificationManager.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-23.
//

import Foundation
import UIKit
import UserNotifications


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
                        print("token registered: \(data)")
                    case .failure(_):
                        print("error registering key")
                    }
                }
            }
        }
    }
    
    func registerForPushNotifications() {
        // Implement registration logic
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        print("trying register")
        let appDelegate = UNUserNotificationCenter.current().delegate as! AppDelegate
        appDelegate.registerForPushNotifications()
    }

    func unregisterForPushNotifications() {
        // Implement unregistration logic
        UIApplication.shared.unregisterForRemoteNotifications()
    }
}


class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        self.registerForPushNotifications()
        return true
    }
    
    func registerForPushNotifications() {
        print("IN REGISTER")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            guard granted else { return }
            DispatchQueue.main.async {
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    guard settings.authorizationStatus == .authorized else { return }
                    DispatchQueue.main.async {
                        print("REGISTERING...")
                        UIApplication.shared.registerForRemoteNotifications()
                        print("REGISTERED")
                    }
                }
            }
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("in application didregister")
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
    print("SENDING TO SERVER...")
    UserDefaults.standard.setValue(token, forKey: "userDeviceNotificationToken")
    NotificationManager.shared.registerToken()
}
