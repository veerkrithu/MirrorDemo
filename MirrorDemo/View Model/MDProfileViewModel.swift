//
//  MDProfileViewModel.swift
//  MirrorDemo
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 7/1/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//

//  Profile view model class which acts as a bridge bewteen profile view + viewcontoller and profile model. This class takes care of retrieving user profile for backend and update user profile changes to backend. The results are posted via completion handler.

import Foundation
import SwiftyJSON
import KeychainAccess

enum ProfileStatus {
    
    case success
    case failure
}

class MDProfileViewModel {
    
    typealias ProfileCompletionHandler = (ProfileStatus)->Void
    
    //Box class with profile model which handles the UI update via binding whenever model gets updated
    var profileBoxModel:MDBox<ProfileModel> = MDBox(ProfileModel())
    
    func setUserName(_ userName: String) {
        profileBoxModel.value.userName = userName
    }
    
    func setUserAge(_ userAge: UInt) {
        profileBoxModel.value.age = UInt64(userAge)
    }
    
    func setUserHeight(inFeet feet:Double, andInches inches:Double) {
        profileBoxModel.value.height = centimeterFromFeet(feet, andInches: inches)
    }
    
    func setJScriptLike(_ isLikeScript: Bool) {
        profileBoxModel.value.likeScript = isLikeScript
    }
    
    //Retrieve user profile with user identifier the results are posted through ProfileCompletionHandler completion handler
    func getUserProfile(withCompletionHandler handler: @escaping ProfileCompletionHandler) {
        
        //Retrieve user id from keychain
        let keyChain = Keychain(service: "com.Self.MirrorDemo")
        
        guard let userId = keyChain["user_id"] else {
            
            handler(.failure)
            return
        }
        
        let httpEndPoint = "users/" + userId
        
        //Testing - To be removed
        //let httpEndPoint = "users/" + "114"
        
        //GET call to retreive user profile from server
        let serviceManager = ServiceManager(withAppUrl: ServiceManager.mirrorAppUrl(), httpEndPoint: httpEndPoint, httpMethod: "GET")
        
        let authToken = "JWT " + keyChain["access_token"]!
        
        let httpHeader = ["Content-Type" : "application/json", "Authorization": authToken] as [String : String]
        
        serviceManager.sendRequest(withBody: nil, theHeader: httpHeader) { [unowned self] (data, error) in
            
            if(error == nil) {
                
                guard let responseData = data else {
                    handler(.failure)
                    return
                }
                
                handler(self.parseFetchUserProfile(responseData))
            }
        }
    }
    
    
    func saveUserProfile(withCompletionHandler handler: @escaping ProfileCompletionHandler) {
        
        //Retrieve user id from keychain
        let keyChain = Keychain(service: "com.Self.MirrorDemo")
        
        guard let userId = keyChain["user_id"] else {
         
            handler(.failure)
            return
        }
         
        let httpEndPoint = "users/" + userId
        
        //Testing - To be removed
        //let httpEndPoint = "users/" + "114"
        
        //PATCH call to update user profile to backend server
        let serviceManager = ServiceManager(withAppUrl: ServiceManager.mirrorAppUrl(), httpEndPoint: httpEndPoint, httpMethod: "PATCH")
        
        let authToken = "JWT " + keyChain["access_token"]!
        
        let httpHeader = ["Content-Type" : "application/json", "Authorization": authToken] as [String : String]
        
        let httpBody = ["username" : profileBoxModel.value.userName, "age" : profileBoxModel.value.age, "height" : profileBoxModel.value.height, "likes_javascript" : profileBoxModel.value.likeScript] as [String : Any]

        serviceManager.sendRequest(withBody: httpBody, theHeader: httpHeader) { [unowned self] (data, error) in
            
            if(error == nil) {
                
                guard let responseData = data else {
                    handler(.failure)
                    return
                }
                
                handler(self.parseSaveUserProfile(responseData))
            }
        }
    }
}

extension MDProfileViewModel {
    
    //Parse save user profile response using swifty json and update the save profile status to profile view + viewcontroller
    private func parseSaveUserProfile(_ responseData: Data)->ProfileStatus {
        
        guard let userInfo = try? JSON(data: responseData) else { return .failure}
        
        if let _ = userInfo["error"].string {
            
            //To do - Error Handling
            return .failure
        }
        return .success
    }
    
    //Parse fetch user profile response using swifty json and update the profile model that inturns udpates the profile view + viewcontroller via binding (using box listener class)
    
    private func parseFetchUserProfile(_ responseData: Data)->ProfileStatus {
        
        let profileModel = ProfileModel()
        
        guard let userInfo = try? JSON(data: responseData) else { return .failure}
        
        if let _ = userInfo["error"].string {
            
            //To do - Error Handling
            return .failure
        }
        
        //Updates the model with id, username, height, age, magic number and magic hash etc
        if let userId = userInfo["id"].uInt64 {
            profileModel.id = userId
        }
        
        if let userName = userInfo["username"].string {
            profileModel.userName = userName
        }
        
        if let userAge = userInfo["age"].uInt64 {
            profileModel.age = userAge
        }
        
        if let userHeight = userInfo["height"].uInt64 {
            profileModel.height = userHeight
        }
        
        if let likeJScript = userInfo["likes_javascript"].bool {
            profileModel.likeScript = likeJScript
        }
        
        if let magicNumber = userInfo["magic_number"].uInt64 {
            profileModel.magicNumber = magicNumber
        }
        
        if let magicHash = userInfo["magic_hash"].string {
            profileModel.magicHash = magicHash
        }
        
        //Updates the box model which triggers UI update
        self.profileBoxModel.value = profileModel
        
        return .success
    }
}

extension MDProfileViewModel {
    
    //Conversion functions for centimeter to inch, feet and vice versa. Years / age to milliseconds
    
    func milliSecondsFromAge(_ age:UInt)->UInt64 {
        
        return UInt64((365.2425 * Double(age) * 24 * 60 * 60 * 1000))
    }
    
    //1 centimeter is equal to 0.3937 inches. Therefore, n centimeters are equal to (n * 0.3937)inches.
    //1 foot is equal to 30.48 centimeter. 1 inch is equal to 2.54 centimeter. Extract the feet from centimeters and calculate the inches for rest
    func feetInchesFromCentimeters(_ centimeters:UInt64)->(feet: Double, inches: Double) {
        
        let feet = floor(Double(centimeters) * 0.0328084)
        let temp = Double(centimeters) - (feet * 30.48)
        let inches = temp / 2.54
        return (feet, inches)
    }
    
    func centimeterFromFeet(_ feet:Double, andInches inches:Double)->UInt64 {
        
        return UInt64(round((feet * 30.48) + (inches * 2.54)))
    }
}
