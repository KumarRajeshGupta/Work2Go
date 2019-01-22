//
//  FCMRegistration.swift
//  Work2go
//
//  Created by Rajesh Gupta on 6/23/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging


class RegisterFCM {
    
    func registerFcnTokenOnServer(with fcmToken:String){
        
        if UserDefaults.standard.isLoggedIn() {
            deviceRegisterOnServer(with: fcmToken)
        }
    }
    
    private func deviceRegisterOnServer(with fcmToken:String){
        let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        ServerHandler().getResponseFromServer(parametrs: "push_device_registration.php?user_id=\(userData.user_id!)&&token_id=\(UserDefaults.standard.getToken() ?? "")&&device_type=iOS&&device_id=\(UserDefaults.standard.getDeviceID())") { (results) in
            let status = results["status"] as? String ?? ""
            if status == "1"{
                print("Successfully device registered on server")
            }
        }
    }
    
    func saveFcmTokenOnLogin()  {
        if let fcm = UserDefaults.standard.getToken() {
            self.deviceRegisterOnServer(with: fcm)
        }else{
            if let token = Messaging.messaging().fcmToken {
                UserDefaults.standard.setToken(value: token)
                self.deviceRegisterOnServer(with: token)
            }
        }
    }
}
