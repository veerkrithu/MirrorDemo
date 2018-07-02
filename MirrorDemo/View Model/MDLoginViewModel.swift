//
//  MDLoginViewModel.swift
//  MirrorDemo
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 6/30/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//

//  Login view model class which acts as a bridge bewteen login view + viewcontoller and login model. This class takes care of perfroming login with backend and posts the updates to login view + viewcontoller classes. Also, this class stores the auth token in keychain after successful login for further transactions

import Foundation
import SwiftyJSON
import KeychainAccess

enum LoginStatus {
    
    case success
    case failure
}

class MDLoginViewModel {
    
    typealias LoginCompletionHandler = (LoginStatus)->Void
    private var userModel = UserModel()
    
    //Send login request asynchronously with user name and password post the results through LoginCompletionHandler completion handler
    
    func login(withUserName name:String, thePassWord password: String, andCompletionHandler handler: @escaping LoginCompletionHandler) {
        
        let serviceManager = ServiceManager(withAppUrl: ServiceManager.mirrorAppUrl(), httpEndPoint: "auth", httpMethod: "POST")
        
        let httpBody = ["username" : name, "password" : password]
        
        serviceManager.sendRequest(withBody: httpBody, theHeader: ["Content-Type" : "application/json"]) {
            
            [unowned self](data, error) in
            
            if(error == nil) {
                
                guard let responseData = data else {
                    handler(.failure)
                    return
                }
                
                self.userModel.userName = name
                self.userModel.password = password
                handler(self.parseUserLogin(responseData))
            }
        }
        
    }
}


extension MDLoginViewModel {
    
    //Parse the login response using swifty json and store the auth token in keychain for further transactions
    private func parseUserLogin(_ responseData: Data)->LoginStatus {
        
        guard let loginInfo = try? JSON(data: responseData) else { return .failure }
        
        if let errorInfo = loginInfo["error"].string {
            
            if(errorInfo == "Bad Request") {
                return .failure
            }
        }
        
        //Check for auth token from response and store them in keychain
        guard let authToken = loginInfo["access_token"].string else { return .failure }
        
        //Keychain wrapper class that stores the auth token in keychain
        let keyChain = Keychain(service: "com.Self.MirrorDemo")
        keyChain["access_token"] = authToken
        
        return .success
    }
}
