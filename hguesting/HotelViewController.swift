//
//  HomeViewController.swift
//  hguesting
//
//  Created by Mac Mini 9 on 27/3/2023.
//

import UIKit
import Kingfisher

class HotelViewController:
    UIViewController,UICollectionViewDataSource,UICollectionViewDelegate , UITableViewDataSource,UITableViewDelegate {
    
    var hotels:[Hotel] = []
    var newHotels: [Hotel] = []

    @IBOutlet var hotelCollectionView: UICollectionView!
    @IBOutlet var hotelTableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
      
    }
    
    /* Collection View */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier:"hotelCell",for:indexPath) as! HotelCollectionViewCell

        print("***************** hotels ***********************")
            print(hotels)
        
        let hotel = hotels[indexPath.row]

        cell.nameLabel.text = hotel.name
        cell.adressLabel.text = hotel.adress
        cell.priceLabel.text = String(hotel.price)+"$/night"

        // Add a drop shadow
        cell.imageLabel.kf.setImage(with: URL(string: hotel.image))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get the selected hotel
        let selectedHotel = hotels[indexPath.row]
        // Create an instance of the details view controller and set its properties
        let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "HotelDetailsViewController") as! HotelDetailsViewController
        detailsViewController.hotelId = selectedHotel._id
        // Push the details view controller onto the navigation stack
        navigationController?.pushViewController(detailsViewController, animated: true)
    }

    /* Table View */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("this is the TABLE COUNT \(newHotels.count)")
            return newHotels.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        print("******************newHotels**********************")
            print(newHotels)
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "hotelTableCell", for: indexPath) as! hotelTableCell

            let hotel = newHotels[indexPath.row]
            
        cell.priceLabel.text = String(hotel.price)+"$/night"
        cell.adressLabel.text = hotel.adress
        cell.priceLabel.textColor = UIColor.black
        cell.imageLabel.kf.setImage(with: URL(string: hotel.image))
        cell.nameLabel.text = hotel.name
        return cell
    }

        // MARK: - UITableViewDelegate
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedHotel = newHotels[indexPath.row]
            let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "HotelDetailsViewController") as! HotelDetailsViewController
            detailsViewController.hotelId = selectedHotel._id
            navigationController?.pushViewController(detailsViewController, animated: true)
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
        
        // Load data for table view
           guard let tableViewUrl = URL(string: "http://127.0.0.1:3001/Hotel/getNewHotel") else {
               return
           }

           let tableViewSession = URLSession.shared
           let tableViewTask = tableViewSession.dataTask(with: tableViewUrl) { (data, response, error) in
               if let error = error {
                   print("Error loading table view data: \(error.localizedDescription)")
                   return
               }
               guard let httpResponse = response as? HTTPURLResponse,
                     (200...299).contains(httpResponse.statusCode) else {
                   print("Error loading table view data: invalid response")
                   return
               }
               guard let data = data else {
                   print("Error loading table view data: missing data")
                   return
               }
               do {
                   let decoder = JSONDecoder()

                   self.newHotels = try decoder.decode([Hotel].self, from: data)
                
                   // Update the UI on the main thread
                   DispatchQueue.main.async {
                       self.hotelTableView.reloadData()
                                          }
               } catch {
                   print("Error decoding table view JSON: \(error.localizedDescription)")
               }
           }
           tableViewTask.resume()
        
        
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
