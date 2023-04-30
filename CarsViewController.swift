import UIKit
import Kingfisher



class CarsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
   
    

    var cars: [Car] = []

    @IBOutlet weak var carCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cars.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get the selected hotel
        let selectedCar = cars[indexPath.row]
        // Create an instance of the details view controller and set its properties
        let carsdetailsViewController = storyboard?.instantiateViewController(withIdentifier: "cardetailsViewController") as! cardetailsViewController
        carsdetailsViewController.carId = selectedCar._id
        // Push the details view controller onto the navigation stack
        navigationController?.pushViewController(carsdetailsViewController, animated: true)
    } 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carCell", for: indexPath) as! CarCollectionViewCell
        let car = cars[indexPath.row]
        cell.cartypeLabel.text = car.cartype
        cell.carbrandLabel.text = car.carbrand
        cell.carengineLabel.text = car.carengine
        cell.carpriceLabel.text = "$" + String(car.carprice)
        cell.carImageView.kf.setImage(with: URL(string: car.carPic))
        return cell
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
      
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
      
        print("View did load!")
        let url = URL(string: "http://127.0.0.1:3001/Car/getCar")
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Error: invalid response")
                return
            }
            guard let data = data else {
                print("Error: missing data")
                return
            }
            do {
                let decoder = JSONDecoder()
                let cars = try decoder.decode([Car].self, from: data)
                DispatchQueue.main.async {
                    self.cars = cars
                    print("cars \(self.cars)")
                    
                    if let collectionView = self.carCollectionView {
                        collectionView.reloadData()
                    }
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
