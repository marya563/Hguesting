//
//  ProfilViewController.swift
//  hguesting
//
//  Created by Mac Mini 9 on 2/Users/macmini9/Documents/mariaetfedifront/hguesting/hguesting/MyCollectionViewCell.swift7/3/2023.
//
import UIKit
import Kingfisher

class ProfilViewController: UIViewController {

   
    @IBOutlet var ProfileImageView: UIImageView!
    @IBOutlet var emailText: UITextField!
    @IBOutlet var firstnameText: UITextField!
    
    @IBOutlet var lastnameText: UITextField!
    var idStr: String?
    var id: String?
    var userId: String?
    let defaults = UserDefaults.standard
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        userId = defaults.string(forKey: "id") ?? "N/A"
        // Make sure the ID is not nil
    
        // Set the corner radius
        ProfileImageView.layer.cornerRadius = ProfileImageView.frame.width / 2
        ProfileImageView.clipsToBounds = true
        ProfileImageView.contentMode = .scaleAspectFill
        ProfileImageView.kf.setImage(with: URL(string:"https://cdn-icons-png.flaticon.com/512/5987/5987811.png"))
        guard let userId = self.userId else {
            print("Failed to get user ID")
            return
        }
        
        // Create the URL with the ID
        let urlString = "http://127.0.0.1:3001/user/getByIdUserrrr/\(userId)"
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
                   let lastname = json["lastname"] as? String,
                   let profilePic = json["profilePic"] as? String
                   {
                    DispatchQueue.main.async {
                        // Update the UI on the main thread
                        self.firstnameText.text = firstname
                        self.lastnameText.text = lastname
                        self.emailText.text = email
                        let imageUrlString = "http://localhost:3001/user/image/\(profilePic)"
                                            let imageUrl = URL(string: imageUrlString)!
                                            self.ProfileImageView.kf.setImage(with: imageUrl)
                                       
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Retrieve the saved email and ID from UserDefaults
        let defaults = UserDefaults.standard
        let savedEmail = defaults.string(forKey: "rememberMe") ?? "N/A"
        let savedid = defaults.string(forKey: "id") ?? "N/A"
        print("Saved email: \(savedEmail)")
        print("Saved ID: \(savedid)")
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToUpdateprofilViewController" {
            let destinationVC = segue.destination as! UpdateprofilViewController
            destinationVC.id = UserDefaults.standard.string(forKey: "id")
        } else if segue.identifier == "segueToUpdateViewController" {
            let destinationVC = segue.destination as! updateViewController
            destinationVC.id = UserDefaults.standard.string(forKey: "id")
        }
    }
   

        // Other code in the ProfilViewController class
        // ...
    }


        // Do any additional setup after loading the view.
    
    

    


