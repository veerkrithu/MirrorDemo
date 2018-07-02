//
//  MDRegistrationViewModel.swift
//  MirrorDemo
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 6/30/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//

//  Registartion view model class which acts as a bridge bewteen registartion view + viewcontoller and login model. This class takes care of registaring the users with backend and posts the updates to registartion view + viewcontoller classes. Also, this class stores the user identifier in keychain after successful user registration

import Foundation
import SwiftyJSON
import KeychainAccess

enum RegistrationStatus {
    
    case success
    case failure
    case exists
}

class MDRegistrationViewModel {
    
    typealias RegistrationCompletionHandler = (RegistrationStatus)->Void
    private var userModel = UserModel()
    
    //Send register user request asynchronously with user name and password the results are posted through RegistrationCompletionHandler completion handler
    func registerUser(withCompletionHandler handler: @escaping RegistrationCompletionHandler) {
        
        let serviceManager = ServiceManager(withAppUrl: ServiceManager.mirrorAppUrl(), httpEndPoint: "users", httpMethod: "POST")
        
        let httpBody = ["username" : userModel.userName, "password" : userModel.password] as [String : Any]
        
        serviceManager.sendRequest(withBody: httpBody, theHeader: ["Content-Type" : "application/json"]) { [unowned self](data, error) in
            
            if(error == nil) {
                
                guard let responseData = data else {
                    handler(.failure)
                    return
                }
                
                handler(self.parseUserRegistration(responseData))
            }
        }
    }
}

extension MDRegistrationViewModel {
    
    //Parse the user registartion response using swifty json and store the user identifier in keychain for get profile calls
    private func parseUserRegistration(_ responseData: Data)->RegistrationStatus {
        
        
        guard let userInfo = try? JSON(data: responseData) else { return .failure }
        
        if let errorInfo = userInfo["error"].string {
            
            //To do error handling
            if(errorInfo == "user already exists") {
                return .exists
            }
        }
        
        //Set user identifier from registartion response
        guard let userId = userInfo["id"].uInt64 else {return .failure }
        self.setUserId(userId)
        
        return .success
    }
}

extension MDRegistrationViewModel {
    
    func setUserName(_ userName: String) {
        userModel.userName = userName
    }
    
    func setPassword(_ userPwd: String) {
        userModel.password = userPwd
    }
    
    private func setUserId(_ userId: UInt64) {
        
        //Stores user identifier in keychain for get profile calls
        userModel.id = userId
        let keyChain = Keychain(service: "com.Self.MirrorDemo")
        keyChain["user_id"] = String(userId)
    }
}
