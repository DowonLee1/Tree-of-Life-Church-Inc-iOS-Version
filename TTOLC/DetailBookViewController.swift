//
//  DetailBookViewController.swift
//  TTOLC
//
//  Created by Dowon on 9/4/20.
//  Copyright © 2020 Dowon. All rights reserved.
//

import UIKit
import AudioToolbox
import MessageUI

class DetailBookViewController: UIViewController, MFMailComposeViewControllerDelegate{

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var buyingButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    var passedHorBooks = [HorBooks]()
    var passedIndex = 0
    
    var passedViewController = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSetUp()
        changableObjects()
    }
    
    private func changableObjects() {
        if passedViewController == "ABOUT US" {
            let url = URL(string: "https://drive.google.com/uc?export=view&id=\("1L-Rk_oHKz6YXItFjOwvwwSn94Jv2ypBj")")
            image.loadImage(from: url!)
            
            titleLabel.text = "REV.JOHN LEE"
            detailLabel.text = "이은식 목사님"
            buyingButton.setTitle("LEAD PASTOR", for: .normal)
            buyingButton.isEnabled = false
        }
       
        else if passedViewController == "HISTORY OF REDEMPTION" {
            let url = URL(string: "https://drive.google.com/uc?export=view&id=\("12m6LNmw6s7Nq63-W9tD3loH_jUxoeDp_")")
            image.loadImage(from: url!)
            
            titleLabel.text = "REV.DR.ABRAHAM PARK"
            detailLabel.text = "박윤식 원로목사님"
            buyingButton.setTitle("AUTHOR", for: .normal)
            buyingButton.isEnabled = false
        }
        
        else {
            let url = URL(string: "https://drive.google.com/uc?export=view&id=\(passedHorBooks[passedIndex].image2Url)")
            image.loadImage(from: url!)
        
            titleLabel.text = passedHorBooks[passedIndex].bookTitle
            detailLabel.text = passedHorBooks[passedIndex].detailTitle
            descriptionTextView.text = passedHorBooks[passedIndex].description
        }
        
    }
    
    private func layoutSetUp() {
        image.translatesAutoresizingMaskIntoConstraints = false
        image.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        image.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        image.heightAnchor.constraint(equalToConstant: image.frame.size.width / 1.38).isActive = true
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: image.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        
        
//        detailLabel.translatesAutoresizingMaskIntoConstraints = false
//        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
//        detailLabel.leftAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        
//        buyingButton.frame.size.width = view.frame.size.width / 3.47
//        buyingButton.frame.size.height = buyingButton.frame.size.height / 2.38
        buyingButton.layer.borderWidth = 1
        buyingButton.layer.borderColor = UIColor.black.cgColor
            
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowColor = UIColor.black.cgColor
    }
    
    @IBAction func shareButtonClicked(_ sender: UIButton) {
    let items = ["http://horaministries.com/about-the-books/"]
    let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
    AudioServicesPlaySystemSound(1519)
    present(ac, animated: true)
    }
    
    @IBAction func buyButtonClicked(_ sender: UIButton) {
        if !MFMailComposeViewController.canSendMail() {
            buyingButton.shake()
        }
        sendEmail()
        AudioServicesPlaySystemSound(1519)
    }
    
    private func sendEmail() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["info.ttolc@gmail.com"])
        composeVC.setSubject("Request Buying \(passedHorBooks[passedIndex].bookTitle)")
        composeVC.setMessageBody("Hello Tree of life church, ", isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }

    private func mailComposeController(controller: MFMailComposeViewController,
                           didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismiss(animated: true, completion: nil)
    }

}
