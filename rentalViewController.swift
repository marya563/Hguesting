//
//  rentalViewController.swift
//  hguesting
//
//  Created by Mac Mini 9 on 30/4/2023.
//

import UIKit
import Razorpay

class rentalViewController: UIViewController , RazorpayProtocol{

    
    @IBOutlet var firstdate: UIDatePicker!
    
    @IBOutlet var lastdate: UIDatePicker!
    
    
    @IBOutlet var numberofdays: UITextField!
    
    @IBOutlet var Tprice: UITextField!
    @IBOutlet weak var carpic: UIImageView!
    @IBOutlet weak var carenginelabel: UILabel!
    
    
    @IBOutlet weak var carpricelabel: UILabel!
    
    @IBOutlet weak var cartypelabel: UILabel!
    @IBOutlet weak var carbrandlabel: UILabel!

    var razorpay: RazorpayCheckout!
    private let testKey = "rzp_test_FcETFNnEv4oWMb"

    let defaults = UserDefaults.standard
       var carId: String?
       var car: Car?
       var storedCarId: String?

       override func viewDidLoad() {
           super.viewDidLoad()
           razorpay = RazorpayCheckout.initWithKey(testKey, andDelegate: self)
           storedCarId = UserDefaults.standard.string(forKey: "carId")
           firstdate.minimumDate = Date()
           lastdate.minimumDate = Date()
           loadCarData()
       }
    
    
    
    @IBAction func payement(_ sender: UIButton) {
        createOrder()
    }
    
       
       @IBAction func dateChanged(_ sender: Any) {
           let calendar = Calendar.current
           let numberOfDays = calendar.dateComponents([.day], from: firstdate.date, to: lastdate.date).day ?? 0
           numberofdays.text = "\(numberOfDays)"
           if let car = car, let carPrice = Double(car.carprice) {
               let totalPrice = carPrice * Double(numberOfDays)
               Tprice.text = String(format: "$%.2f", totalPrice)
           }
       }

       func loadCarData() {
           guard let storedCarId = storedCarId else {
               print("Error: carId not set")
               return
           }
           guard let url = URL(string: "http://127.0.0.1:3001/Car/getCarById/\(storedCarId)") else { return }
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
                   self.car = try decoder.decode(Car.self, from: data)
                   DispatchQueue.main.async {
                       self.updateUI()
                   }
               } catch {
                   print("Error decoding JSON: \(error.localizedDescription)")
               }
           }
           task.resume()
       }
       
       func updateUI() {
           guard let car = car else {
               print("Error: car not set")
               return
           }
           carbrandlabel.text = car.carbrand
           cartypelabel.text = car.cartype
           carenginelabel.text = car.carengine
           carpricelabel.text = "$" + car.carprice
           carpic.kf.setImage(with: URL(string: car.carPic))
       }
   
    func updateNumberOfDays() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: firstdate.date, to: lastdate.date)
        let numberOfDays = components.day ?? 0
        numberofdays.text = "\(numberOfDays) day(s)"
        if let car = car,
           let carPrice = Double(car.carprice),
           let numberOfDays = Int(numberofdays.text ?? "") {
             let totalPrice = carPrice * Double(numberOfDays)
             Tprice.text = "$\(totalPrice)"
        }

    }
    // create order
    private func createOrder() {
        guard let carPrice = car?.carprice else {
            print("Error: hotel price not set")
            return
        }
        guard let carname = car?.cartype else {
            print("Error: hotel name not set")
            return
        }
        guard let carimage = car?.carPic else {
            print("Error: hotel image not set")
            return
        }
        
        let carPriceInt = Int(carPrice)!
        let amountInPaise = Int(carPriceInt * 100)
        // converting hotel price to paise
        let url = URL(string: "http://127.0.0.1:3001/create-order?amt=\(amountInPaise)")!

        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print("Order created successfully: \(String(describing: json))\n")
                if let orderId = json?["id"] as? String, let amount = json?["amount_due"] as? Int {
                    print("Order id is: \(orderId)")

                    let options: [String: Any] = [
                        "amount": amount, // This is in currency subunits. 100 = 100 paise= INR 1.
                        "currency": "INR", // We support more that 92 international currencies.
                        "description": "outsourcing IT Services",
                        "order_id": orderId,
                        "image": carimage,
                        "name": carname,
                        "prefill": [
                            "contact": "917428730894",
                            "email": "fedi.abdennabi@esprit.tn",
                        ],
                        "theme": [
                            "color": "#F37254",
                        ],
                    ]

                    DispatchQueue.main.async {
                        self.razorpay.open(options)
                    }
                } else {
                    print("oops..! cannot process your order")
                }
            } catch {
                print("oops..! cannot process your order")
            }
        }

        task.resume()
    }

   }

   extension rentalViewController: RazorpayPaymentCompletionProtocol {
       public func onPaymentError(_ code: Int32, description str: String) {
           let alertController = UIAlertController(title: "FAILURE", message: str, preferredStyle: .alert)
           let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
           alertController.addAction(cancelAction)
           view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
       }

       public func onPaymentSuccess(_ payment_id: String) {
           let alertController = UIAlertController(title: "SUCCESS", message: "Payment Id \(payment_id)", preferredStyle: .alert)
           let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
           alertController.addAction(cancelAction)
           view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
       }
   
}
