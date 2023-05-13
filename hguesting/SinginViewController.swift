//
//  SinginViewController.swift
//  hguesting
//
//  Created by Mac Mini 9 on 22/3/2023.
//
import UIKit
import SwiftUI

class SinginViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
   

   
    @IBOutlet weak var myswitch: UISwitch!
    
    @IBOutlet weak var Signinbtn: UIButton!
  
    var userData: [String: Any]?
    var id: String?
    var cc: String?
    
    
   
    
    
    @IBAction func  switchChanged(_ sender: UISwitch) {
   
        let defaults = UserDefaults.standard
            defaults.set(sender.isOn, forKey: "rememberMe")
    }

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myswitch.isOn = false
        passwordTextField.isSecureTextEntry = true
       
     
     
    }

    @IBAction func SigninButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Nom de l'utilisateur", message: "Le Nom de l'utilisateur ne doit pas être vide !")
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Mot de passe", message: "Le Mot de passe ne doit pas être vide !")
            return
        }
        
      
print("1")
        // Set the URL for the POST request
    
        let url = URL(string: "http://127.0.0.1:3001/user/signin")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        print("2")
        // Set the request body
        let params = ["email": email, "password": password ]
        print(params)
  
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        
        // Set the request headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create a URLSession instance
        let session = URLSession.shared

        // Create the data task
        let task = session.dataTask(with: request) { (data, response, error) in
            // Handle the response
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data returned from server")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let email = json["email"] as? String, let id = json["id"] as? String {
                    print(json)
                    let defaults = UserDefaults.standard

                    // Save the user ID to UserDefaults
                    defaults.set(id, forKey: "id")

                    // Save the email to UserDefaults
                    defaults.set(email, forKey: "rememberMe")

                    defaults.synchronize()
                    // Retrieve the value from UserDefaults
                    let savedEmail = defaults.string(forKey: "rememberMe")
                    print("Saved email: \(savedEmail ?? "N/A")")
                    let savedid = defaults.string(forKey: "id")
                    print("Saved id: \(savedid ?? "N/A")")

                    // Check if the switch is on
                    DispatchQueue.main.async {
                        let isOn = self.myswitch.isOn

                        // If the switch is on, save the email and password to UserDefaults
                        if isOn {
                            defaults.set(email, forKey: "userEmail")
                            defaults.set(password, forKey: "userPassword")
                            defaults.set(id, forKey: "idstr")
                        }
                    }
                    self.id = id
                    DispatchQueue.main.async {
                        if let idStr = id as? String {
                            print(idStr)
                            self.showAlertNavigate(title: "Success", message: "Welcome \(email)", id: idStr)
                        } else {
                            self.showAlert(title: "Error", message: "Invalid ID format")
                        }
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
            }
        /*
        guard let id = id else {
            print("ID is nil")
            return
        }*/

        // Start the data task
        task.resume()
    }

    
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
      
        
    }
  
    func showAlert(title: String, message: String, buttonTitle: String = "OK", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
        
        alert.addAction(action)
        
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            topViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlertNavigate(title: String, message: String, id: String? = nil, buttonTitle: String = "OK", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: buttonTitle, style: .default) { (_) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "tabvc") as! tabbarTabViewController
           if let id = id {
             destinationVC.idStr = String(id)
      }
            
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        
        alert.addAction(action)
        
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            topViewController.present(alert, animated: true, completion: nil)
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToUpdateprofilViewController" {
            let destinationVC = segue.destination as! UpdateprofilViewController
            destinationVC.id = UserDefaults.standard.string(forKey: "id")
        } else if segue.identifier == "segueToUpdateViewController" {
            let destinationVC = segue.destination as! updateViewController
            destinationVC.id = UserDefaults.standard.string(forKey: "id")
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
   

}
