//
//  TactilDetectionApp.swift
//  TactilDetection
//
//  Created by Developer on 30/12/21.
//

import SwiftUI
import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import UserNotificationsUI


class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        getPushNotifications()
        registerForPushNotifications()
        FirebaseApp.initialize()
        FirebaseApp.app(name: "TactilDetection")
        
        return true
    }
    
 

    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {(granted, error) in
            if granted {
                DispatchQueue.main.async() {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        })
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Notificaciones", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    
    func getPushNotifications() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.getRegisteredPushNotifications()
            case .authorized:
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            case .denied:
                print("Permiso denegado.")
            // El usuario no ha dado permiso. Quizas se puede mostrar un mensaje recordando porqué se requiere el permiso.
            default:
                break
            }
        }
    }
    
    
    func getRegisteredPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        })
    }
}

//Mark - UNUserNotificationCenterDelegate
extension AppDelegate : UNUserNotificationCenterDelegate{
    
}


@main
struct TactilDetectionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
           
        }
    }
}
