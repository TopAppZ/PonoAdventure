//
//  YoutubePlayerViewController.swift
//  PonoAdventure
//
//  Created by Ria and Dev on 20/02/17.
//  Copyright © 2017 Agileinf. All rights reserved.
//

import UIKit
import QuartzCore
import YouTubePlayer
class YoutubePlayerViewController: UIViewController, UIGestureRecognizerDelegate {
    var youtubeURL:String?
    
    @IBOutlet weak var player: YouTubePlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing(_:))))
        let myVideoURL = NSURL(string: youtubeURL!)
        player.loadVideoURL(myVideoURL! as URL)
        player.play()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func endEditing(_ sender: UITapGestureRecognizer) {
        
        dismiss(animated: true) {
        
        }
        
    }
}
