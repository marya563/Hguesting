//
//  PaymentViewController.swift
//  hguesting
//
//  Created by Mac Mini 9 on 1/5/2023.
//

import UIKit
import Razorpay

class PaymentViewController: UIViewController , RazorpayPaymentCompletionProtocol {

    // typealias Razorpay = RazorpayCheckout

        var razorpay: RazorpayCheckout!
        override func viewDidLoad() {
            super.viewDidLoad()
            razorpay = RazorpayCheckout.initWithKey("rzp_test_fL7YlJwwZAK70X", andDelegate: self)
        }
        override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                self.showPaymentForm()
        }
    
    
    
    
    internal func showPaymentForm(){
        let options: [String:Any] = [
                    "amount": "100", //This is in currency subunits. 100 = 100 paise= INR 1.
                    "currency": "INR",//We support more that 92 international currencies.
                    "description": "Hotel booking",
                    "image": "https://url-to-image.jpg",
                    "name": "business or product name",
                    "prefill": [
                        "contact": "9999999999",
                        "email": "gaurav.kumar@exemple.com"
                    ],
                    "theme": [
                        "color": "#F37254"
                    ]
                ]
        razorpay.open(options)
    }
    
    func presentAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func onPaymentError(_ code: Int32, description str: String) {
            print("error: ", code, str)
            self.presentAlert(withTitle: "Alert", message: str)
        }

        func onPaymentSuccess(_ payment_id: String) {
            print("success: ", payment_id)
            self.presentAlert(withTitle: "Success", message: "Payment Succeeded")
        }

}
