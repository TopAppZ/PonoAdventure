//
//  NotificationViewController.swift
//  PonoAdventure
//
//  Created by Ria and Dev on 16/02/17.
//  Copyright © 2017 Agileinf. All rights reserved.
//

import UIKit
import CoreData
class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var notifications:[NotificationCoreData] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getNotifications()
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearAllAction(_ sender: Any) {
        let fetchRequest: NSFetchRequest<NotificationCoreData> = NotificationCoreData.fetchRequest()
        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        let managedObjectContext = getContext()
        do {
            _ = try managedObjectContext.execute(request)
        } catch {
            print("Error with request: \(error)")

        }
        getNotifications()
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell") as! NotificationTableViewCell!
        if (cell == nil) {
            cell = NotificationTableViewCell(style:.default, reuseIdentifier: "notificationCell")
        }
        cell?.notificationText.text = notifications[indexPath.row].text
        let timeInterval:TimeInterval = CFDateGetTimeIntervalSinceDate(Date() as CFDate!, notifications[indexPath.row].time_stamp)
        let second = timeInterval
        if second < 60 && second > 1 {
            cell?.timeIntervalText.text = "Now"
        }
        if second > 60 {
            let min = second / 60
            cell?.timeIntervalText.text = String(Int(min)) + " Minutes Ago"
            if min > 60 {
                let hour = min / 60
                cell?.timeIntervalText.text = String(Int(hour)) + " Hours Ago"
                if hour > 24 {
                    let day = hour / 24
                    cell?.timeIntervalText.text = String(Int(day)) + " Day Ago"
                }
            }
        }
        
        return cell!
    }
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    func getNotifications () {
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<NotificationCoreData> = NotificationCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time_stamp", ascending: false)]
        do {
            //go get the results
            let searchResults = try getContext().fetch(fetchRequest)
            self.notifications = searchResults
            //I like to check the size of the returned results!
            print ("num of results = \(searchResults.count)")
            //You need to convert to NSManagedObject to use 'for' loops
            UIApplication.shared.applicationIconBadgeNumber = searchResults.count
            for notification in searchResults as [NotificationCoreData] {
                //get the Key Value pairs (although there may be a better way to do that...
                print(notification.text!)
            }
        } catch {
            print("Error with request: \(error)")
        }
    }

}
