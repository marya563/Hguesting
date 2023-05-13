import UIKit
import Kingfisher
class UpdateprofilViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    
    @IBOutlet weak var update: UIButton!
    let imagePicker = UIImagePickerController()
    let defaults = UserDefaults.standard
    
    @IBOutlet var home: UIButton!
    
    var idStr: String?// The ID of the user whose profile picture is being updated
    var userId: String?// The ID of the user whose profile picture is being updated
    var id: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString = "http://127.0.0.1:3001/user/getByIdUserrrr/\(id)"
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
                    let profilePic = json["profilePic" ] as? String
                {
                    DispatchQueue.main.async {
                        // Update the UI on the main thread
                        let imageUrlString = "http://localhost:3001/user/image/\(profilePic)"
                        let imageUrl = URL(string: imageUrlString)!
                        self.profileImageView.kf.setImage(with: imageUrl)
                    }
                } else {
                    // Debugging information
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("Invalid JSON response: \(json)")
                    } else {
                        print("Invalid JSON response")
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
    
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        userId = defaults.string(forKey: "id") ?? "N/A"
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        update.addTarget(self, action: #selector(uploadProfilePicture), for: .touchUpInside)
        profileImageView.kf.setImage(with: URL(string:"https://cdn-icons-png.flaticon.com/512/5987/5987811.png"))
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
      
        
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

    
    @IBAction func selectProfilePicture(_ sender: Any) {
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

