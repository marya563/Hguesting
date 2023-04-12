//
//  UpdateprofilViewController.swift
//  hguesting
//
//  Created by Mac Mini 9 on 12/4/2023.
//

import UIKit
import SwiftUI
import MobileCoreServices
class UpdateprofilViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet var profileImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        // Do any additional setup after loading the view.
    }
    
  

    @IBAction func selectImageTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage else {
            print("Error: Could not retrieve image")
            return
        }
        
        // Upload the image to the server using your existing update method
        uploadImageToServer(image: image)
    }
    func uploadImageToServer(image: UIImage) {
        guard let imageData = image.pngData() else {
            print("Error: Could not convert image to PNG data")
            return
        }
        
        // Create the URL for the PUT request
        guard let url = URL(string: "http://127.0.0.1:3001/user/updateUserrById/:id") else {
            print("Error: Could not create URL")
            return
        }
        
        // Create the request and set the HTTP method and headers
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("image/png", forHTTPHeaderField: "Content-Type")
        request.setValue("\(imageData.count)", forHTTPHeaderField: "Content-Length")
        
        // Create the URLSession and data task to send the request
        let session = URLSession.shared
        let task = session.uploadTask(with: request, from: imageData) { (data, response, error) in
            // Handle the response from the server
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let data = data, let response = response as? HTTPURLResponse {
                print("Response: \(response.statusCode)")
                print("Data: \(String(data: data, encoding: .utf8) ?? "")")
            }
        }
        task.resume()
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
