import UIKit
import Kingfisher



class CarsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate , UITableViewDataSource,UITableViewDelegate{
   
    
    var newcar: [Car] = []
    var cars: [Car] = []

    @IBOutlet weak var carCollectionView: UICollectionView!
    
    @IBOutlet var cartableview: UITableView!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cars.count
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Return the desired height for the cell at the given index path
        return 100.0 // Replace with your desired height
    }

    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get the selected hotel
        let selectedcar = cars[indexPath.row]
        // Create an instance of the details view controller and set its properties
        let carsdetailsViewController = storyboard?.instantiateViewController(withIdentifier: "cardetailsViewController") as! cardetailsViewController
        carsdetailsViewController.carId = selectedcar._id
        // Push the details view controller onto the navigation stack
        navigationController?.pushViewController(carsdetailsViewController, animated: true)
    }
    func setShadowAndCorner(for view: UIView) {
        // Set rounded corners
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        // Add shadow
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carCell", for: indexPath) as! CarCollectionViewCell
        setShadowAndCorner(for: cell)

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

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("this is the TABLE COUNT \(newcar.count)")
            return newcar.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        print("******************newcars**********************")
            print(newcar)
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "carTableCell", for: indexPath) as! carTableCell

            let car = newcar[indexPath.row]
            
        cell.priceLabel.text = String(car.carprice)+"$/night"
        cell.brandlabel.text = car.carbrand
        cell.typelabel.text = car.cartype
        cell.pic.kf.setImage(with: URL(string: car.carPic))
        cell.enginelabel.text = car.carengine
        return cell
    }

        // MARK: - UITableViewDelegate
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedcar = newcar[indexPath.row]
            let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "cardetailsViewController") as! cardetailsViewController
            detailsViewController.carId = selectedcar._id
            navigationController?.pushViewController(detailsViewController, animated: true)
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
    
    
    
    // Load data for table view
       guard let tableViewUrl = URL(string: "http://127.0.0.1:3001/Car/getNewcar") else {
           return
       }
    print(newcar)
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

               self.newcar = try decoder.decode([Car].self, from: data)
            
               // Update the UI on the main thread
               DispatchQueue.main.async {
            //       self.cartableview.reloadData()
        
                   print("cars \(self.newcar)")
                   
                   if let collectionView = self.cartableview {
                       collectionView.reloadData()
                   }
                                      }
           } catch {
               print("Error decoding table view JSON: \(error.localizedDescription)")
           }
       }
       tableViewTask.resume()
    
    
}
    
}
