//
//  HomeViewController.swift
//  hguesting
//
//  Created by Mac Mini 9 on 27/3/2023.
//

import UIKit
import Kingfisher

class HotelViewController:
    UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
     var hotels:[Hotel] = []
    
    @IBOutlet var hotelCollectionView: UICollectionView!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier:"hotelCell",for:indexPath) as! HotelCollectionViewCell


            let hotel = hotels[indexPath.row]

        cell.nameLabel.text = hotel.name

        cell.priceLabel.text = String(hotel.price)

        // Add a drop shadow
        cell.imageLabel.kf.setImage(with: URL(string: hotel.image))
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: "http://127.0.0.1:3001/Hotel/getHotel") else { return }
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
                self.hotels = try decoder.decode([Hotel].self, from: data)
                print(self.hotels)
                DispatchQueue.main.async {
                    self.hotelCollectionView.reloadData()
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
