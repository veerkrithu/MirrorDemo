//
//  MDHomeViewController.swift
//  MirrorDemo
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 7/1/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//

import UIKit
import KeychainAccess

class MDHomeViewController: UIViewController {
    
    static let kHomeViewSegueIdentifier = "homeViewSegueIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logoutBtnClicked(_ sender: UIButton) {
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window?.layer.add(transition, forKey: "leftToRightTransition")
        
        self.dismiss(animated: true) {
            
            let keyChain = Keychain(service: "com.Self.MirrorDemo")
            keyChain["access_token"] = nil
        }
    }
}
