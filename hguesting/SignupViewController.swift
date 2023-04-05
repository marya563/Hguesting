//
//  SignupViewController.swift
//  hguesting
//
//  Created by Mac Mini 9 on 21/3/2023.
//

import UIKit

class SignupViewController: UIViewController {

   

    
    @IBOutlet weak var firstnameTextField: UITextField!
    
    @IBOutlet weak var lastnameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    

    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordcheckTextfield: UITextField!
    
    
    
    @IBOutlet weak var signupbtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
    }
    
   
    
 
   
    @IBAction func singupbtn(_ sender: Any) {
          // Get the values from the text fields
              guard let firstname = firstnameTextField.text, !firstname.isEmpty else {
                  showAlert(title: "Nom de l'utilisateur", message: "Le nom d'utilisateur ne doit pas être vide !")
                  return
              }
        guard let lastname = lastnameTextField.text, !lastname.isEmpty else {
            showAlert(title: "Nom de l'utilisateur", message: "Le nom d'utilisateur ne doit pas être vide !")
            return
        }
              
              guard let email = emailTextField.text, !email.isEmpty else {
                  showAlert(title: "Adresse Email", message: "L'Adresse Email ne doit pas être vide !")
                  return
              }
              guard let password = passwordTextField.text,
                        !password.isEmpty else {
                  showAlert(title: "Mot de passe", message: "Le Mot de passe ne doit pas être vide !")
                  return
              }
          guard let passwordcheck=passwordcheckTextfield.text, !passwordcheck.isEmpty else {
              showAlert(title: "Retapez Mot de passe", message: "Le Retapez Mot de passe ne doit pas être vide !")
              return
          }
              
              guard password == passwordcheck else {
                  showAlert(title: "Verification de mot de passe", message: "Les deux mots de passe doivent être identiques !")
                  return
              }
        
              // Set the URL for the POST request
              let url = URL(string: "http://127.0.0.1:3001/user/signup")!
        
              // Create the request object
              var request = URLRequest(url: url)
              request.httpMethod = "POST"
        
              // Set the request body
              let params = ["firstname": firstname, "lastname": lastname, "email": email, "password": password]
              
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
                      let json = try JSONSerialization.jsonObject(with: data, options: [])
                      print(json)
                      DispatchQueue.main.async {
                          self.showAlertNavigate(title: "Success", message: "User registered successfully")
                      }
                  } catch {
                      print("Error parsing JSON: \(error.localizedDescription)")
                  }
              }
        
              // Start the data task
              task.resume()
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
      
      func showAlertNavigate(title: String, message: String, buttonTitle: String = "OK", completion: (() -> Void)? = nil) {
          let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
          
          let action = UIAlertAction(title: buttonTitle, style: .default) { (_) in
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let destinationVC = storyboard.instantiateViewController(withIdentifier: "SinginVC") as! SinginViewController
             self.navigationController?.pushViewController(destinationVC, animated: true)
          }
          
          alert.addAction(action)
          
          if let topViewController = UIApplication.shared.windows.first?.rootViewController {
              topViewController.present(alert, animated: true, completion: nil)
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

