//
//  PasswordVerificationCodeViewController.swift
//  hguesting
//
//  Created by Mac Mini 9 on 26/4/2023.
//

import UIKit


class PasswordVerificationCodeViewController: UIViewController {
    
    let apiService = ApiService()
    
    


    @IBOutlet weak var verificationCodeInput: UITextField!
    
    
  
    @IBAction func SubmitButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let code = verificationCodeInput.text else {
            showAlert(title: "Error", msg: "Please enter a reset code")
            return
        }
        isValidCode(code: code) { isValid in
            if isValid {
                if let viewController = storyboard.instantiateViewController(withIdentifier: "PasswordResetVC") as? PasswordResetViewController {
                    self.navigationController!.pushViewController(viewController, animated: true)
                }
            } else {
                self.showAlert(title: "Error", msg: "Invalid reset code")
            }
        }
        
        func isValidCode(code: String, completion: @escaping (Bool) -> Void) {
            verifyResetCode(resetCode: code) { result in
                switch result {
                case .success:
                    completion(true)
                case .failure:
                    completion(false)
                }
            }
        }
        }

    func verifyResetCode(resetCode: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Set the URL for the POST request
        let url = URL(string: "http://127.0.0.1:3001/user/verifyResetCode")!

        // Create the request object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Set the request body
        let params = ["resetCode": resetCode]
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)

        // Set the request headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create a URLSession instance
        let session = URLSession.shared

        // Create the data task
        let task = session.dataTask(with: request) { (data, response, error) in
            // Handle the response
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "com.example.app", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data returned from server"])))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                completion(.failure(error))
            }
        }

        // Start the data task
        task.resume()
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
     }

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
