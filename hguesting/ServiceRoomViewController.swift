//
//  ServiceRoomViewController.swift
//  hguesting
//
//  Created by Mac Mini 9 on 15/4/2023.
//

import UIKit

class ServiceRoomViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var ServiceRoomCollectionView: UICollectionView!
    var ServicesRoom:[ServiceRoom] = []
    var cart = [CartItem]()
    var cartManager = CartManager.shared // Get the shared instance

    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
      
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ServicesRoom.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier:"serviceRoomCell",for:indexPath) as! ServiceRoomCollectionViewCell


            let serviceRoom = ServicesRoom[indexPath.row]

        cell.nameLabel.text = serviceRoom.name

        cell.priceLabel.text = String(serviceRoom.price)+"$"

        // Add a drop shadow
        cell.imageLabel.kf.setImage(with: URL(string: serviceRoom.image))
        cell.addToCartButton.tag = indexPath.row
        cell.addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped(_:)), for: .touchUpInside)

        
        return cell
    }
    
    @objc func addToCartButtonTapped(_ sender: UIButton) {
        let serviceRoom = ServicesRoom[sender.tag]
        let cartItem = CartItem(name: serviceRoom.name, image: serviceRoom.image, price: serviceRoom.price, quantity: 1)
        
        // Check if the item is already in the cart
        if let existingItemIndex = cartManager.cart.firstIndex(where: { $0.name == cartItem.name }) {
            let existingItem = cartManager.cart[existingItemIndex]
            let newQuantity = existingItem.quantity + 1
            cartManager.updateItem(at: existingItemIndex, withQuantity: newQuantity)
            ServiceRoomCollectionView.reloadData()
            
            // Show an alert to confirm the item was added to the cart
            let alert = UIAlertController(title: "Item Added to Cart", message: "The item '\(existingItem.name)' is already in your cart. The quantity has been updated to \(newQuantity).", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {
            cartManager.addItem(cartItem)
            ServiceRoomCollectionView.reloadData()
            
            // Show an alert to confirm the item was added to the cart
            let alert = UIAlertController(title: "Item Added to Cart", message: "The item '\(cartItem.name)' has been added to your cart.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCart" {
            let cartVC = segue.destination as! CartViewController
            cartVC.cartItems = cartManager.cart
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get the selected hotel
        let selectedServicesRoom = ServicesRoom[indexPath.row]
        // Create an instance of the details view controller and set its properties
        let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "ServiceRoomDetailsViewController") as! ServiceRoomDetailsViewController
        detailsViewController.serviceRoomId = selectedServicesRoom._id
        // Push the details view controller onto the navigation stack
        navigationController?.pushViewController(detailsViewController, animated: true)
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
