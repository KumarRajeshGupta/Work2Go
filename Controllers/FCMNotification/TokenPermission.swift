//
//  TokenPermission.swift
//  Work2go
//
//  Created by Rajesh Gupta on 6/23/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications




extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func requestNotificationAuthorization(application: UIApplication) {
        
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert,.badge,.sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { (success, error) in
                Messaging.messaging().delegate = self
            })
        }else{
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
    }
    
}

extension AppDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        print("Firebase registration token: \(fcmToken)")
        UserDefaults.standard.setToken(value: fcmToken)
        
        DispatchQueue.main.async {
            RegisterFCM().registerFcnTokenOnServer(with: fcmToken)
        }
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        UIApplication.shared.applicationIconBadgeNumber = 0
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[kGCMMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        if UIApplication.shared.applicationState == .active {
            
            FCMNotification().didReciveNotification(with: userInfo as! [String : Any])
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
            //TODO: Handle foreground notification
        } 
        print(userInfo)
        completionHandler(.newData)
    }
    
}
