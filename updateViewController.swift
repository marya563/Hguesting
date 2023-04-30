//
//  updateViewController.swift
//  hguesting
//
//  Created by Mac Mini 9 on 23/4/2023.
//

import UIKit

import Kingfisher



class updateViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

   
    @IBOutlet var uploadButton: UIButton!
    
    
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet weak var firstnameTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var lastnameTextfield: UITextField!
    
    @IBAction func updatebtn(_ sender: Any) {
    }
    @IBOutlet weak var updatebtn: UIButton!
    var userId: String?
    var userData: [String: Any]?
    var id: String?
    let imagePicker = UIImagePickerController()
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        userId = defaults.string(forKey: "id") ?? "N/A"
        updatebtn.addTarget(self, action: #selector(updateUser), for: .touchUpInside)
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true

        userId = defaults.string(forKey: "id") ?? "N/A"
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        updatebtn.addTarget(self, action: #selector(uploadProfilePicture), for: .touchUpInside)
        profileImageView.kf.setImage(with: URL(string:"https://cdn-icons-png.flaticon.com/512/5987/5987811.png"))
        // Do any additional setup after loading the view.
    }
    
    
    
    @objc func uploadProfilePicture() {
        guard let userId = self.userId, let imageData = profileImageView.image?.jpegData(compressionQuality: 0.5)
       
        else {
            print("Failed to get user ID or image data")
            return
        }
        self.showAlertNavigate(title: "success", message: "Great Pic")
           
           // rest of your code here
       
        let url = URL(string: "http://localhost:3001/user/upload/\(userId)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        let fieldName = "file"
        let fileName = UUID().uuidString + ".jpg"
        let mimeType = "image/jpeg"
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }
            
            guard let responseData = data else {
                print("No data received")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: responseData, options: [])
                print(json)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            profileImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
        
        // Upload the selected image
       // uploadProfilePicture()
        
    }
    
    
    
    
    
    
    
    @IBAction func selectProfilePicture(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Profile Picture", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { _ in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    @objc func updateUser() {
        print("Update button tapped") // Debugging line
        guard let userId = self.userId else {
            print("Failed to get user ID")
            return
        }
print("1")
        let updateParams: [String: Any] = [
            "email": emailTextField.text ?? "",
            "firstname": firstnameTextfield.text ?? "",
            "lastname": lastnameTextfield.text ?? "",
            "password": passwordTextfield.text ?? "",
           
        ]
        print("2")
        // Make an API request to update user data
        let url = URL(string: "http://localhost:3001/user/updateUser/\(userId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: updateParams, options: [])
        print("3")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("Inside URLSession closure") // Debugging line
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            print("4")
            guard let data = data else {
                print("No data received")
                return
            }
            print("5")
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                print("Response: \(jsonResponse)")
                print("6")
                // If the update is successful, show an alert to the user
                DispatchQueue.main.async {
                    self.showAlert(title: "Success", message: "User data updated!")
                }
                
            } catch {
                print("Error decoding response: \(error.localizedDescription)")
            }
            
        }.resume()
        print("7")
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
      
        
    }
    
    
    
    
    
    func showAlertNavigate(title: String, message: String, id: String? = nil, buttonTitle: String = "OK", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: buttonTitle, style: .default) { (_) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "ProfilVC") as! ProfilViewController
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

    
}
