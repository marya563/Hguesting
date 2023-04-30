//
//  PasswordResetViewController.swift
//  hguesting
//
//  Created by Mac Mini 9 on 25/4/2023.
//


import UIKit

class PasswordResetViewController: UIViewController {
    
    let apiService = ApiService()
    
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var passwordComfInput: UITextField!
    
    
    @IBAction func submitButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let password = passwordInput.text, let passworConfirm = passwordComfInput.text {
            if password.isEmpty,passworConfirm.isEmpty {
                showAlert(title: "Error", msg: "fill the password inputs")
            }else{
                if isValidPassword(password: password), password==passworConfirm{
                   apiService.resetPassword(email: DataSignleton.shared.email!, password: passwordInput.text!)
                    if let viewController = storyboard.instantiateViewController(withIdentifier: "SinginVC") as? SinginViewController {self.navigationController?.pushViewController(viewController, animated: true)}
                }else{
                    showAlert(title: "Error", msg: "your password is shorter than 6 digits or not same as confirm one")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordInput.isSecureTextEntry = true
        passwordComfInput.isSecureTextEntry = true
       
    }
    
    func isValidPassword(password : String)-> Bool {return password.count > 5}
    
    
    func showAlert(title: String ,msg : String) {
        
        let dialogMessage = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
         })
        
        //Add OK button to a dialog message
        dialogMessage.addAction(ok)
        // Present Alert to
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
}

