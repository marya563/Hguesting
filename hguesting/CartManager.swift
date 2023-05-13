//
//  CartManager.swift
//  hguesting
//
//  Created by Mac Mini 9 on 30/4/2023.
//

class CartManager {
    static let shared = CartManager()
    var cart = [CartItem]()
    
    private init() {}
    
    func addItem(_ item: CartItem) {
           if let index = cart.firstIndex(where: { $0.name == item.name }) {
               // Item already exists in cart, increase quantity by 1
               cart[index].quantity += 1
           } else {
               // Item does not exist in cart, add it
               cart.append(item)
           }
       }
       
       func removeItem(at index: Int) {
           cart.remove(at: index)
       }
       
       func updateItem(at index: Int, withQuantity quantity: Int) {
           cart[index].quantity = quantity
       }
    
       func getTotalPrice() -> Int {
            return cart.reduce(0) { $0 + $1.price * Int($1.quantity) }
        }
    
}
