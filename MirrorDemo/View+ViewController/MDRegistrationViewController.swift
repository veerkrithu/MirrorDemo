//
//  MDRegistrationViewController.swift
//  MirrorDemo
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 7/1/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//

import UIKit

class MDRegistrationViewController: UIViewController {

    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var retypePwdTextField: UITextField!
    @IBOutlet weak var registartionButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private let registrationViewModel = MDRegistrationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupUIFields() {
        
        registartionButton.layer.cornerRadius = 15.0
        registartionButton.layer.borderColor = UIColor.white.cgColor
        registartionButton.layer.borderWidth = 1.0
        registartionButton.clipsToBounds = true
    }
    
    @IBAction func registerMeBtnClicked(_ sender: UIButton) {
        
        if pwdTextField.text == retypePwdTextField.text {
            
            activityIndicator.startAnimating()
            
            registrationViewModel.setPassword(pwdTextField.text!)
            registrationViewModel.registerUser { [unowned self] registrationStatus in
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    
                    switch registrationStatus {
                        
                    case .exists:
                        self.showAlert(withMessage: "User Already Exists")
                        
                    case .failure:
                        self.showAlert(withMessage: "Failed")
                        
                    case .success:
                        self.showAlert(withMessage: "Success")
                    }
                }
            }
        }
        else {
            showAlert(withMessage: "Password doen't match retype password")
        }
    }
    
    @IBAction func userNameTxtFieldDidEndEditing(_ sender: UITextField) {
        
        if sender.text != "" {
            registrationViewModel.setUserName(sender.text!)
        }
        else {
            showAlert(withMessage: "User name can't be empty")
        }
    }
    
    @IBAction func userPwdTxtFieldDidEndEditing(_ sender: UITextField) {
        
        if sender.text == "" {
            showAlert(withMessage: "Password can't be empty")
        }
    }
    
    @IBAction func userReTypePwdTxtFieldDidEndEditing(_ sender: UITextField) {
       
    }
}

extension MDRegistrationViewController
{
    func showAlert(withMessage message:String) {
        
        let alertController = UIAlertController(title: "Mirror Registartion", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
