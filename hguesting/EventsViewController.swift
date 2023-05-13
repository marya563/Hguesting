//
//  EventsViewController.swift
//  hguesting
//
//  Created by Mac Mini 9 on 15/4/2023.
//

import UIKit
import Kingfisher

class EventsViewController:  UIViewController, UITableViewDataSource,UITableViewDelegate  {
    
 

  
    var Event:[Events] = []
  

    @IBOutlet var eventsTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
     

      
    }
   
   
   

  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Set the row height
     
       // Return the desired height for the cell at the given index path
        return 150.0// Replace with your desired height
   }
   


    /* Table View */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("this is the TABLE COUNT \(Event.count)")
            return Event.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        print("******************newHotels**********************")
            print(Event)
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventTableCell", for: indexPath) as! eventTableCell
       
        // Add space to the left, right, and bottom edges of the cell content
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        
        // Adjust the frame of the cell to add space to the bottom
        let spacing: CGFloat = 30
        let frame = cell.frame
        cell.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height + spacing)

       

           cell.contentView.layer.cornerRadius = 20
           cell.contentView.layer.masksToBounds = true
           cell.contentView.layer.shadowColor = UIColor.black.cgColor
           cell.contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
           cell.contentView.layer.shadowOpacity = 0.4
           cell.contentView.layer.shadowRadius = 2

            let event = Event[indexPath.row]
        
            
        cell.eventtitlelabel.text = event.eventtitle
        cell.eventsPiclabel.kf.setImage(with: URL(string: event.eventsPic))
        cell.eventdatelabel.text = event.eventdate
        return cell
    }

        // MARK: - UITableViewDelegate
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedevent = Event[indexPath.row]
            let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "EventDetailsViewController") as! EventDetailsViewController
            detailsViewController.eventId = selectedevent._id
            navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()

          
        
        // Load data for table view
           guard let tableViewUrl = URL(string: "http://127.0.0.1:3001/event/getevents") else {
               return
           }

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

                   self.Event = try decoder.decode([Events].self, from: data)
                
                   // Update the UI on the main thread
                   DispatchQueue.main.async {
                       self.eventsTableView.reloadData()
                                          }
               } catch {
                   print("Error decoding table view JSON: \(error.localizedDescription)")
               }
           }
           tableViewTask.resume()
        
        
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
