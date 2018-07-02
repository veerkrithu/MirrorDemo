//
//  MDProfileViewController.swift
//  MirrorDemo
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 6/30/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//

import UIKit

class MDProfileViewController: UIViewController {
    
    static let kProfileViewSegueIdentifier = "profileViewSegueIdentifier"
    
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var ageTxtField: UITextField!
    @IBOutlet weak var jScriptSwitch: UISwitch!
    @IBOutlet weak var feetTxtField: UITextField!
    @IBOutlet weak var inchsTxtField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveProfileButton: UIButton!
    
    private let profileViewModel = MDProfileViewModel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUIFields()
        
        activityIndicator.startAnimating()
        
        profileViewModel.getUserProfile { [unowned self] (profileStatus) in
            
            DispatchQueue.main.async { [unowned self] in
                
                self.activityIndicator.stopAnimating()
                
                switch profileStatus {
                    
                case .success:
                    print("Success")
                    
                case .failure:
                    self.showAlert(withMessage: "Failed")
                }
            }
        }
        
        profileViewModel.profileBoxModel.bind {
            
            [unowned self] (profileModel) in
            
            DispatchQueue.main.async {
                
                self.userNameTxtField.text = profileModel.userName
                self.passwordTxtField.text = profileModel.password
                self.ageTxtField.text = String(profileModel.age)
                
                let height = self.profileViewModel.feetInchesFromCentimeters(profileModel.height)
                self.feetTxtField.text = String(format: "%.1f", height.feet)
                self.inchsTxtField.text = String(format: "%.1f", height.inches)
                
                profileModel.likeScript ? self.jScriptSwitch.setOn(true, animated: true) : self.jScriptSwitch.setOn(false, animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func setupUIFields() {
        
        passwordTxtField.isEnabled = false
        saveProfileButton.layer.cornerRadius = 15.0
        saveProfileButton.layer.borderColor = UIColor.white.cgColor
        saveProfileButton.layer.borderWidth = 1.0
        saveProfileButton.clipsToBounds = true
        setupTextFieldDelegates()
    }
    
    @IBAction func userNameTxtFieldDidEndEditing(_ sender: UITextField) {
        
        if sender.text == "" {
            showAlert(withMessage: "User name can't be empty")
        }
    }
    
    @IBAction func userAgeTxtFieldDidEndEditing(_ sender: UITextField) {
        
        if sender.text == "" {
            showAlert(withMessage: "Age can't be empty")
        }
    }
    
    @IBAction func userFeetTxtFieldDidEndEditing(_ sender: UITextField) {
        
        if sender.text == "" {
            showAlert(withMessage: "Feet can't be empty")
        }
    }
    
    @IBAction func userInchsTxtFieldDidEndEditing(_ sender: UITextField) {
        
        if sender.text == "" {
            showAlert(withMessage: "Inches can't be empty")
        }
    }
    
    @IBAction func likeJScriptValueChanged(_ sender: UISwitch) {
        profileViewModel.setJScriptLike(sender.isOn ? true : false)
    }
    
    @IBAction func saveProfileBtnClicked(_ sender: UIButton) {
        
        //Update profile model with user name, age, height, like jscript etc
        profileViewModel.setUserName(userNameTxtField.text!)
        profileViewModel.setUserAge(UInt(ageTxtField.text!)!)
        profileViewModel.setUserHeight(inFeet: (Double(feetTxtField.text!)!), andInches: (Double(inchsTxtField.text!)!))
        profileViewModel.setJScriptLike(jScriptSwitch.isOn ? true : false)
        
        self.activityIndicator.startAnimating()
        profileViewModel.saveUserProfile { [unowned self] (profileStatus) in
            
            DispatchQueue.main.async {
                
                self.activityIndicator.stopAnimating()
                switch profileStatus {
                    
                case .success:
                    self.showAlert(withMessage: "Save Success")
                case .failure:
                    self.showAlert(withMessage: "Save failed")
                }
            }
        }
    }
}

extension MDProfileViewController: UITextFieldDelegate
{
    func setupTextFieldDelegates() {
        
        userNameTxtField.delegate = self
        ageTxtField.delegate = self
        feetTxtField.delegate = self
        inchsTxtField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

extension MDProfileViewController
{
    func showAlert(withMessage message:String) {
        
        let alertController = UIAlertController(title: "Mirror Profile", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

