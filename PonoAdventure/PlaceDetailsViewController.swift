//
//  PlaceDetailsViewController.swift
//  PonoAdventure
//
//  Created by Ria and Dev on 19/10/16.
//  Copyright © 2016 Agileinf. All rights reserved.
//

import UIKit
import Kingfisher
import PopupDialog
import QuartzCore
class PlaceDetailsViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var bookButton: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var playBtn: UIButton!
    var place:Place?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.placeName.text = (place?.name)!
        self.distance.text = String(format: "%.2f", (place?.distance)!) + " KM"
        self.address.text = (place?.address_1)! + ", " + (place?.address_2)! + ", " + (place?.state)! + ", " + (place?.zip)!
        self.desc.text = (place?.description)!
        let imageURL = URL(string: (place?.imagePath)!)
        image.kf.setImage(with: imageURL)
        if (place?.price)! != "NA" {
            self.price.text = "$" + (place?.price)! + "/per person"
        } else {
            self.bookButton.isHidden = true
        }
        if  place?.videoURL == "NA" {
            playBtn.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.contentView.frame.size.height + desc.frame.size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func actionBack(_ sender: AnyObject) {
        dismiss(animated: true) {
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBooking" {
            let dest = segue.destination as! CalenderViewController
            dest.place = place
        }
        if segue.identifier == "toDirection" {
            let dest = segue.destination as! DirectionViewController
            dest.place = place
        }
    }
    
    @IBAction func playAction(_ sender: Any) {
        // Create a custom view controller
        let youtubePlayerController = YoutubePlayerViewController(nibName: "YoutubePlayerView", bundle: nil)
        youtubePlayerController.youtubeURL = place?.videoURL
        self.definesPresentationContext = true
        youtubePlayerController.modalPresentationStyle = .overCurrentContext
        youtubePlayerController.modalTransitionStyle = .crossDissolve
        self.present(youtubePlayerController, animated: true) {
            
        }
        
    }
    

}
