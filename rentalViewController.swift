//
//  rentalViewController.swift
//  hguesting
//
//  Created by Mac Mini 9 on 30/4/2023.
//

import UIKit

class rentalViewController: UIViewController {

    
    @IBOutlet var firstdate: UIDatePicker!
    
    @IBOutlet var lastdate: UIDatePicker!
    
    
    @IBOutlet var numberofdays: UITextField!
    
    @IBOutlet var Tprice: UITextField!
    @IBOutlet weak var carpic: UIImageView!
    @IBOutlet weak var carenginelabel: UILabel!
    
    
    @IBOutlet weak var carpricelabel: UILabel!
    
    @IBOutlet weak var cartypelabel: UILabel!
    @IBOutlet weak var carbrandlabel: UILabel!


    let defaults = UserDefaults.standard
       var carId: String?
       var car: Car?
       var storedCarId: String?

       override func viewDidLoad() {
           super.viewDidLoad()
           storedCarId = UserDefaults.standard.string(forKey: "carId")
           firstdate.minimumDate = Date()
           lastdate.minimumDate = Date()
           loadCarData()
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
   
}
