//
//  ServiceRoomViewController.swift
//  hguesting
//
//  Created by Mac Mini 9 on 15/4/2023.
//

import UIKit

class ServiceRoomViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var ServicesRoom:[ServiceRoom] = []

    @IBOutlet weak var ServiceRoomCollectionView: UICollectionView!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ServicesRoom.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier:"serviceRoomCell",for:indexPath) as! ServiceRoomCollectionViewCell


            let serviceRoom = ServicesRoom[indexPath.row]

        cell.nameLabel.text = serviceRoom.name

        cell.priceLabel.text = String(serviceRoom.price)

        // Add a drop shadow
        cell.imageLabel.kf.setImage(with: URL(string: serviceRoom.image))
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: "http://127.0.0.1:3001/roomservice/getRoomService") else { return }
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
                self.ServicesRoom = try decoder.decode([ServiceRoom].self, from: data)
                print(self.ServicesRoom)
                DispatchQueue.main.async {
                    self.ServiceRoomCollectionView.reloadData()
                }
                
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
            
            // Process the data here
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
