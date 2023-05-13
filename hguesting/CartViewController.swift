//
//  CartViewController.swift
//  hguesting
//
//  Created by Mac Mini 9 on 26/4/2023.
//

import UIKit
import Kingfisher

class CartViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var totalPriceLabel: UILabel!
    
    
    var cartItems: [CartItem] = []
    var cartManager = CartManager.shared // Get the shared instance

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartManager.cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartTableViewCell
        
               let item = cartManager.cart[indexPath.row]
                  cell.nameLabel.text = item.name
                  cell.priceLabel.text = String(item.price) + "$"
                  cell.quantityLabel.text = String(item.quantity)
                  cell.ImageView.kf.setImage(with: URL(string: item.image))
        
                cell.addButton.tag = indexPath.row
                cell.subtractButton.tag = indexPath.row
                
                cell.addButton.addTarget(self, action: #selector(addQuantityButtonTapped(_:)), for: .touchUpInside)
                cell.subtractButton.addTarget(self, action: #selector(subtractQuantityButtonTapped(_:)), for: .touchUpInside)
                
        
               return cell
    }
    
    @objc func addQuantityButtonTapped(_ sender: UIButton) {
        var item = cartManager.cart[sender.tag]
        item.quantity += 1
        cartManager.updateItem(at: sender.tag, withQuantity: item.quantity)
        totalPriceLabel.text = "Total Price: $\(cartManager.getTotalPrice())"

        tableView.reloadData()
    }

    @objc func subtractQuantityButtonTapped(_ sender: UIButton) {
        var item = cartManager.cart[sender.tag]
        item.quantity -= 1
        
        if item.quantity == 0 {
            cartManager.removeItem(at: sender.tag)
        } else {
            cartManager.updateItem(at: sender.tag, withQuantity: item.quantity)
        }
        totalPriceLabel.text = "Total Price: $\(cartManager.getTotalPrice())"

        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){
            (action, view, completionHandler) in
            self.cartManager.cart.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            self.totalPriceLabel.text = "Total Price: $\(self.cartManager.getTotalPrice())"

            completionHandler(true)
            
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalPriceLabel.text = "Total Price: $\(cartManager.getTotalPrice())"

        tableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")

        print (cartManager.cart)
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            tableView.reloadData()
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
