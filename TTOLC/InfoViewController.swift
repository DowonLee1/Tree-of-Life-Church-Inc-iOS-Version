//
//  InfoViewController.swift
//  TTOLC
//
//  Created by Dowon on 3/20/21.
//  Copyright © 2021 Dowon. All rights reserved.
//

import UIKit
import AudioToolbox
import Firebase

class InfoViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var secondActionButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageSegment: UISegmentedControl!
    @IBOutlet weak var textViewLabel: UITextView!
    
    var ref: DatabaseReference!
    var passedSectionTitle = ""
    var passedImage3Url = ""
    
    // DESCRIPTION TEXT
    var englishText = ""
    var koreanText = ""
    var spanishText = ""
    var indonesianText = ""
    var chineseText = ""
    
    // MAP DIRECTION INFO
    var latitude = NSNumber()
    var longitude = NSNumber()
    var mapTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetUp()
        changbleObjects()
    }
    
    private func layoutSetUp() {
        actionButton.layer.borderWidth = 1
        actionButton.layer.borderColor = UIColor.black.cgColor
        secondActionButton.layer.borderWidth = 1
        secondActionButton.layer.borderWidth = 1
    }
    
    private func changbleObjects() {
        if passedSectionTitle == "ABOUT US" {
            titleLabel.text = "INFORMATION"
            subTitleLabel.text = "THE TREE OF LIFE CHURCH"
            actionButton.setTitle("DIRECTION", for: .normal)
            secondActionButton.setTitle("OUR PASTOR", for: .normal)
            descriptionLabel.text = "SERVICE INFO"
    
            // taking description text from server
            ref = Database.database().reference().child("aboutUsDescription").child("information")
            ref.observe(DataEventType.childAdded, with: {(snapshot) in
            print(Thread.isMainThread)
                if let dict = snapshot.value as? [String: Any] {
                    let english = dict["englishText"] as! String
                    self.englishText = english
                    self.textViewLabel.text = self.englishText
                   
                    let korean = dict["koreanText"] as! String
                    self.koreanText = korean
                    let spanish = dict["spanishText"] as! String
                    self.spanishText = spanish
                    let indonesian = dict["indonesianText"] as! String
                    self.indonesianText = indonesian
                    let chinese = dict["chineseText"] as! String
                    self.chineseText = chinese
                }
            })
            
            // taking map direction from server
            ref = Database.database().reference().child("mapDirection")
            ref.observe(DataEventType.childAdded, with: {(snapshot) in
            print(Thread.isMainThread)
                if let dict = snapshot.value as? [String: Any] {
                    let latitudeNS = dict["latitude"] as! NSNumber
                    self.latitude = latitudeNS
                    let longitudeNS = dict["longitude"] as! NSNumber
                    self.longitude = longitudeNS
                    let titleString = dict["titleString"] as! String
                    self.mapTitle = titleString
                    
                }
            })
        }
        else if passedSectionTitle == "HISTORY OF REDEMPTION" {
            secondActionButton.center = actionButton.center
            actionButton.alpha = 0
            titleLabel.text = "INFORMATION"
            subTitleLabel.text = "HISTORY OF REDEMPTION SERIRES BOOK"
            secondActionButton.setTitle("ABOUT AUTHOR", for: .normal)
            descriptionLabel.text = "CONTENTS OF THE SEIRES BOOK"
            
            // taking description text from server
            ref = Database.database().reference().child("historyOfRedemptionDescription").child("information")
            ref.observe(DataEventType.childAdded, with: {(snapshot) in
            print(Thread.isMainThread)
                if let dict = snapshot.value as? [String: Any] {
                    let english = dict["englishText"] as! String
                    self.englishText = english
                    self.textViewLabel.text = self.englishText
                   
                    let korean = dict["koreanText"] as! String
                    self.koreanText = korean
                    let spanish = dict["spanishText"] as! String
                    self.spanishText = spanish
                    let indonesian = dict["indonesianText"] as! String
                    self.indonesianText = indonesian
                    let chinese = dict["chineseText"] as! String
                    self.chineseText = chinese
                }
            })
        }
    }
    @IBAction func actionButtonClicked(_ sender: UIButton) {
        let url = URL(string: "maps://?q=\(mapTitle)&ll=\(latitude),\(longitude)")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func secondActionButtonClicked(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "DetailBookViewController") as? DetailBookViewController else {
            return
        }
        vc.passedViewController = passedSectionTitle
        vc.passedImage3Url = passedImage3Url
        AudioServicesPlaySystemSound(1519)
        present(vc, animated: true)
    }
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            textViewLabel.text = englishText
        }
        else if sender.selectedSegmentIndex == 1 {
            textViewLabel.text = koreanText
        }
        else if sender.selectedSegmentIndex == 2 {
            textViewLabel.text = spanishText
        }
        if sender.selectedSegmentIndex == 3 {
            textViewLabel.text = indonesianText
        }
        if sender.selectedSegmentIndex == 4 {
            textViewLabel.text = chineseText
        }
        
        textViewLabel.alpha = 0
        AudioServicesPlaySystemSound(1519)
        UIView.animate(withDuration: 1.0) {
            self.textViewLabel.alpha = 1
        }
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
