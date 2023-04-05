//
//  ProfilViewController.swift
//  hguesting
//
//  Created by Mac Mini 9 on 27/3/2023.
//

import UIKit

class ProfilViewController: UIViewController {

    @IBOutlet weak var FirstNameTextField: UITextField!
    
    @IBOutlet weak var LastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!

    var idStr: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Make sure the ID is not nil
        guard let idStr = idStr else {
            print("ID is nil")
            return
        }

        // Create the URL with the ID
        let urlString = "http://127.0.0.1:3001/user/getByIdUserrrr/\(idStr)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }

        // Create the URL request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Send the request
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data returned from server")
                return
            }

            do {
                // Parse the JSON response
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let firstname = json["firstname"] as? String,
                   let email = json["email"] as? String,
                   let lastname = json["lastname"] as? String {
                    DispatchQueue.main.async {
                        // Update the UI on the main thread
                        self.FirstNameTextField.text = firstname
                        self.LastNameTextField.text = lastname
                        self.emailTextField.text = email
                    }
                } else {
                    print("Invalid JSON response")
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
}

        // Do any additional setup after loading the view.
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



