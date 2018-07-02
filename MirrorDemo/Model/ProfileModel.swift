//
//  ProfileModel.swift
//  MirrorDemo
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 7/1/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//

import Foundation

class ProfileModel: UserModel {
    
    var age         : UInt64
    var height      : UInt64
    var likeScript  : Bool
    var magicNumber : UInt64
    var magicHash   : String
    
    
    override init() {
        
        age         = 0
        height      = 0
        likeScript  = false
        magicNumber = 0
        magicHash   = ""
        
        super.init()
    }
}
