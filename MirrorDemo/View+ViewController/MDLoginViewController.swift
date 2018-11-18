//
//  MDLoginViewController.swift
//  MirrorDemo
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 6/30/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//

import UIKit

class MDLoginViewController: UIViewController {

    @IBOutlet weak var credContainerView: UIView!
    @IBOutlet weak var pwdTxtFld: UITextField!
    @IBOutlet weak var usrNameTxtFld: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginStackView: UIStackView!
    
    private let loginViewModel = MDLoginViewModel()
    private var isStackViewLifted = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupUIFields()

        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupUIFields() {
        
        usrNameTxtFld.text = ""
        pwdTxtFld.text = ""
        
        credContainerView.layer.cornerRadius = 5.0
        credContainerView.layer.borderColor = UIColor.white.cgColor
        credContainerView.layer.borderWidth = 1.0
        credContainerView.clipsToBounds = true
        
        loginButton.layer.cornerRadius = 20.0
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.borderWidth = 1.0
        loginButton.clipsToBounds = true
        self.setupTextFieldDelegates()
    }

    @IBAction func signInBtnClicked(_ sender: Any) {
        
        if (usrNameTxtFld.text!) != "" && (pwdTxtFld.text!) != "" {
            
            activityIndicator.startAnimating()
            
            loginViewModel.login(withUserName: usrNameTxtFld.text!.trimmingCharacters(in: .whitespaces), thePassWord: pwdTxtFld.text!.trimmingCharacters(in: .whitespaces))
            {
                [unowned self] (loginStatus) in
            
                DispatchQueue.main.async {
                    
                    self.activityIndicator.stopAnimating()
                    
                    switch loginStatus {
                        
                    case .failure:
                        self.showAlert(withMessage: "Failed")
                        
                    case .success:
                        self.showProfile()
                    }
                }
            }
        }
        else {
            
            self.showAlert(withMessage: "User Name / Password can not be empty")
        }
    }
}

extension MDLoginViewController: UITextFieldDelegate
{
    func setupTextFieldDelegates() {
        
        usrNameTxtFld.delegate = self
        pwdTxtFld.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(sender: Notification) {
        
        if(!isStackViewLifted)
        {
            loginStackView.frame.origin.y = loginStackView.frame.origin.y - 40
            isStackViewLifted = true
        }
    }
    
    @objc func keyboardWillHide(sender: Notification) {
        isStackViewLifted = false
        loginStackView.frame.origin.y = loginStackView.frame.origin.y + 40
    }
    
}

extension MDLoginViewController
{
    func showProfile() {
        
        self.performSegue(withIdentifier: MDHomeViewController.kHomeViewSegueIdentifier, sender: self)
    }
    
    func showAlert(withMessage message:String) {
        
        let alertController = UIAlertController(title: "Mirror Login", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
}
