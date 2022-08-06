//
//  AppDelegate.swift
//  Strix RealEstate
//
//  Created by botan pro on 4/16/22.
//

import UIKit
import Firebase
import FirebaseAuth
import OneSignal

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if UserDefaults.standard.integer(forKey: "Lang") == 0{
            XLanguage.set(Language: .Kurdish)
            UserDefaults.standard.set(3,forKey: "Lang")
        }
        
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("3801c3ed-1732-4d10-9910-633ea78d617e")
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
            UserDefaults.standard.set(OneSignal.getDeviceState().userId ?? "", forKey: "OneSignalId")
          })
        
        
        
        
        FirebaseApp.configure()
        return true
    }
    
     func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges) {
        if !stateChanges.from.isSubscribed && stateChanges.to.isSubscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(String(describing: stateChanges))")
        
        if let playerId = stateChanges.to.userId {
            print("Current playerId \(playerId)")
            UserDefaults.standard.set(playerId, forKey: "OneSignalId")
        }
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

