//
//  cardetailsViewController.swift
//  hguesting
//
//  Created by Mac Mini 9 on 17/4/2023.
//

import UIKit

class cardetailsViewController: UIViewController {

    @IBOutlet weak var carpic: UIImageView!
    @IBOutlet weak var carenginelabel: UILabel!
    
    
    @IBOutlet weak var carpricelabel: UILabel!
    
    @IBOutlet weak var cartypelabel: UILabel!
    @IBOutlet weak var carbrandlabel: UILabel!


   
    var carId: String?
    var car: Car?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadCarData()
        // Storing the carId in UserDefaults
        UserDefaults.standard.set(carId, forKey: "carId")

        // Retrieving the carId from UserDefaults
        

    }
    
    func loadCarData() {
            guard let carId = carId else {
                print("Error: carId not set")
                return
            }
            
            guard let url = URL(string: "http://127.0.0.1:3001/Car/getCarById/\(carId)") else { return }
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
                    print(self.car)
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
            guard let car = car else {
                print("Error: hotel not set")
                return
            }
     
        carbrandlabel.text = car.carbrand
        cartypelabel.text = car.cartype
        carenginelabel.text = car.carengine
        carpricelabel.text = "$" + String(car.carprice)
       
        carpic.kf.setImage(with: URL(string: car.carPic))
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueTorentalViewController" {
            let destinationVC = segue.destination as! rentalViewController
            destinationVC.carId = UserDefaults.standard.string(forKey: "carId")
        
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
      
        
    }
}
