//
//  ServiceRoomDetailsViewController.swift
//  hguesting
//
//  Created by Mac Mini 9 on 26/4/2023.
//

import UIKit

class ServiceRoomDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    var serviceRoomId: String?
    var serviceRoom: ServiceRoom?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadServiceRoomData()
        
    }
    
    func loadServiceRoomData() {
            guard let serviceRoomId = serviceRoomId else {
                print("Error: serviceRoomId not set")
                return
            }
            
            guard let url = URL(string: "http://127.0.0.1:3001/roomservice/getRoomServiceById/\(serviceRoomId)") else { return }
            let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("Error: invalid response")
                    return
                }
                guard let data = data else {
                    print("Error: missing data")
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    self.serviceRoom = try decoder.decode(ServiceRoom.self, from: data)
                    print(self.serviceRoom)
                    DispatchQueue.main.async {
                        self.updateUI()
                    }
                    
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
                
                // Process the data here
            }
            task.resume()
        }
    
    func updateUI() {
            guard let serviceRoom = serviceRoom else {
                print("Error: hotel not set")
                return
            }
            
            descriptionLabel.text = serviceRoom.description
            nameLabel.text = serviceRoom.name
            priceLabel.text = "$"+String(serviceRoom.price)
            imageView.kf.setImage(with: URL(string: serviceRoom.image))
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
