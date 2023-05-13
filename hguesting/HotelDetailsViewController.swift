//
//  HotelDetailsViewController.swift
//  hguesting
//
//  Created by Mac Mini 9 on 16/4/2023.
//

import UIKit
import Razorpay

class HotelDetailsViewController: UIViewController, RazorpayProtocol {

    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var goToMap: UIButton!
    var hotelId: String?
    var hotel: Hotel?
    var razorpay: RazorpayCheckout!
    private let testKey = "rzp_test_FcETFNnEv4oWMb"

    override func viewDidLoad() {
        super.viewDidLoad()
        razorpay = RazorpayCheckout.initWithKey(testKey, andDelegate: self)


        // Do any additional setup after loading the view.
        loadHotelData()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap", let destination = segue.destination as? MapViewController {
            destination.address = hotel?.adress
        }
    }
    
    @IBAction func HotelBook(_ sender: Any) {
            createOrder()
    }
    
    func loadHotelData() {
            guard let hotelId = hotelId else {
                print("Error: hotelId not set")
                return
            }
            
            guard let url = URL(string: "http://127.0.0.1:3001/Hotel/getHotelById/\(hotelId)") else { return }
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
                    self.hotel = try decoder.decode(Hotel.self, from: data)
                    print(self.hotel)
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
            guard let hotel = hotel else {
                print("Error: hotel not set")
                return
            }
            
            adressLabel.text = hotel.adress
            descriptionLabel.text = hotel.description
            nameLabel.text = hotel.name
            priceLabel.text = "$"+String(hotel.price)
            imageLabel.kf.setImage(with: URL(string: hotel.image))
        }
    
    // create order
    private func createOrder() {
        guard let hotelPrice = hotel?.price else {
            print("Error: hotel price not set")
            return
        }
        guard let hotelName = hotel?.name else {
            print("Error: hotel name not set")
            return
        }
        guard let hotelimage = hotel?.image else {
            print("Error: hotel image not set")
            return
        }
        
        let amountInPaise = Int(hotelPrice * 100) // converting hotel price to paise
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
                        "image": hotelimage,
                        "name": hotelName,
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

   extension HotelDetailsViewController: RazorpayPaymentCompletionProtocol {
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
