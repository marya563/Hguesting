//
//  HomeViewController.swift
//  hguesting
//
//  Created by Mac Mini 9 on 11/4/2023.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var HomeCollectionView: UICollectionView!
    
    struct HomeCollectionItem {
        let title: String
        let image: UIImage
    }

  
    var homeCollectionImages = ["car","events","food","tour"]
    var homeCollectionItems = [
            HomeCollectionItem(title: "Cars", image: UIImage(named: "car")!),
            HomeCollectionItem(title: "Events", image: UIImage(named: "events")!),
            HomeCollectionItem(title: "Food", image: UIImage(named: "food")!),
            HomeCollectionItem(title: "Tour", image: UIImage(named: "tour")!)
        ]
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = homeCollectionItems[indexPath.row]
        switch indexPath.row {
        case 0: // Cars
            let carsViewController = CarsViewController(item: selectedItem)
            present(carsViewController, animated: true, completion: nil)
        case 1: // Events
            let eventsViewController = EventsViewController()
            present(eventsViewController, animated: true, completion: nil)
        case 2: // Food
            let serviceRoomViewController = ServiceRoomViewController()
            present(serviceRoomViewController, animated: true, completion: nil)
        case 3: // Tour
            let tourViewController = TourViewController()
            present(tourViewController, animated: true, completion: nil)
        default:
            break
        }
    }



    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("okok1")
        return homeCollectionImages.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("okok2")
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier:"homeCell",for:indexPath) as! HomeCollectionViewCell


            let image = homeCollectionImages[indexPath.row]
        // Add a drop shadow
        cell.background.alpha = 0.3
        cell.homeImageView.image = UIImage(named: image)
        cell.homeLabel.text = image


        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
