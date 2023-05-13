//
//  EventDetailsViewController.swift
//  hguesting
//
//  Created by Mac Mini 9 on 7/5/2023.
//

import UIKit

class EventDetailsViewController: UIViewController {
    var eventId: String?
   
    
    @IBOutlet weak var eventdescriptionlabel: UILabel!

    
    @IBOutlet weak var eventtitlelabel: UILabel!
    @IBOutlet weak var eventdatelabel: UILabel!
   @IBOutlet weak var eventsPiclabel: UIImageView!
    var events: Events?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadeventsData()
        
        
    
        eventdescriptionlabel.textAlignment = .center
        eventdescriptionlabel.backgroundColor = .white
        eventdescriptionlabel.layer.cornerRadius = 600
        eventdescriptionlabel.layer.shadowColor = UIColor.black.cgColor
        eventdescriptionlabel.layer.shadowOpacity = 0.3
        eventdescriptionlabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        eventdescriptionlabel.layer.shadowRadius = 3
    
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
      
        
    }
    
    func loadeventsData() {
            guard let eventId = eventId else {
                print("Error: eventId not set")
                return
            }
            
            guard let url = URL(string: "http://127.0.0.1:3001/event/geteventsById/\(eventId)") else { return }
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
                    self.events = try decoder.decode(Events.self, from: data)
                    print(self.events)
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
            guard let events = events else {
                print("Error: hotel not set")
                return
            }
            
        eventdescriptionlabel.text = events.eventsdescription
        eventtitlelabel.text = events.eventtitle
        eventdatelabel.text = events.eventdate
        eventsPiclabel.kf.setImage(with: URL(string: events.eventsPic))
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
