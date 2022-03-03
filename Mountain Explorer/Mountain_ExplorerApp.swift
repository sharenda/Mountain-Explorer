//
//  Mountain_appApp.swift
//  Mountain app
//
//  Created by Pavel Sharenda on 21.02.22.
//

import SwiftUI
import UserNotifications

@main
struct Mountain_ExplorerApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            Main()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemBlue, .font : UIFont(name: "ArialRoundedMTBold", size: 35)!]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.systemBlue, .font : UIFont(name: "ArialRoundedMTBold", size: 20)!]
        UITabBarItem.appearance().setTitleTextAttributes([.font : UIFont(name: "ArialRoundedMTBold", size: 12)!], for: [])
        UITabBarItem.appearance().titlePositionAdjustment.vertical = 5
    }
}

final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("User notifications are allowed.")
            } else {
                print("User notifications are not allowed.")
            }
        }
        return true
    }
}
