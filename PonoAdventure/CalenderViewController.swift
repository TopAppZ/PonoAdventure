//
//  CalenderViewController.swift
//  PonoAdventure
//
//  Created by Ria and Dev on 07/01/17.
//  Copyright © 2017 Agileinf. All rights reserved.
//

import UIKit
import QuartzCore
class CalenderViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
    let reuseIdentifier = "cell"
    var items:[String] = []
    fileprivate let leftRightMargin = 1.0;
    fileprivate let numberOfCell = 8;
    fileprivate let heightAdjustment = 50.0;
    @IBOutlet weak var col: UICollectionView!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var monthYearLabel: UILabel!
    var months:[String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var availibility:[String] = []
    var currentYear = 2017
    var currentMonth = 2
    var place:Place?
    var shouldPerformSegue:Bool = false
    var selectedDate:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        availibility = (place?.schedule)!
        let width = (self.view.frame.width - CGFloat(leftRightMargin) * 7.0) / CGFloat(numberOfCell)
        let layout = self.col.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height:CGFloat(heightAdjustment))
        items = getAllDatesOfAMonth(currentMonth, currentYear)
        monthYearLabel.text = months[currentMonth-1] + ", " + String(currentYear)
        height.constant = CGFloat(heightAdjustment) * 7.0 + 10
        col.reloadData()
    }
    
    func getAllDatesOfAMonth(_ month:Int, _ year:Int) -> Array<String> {
        var startIndex = 0
        let fmt = DateFormatter()
        fmt.dateFormat = "dd/MM/yyyy"
        var startDate = fmt.date(from: "01/" + String(month) + "/" + String(year))
        let calendar = Calendar.current
        //let components = calendar.dateComponents([.year, .month, .day], from: startDate!)
        let range = calendar.range(of: .day, in: .month, for: startDate!)!
        var numDays = range.count
        //var endDate = fmt.date(from: String(numDays) + "/" + String(month) + "/" + String(year))
        let weekday = getDayOfWeek("01/" + String(month) + "/" + String(year))
        startIndex = weekday!
        var items = [String](repeating: "", count: numDays+weekday!)
        
        while 1 <= numDays {
            items[startIndex] = fmt.string(from: startDate!)
            //print(fmt.string(from: startDate!))
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate!)!
            numDays -= 1
            startIndex += 1
        }
        return items
    }
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay - 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CalenderCollectionViewCell
        cell.reloadInputViews()
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        if self.items[indexPath.row] != "" {
            let formatter  = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let date = formatter.date(from: self.items[indexPath.row])
            let calendar = Calendar.current
            let day = calendar.component(.day, from: date!)
            cell.dateLabel.text = String(day)
            if(isAvailable(date: date!, dates: availibility)){
                cell.dateLabelHolder.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                cell.dateLabel.textColor = UIColor.white
                cell.dateLabelHolder.layer.cornerRadius = cell.dateLabelHolder.frame.size.height / 2.5
            } else {
                cell.dateLabelHolder.backgroundColor = UIColor.clear
                cell.dateLabelHolder.layer.cornerRadius = 0
                cell.dateLabel.textColor = UIColor.black
            }
            
        } else {
            cell.dateLabel.text = ""
            cell.dateLabelHolder.backgroundColor = UIColor.clear
            cell.dateLabelHolder.layer.cornerRadius = 0
            cell.dateLabel.textColor = UIColor.black
        }
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView =
            collectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: "header", for: indexPath)
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: "header", for: indexPath) 
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
        return headerView
    }
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print(items[indexPath.item])
        self.selectedDate = items[indexPath.item]
        let formatter  = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = formatter.date(from: self.items[indexPath.row])
        if(isAvailable(date: date!, dates: availibility)){
            performSegue(withIdentifier: "toBookingForm", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBookingForm" {
            let dest = segue.destination as! BookingFormViewController
            dest.place = self.place
            dest.selectedDate = self.selectedDate
        }
    }
    
    @IBAction func prevMonthAction(_ sender: Any) {
        currentMonth -= 1
        if currentMonth < 1 {
            currentMonth = 12
            currentYear -= 1
        }
        monthYearLabel.text = months[currentMonth-1] + ", " + String(currentYear)
        items = getAllDatesOfAMonth(currentMonth, currentYear)
        monthYearLabel.text = months[currentMonth-1] + ", " + String(currentYear)
        height.constant = CGFloat(heightAdjustment) * 7.0 + 10
        col.reloadData()
    }
    
    @IBAction func nextMonthAction(_ sender: Any) {
        currentMonth += 1
        if currentMonth > 12 {
            currentMonth = 1
            currentYear += 1
        }
        monthYearLabel.text = months[currentMonth-1] + ", " + String(currentYear)
        items = getAllDatesOfAMonth(currentMonth, currentYear)
        monthYearLabel.text = months[currentMonth-1] + ", " + String(currentYear)
        height.constant = CGFloat(heightAdjustment) * 7.0 + 10
        col.reloadData()
    }
    func isAvailable(date:Date, dates:[String]) -> Bool{
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let convertedDate = formatter.string(from: date)
        print(dates)
        if dates.contains(convertedDate) {
            print("avail")
            return true
        }
        return false
    }
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }
    override func viewDidDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
    }
    
    
}
