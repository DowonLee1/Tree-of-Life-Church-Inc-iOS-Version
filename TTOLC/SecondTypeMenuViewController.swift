//
//  HistoryOfRedemtionViewController.swift
//  TTOLC
//
//  Created by Dowon on 8/28/20.
//  Copyright © 2020 Dowon. All rights reserved.
//

import UIKit
import AudioToolbox
import MessageUI
import Firebase

class SecondTypeMenuViewController: UIViewController, UIScrollViewDelegate, MFMailComposeViewControllerDelegate{

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var secondActionButton: UIButton!
    
    @IBOutlet weak var shareButtonImage: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var paddingView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageSegment: UISegmentedControl!
    @IBOutlet weak var textViewLabel: UITextView!
    @IBOutlet weak var sinceLabel: UILabel!

    var ref: DatabaseReference!
    var englishText = ""
    var koreanText = ""
    var spanishText = ""
    var indonesianText = ""
    var chineseText = ""
    
    var passedSectionTitle = ""
    var passedImage2Url = ""
    var passedImage3Url = ""
    var passedIndex = 0
    var passedMainMenu = [MainMenu]()
    var navBackground = UIView()
    var statusBackground = UIView()
    var animationView = UIView()
    var shareButtonUrl = ""
    let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetUp()
        initialAnimation()
        changbleObjects()
    }
    
    private func changbleObjects() {
        if passedSectionTitle == "ABOUT US" {
            titleLabel.text = "ABOUT US"
            subTitleLabel.text = "THE TREE OF LIFE CHURCH"
            image.image = UIImage(named: "about")
            actionButton.setTitle("CONTACT US", for: .normal)
            secondActionButton.alpha = 1
            secondActionButton.setTitle("INFORMATION", for: .normal)
            sinceLabel.text = "SINCE 2016 04 17"
            
            // taking description text from server
            ref = Database.database().reference().child("aboutUsDescription").child("description")
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
        else if passedSectionTitle == "MISSIONARY" {
            titleLabel.text = "MISSIONARY"
            subTitleLabel.text = "BY TREE OF LIFE CHURCH"
            image.image = UIImage(named: "")
            actionButton.setTitle("CONTACT US", for: .normal)
            sinceLabel.text = "SINCE 2016 10 23"
            textViewLabel.text = ""
        }
        else if passedSectionTitle == "HISTORY OF REDEMPTION" {
            titleLabel.text = "HISTORY OF REDEMPTION SERIES BOOK"
            subTitleLabel.text = "BY REV. DR. ABRAHAM PARK"
            image.image = UIImage(named: "histBooks")
            actionButton.setTitle("ABOUT BOOKS", for: .normal)
            secondActionButton.alpha = 1
            secondActionButton.setTitle("INFORMATION", for: .normal)
            sinceLabel.text = "SINCE 2007 10 27"
            
            // taking description text from server
            ref = Database.database().reference().child("historyOfRedemptionDescription").child("description")
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
    
    private func initialAnimation() {
        image.alpha = 0
        scrollView.alpha = 0
        UIView.animate(withDuration: 1.0) {
            self.animationView.alpha = 0
            self.image.alpha = 1
            self.scrollView.alpha = 1
        }
    }
    
    private func layoutSetUp() {
        animationView.frame.size.width = view.frame.size.width
        animationView.frame.size.height = view.frame.size.height
        animationView.backgroundColor = .white
        view.addSubview(animationView)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight).isActive = true
        image.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        image.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        image.heightAnchor.constraint(equalToConstant: CGFloat(Int(view.frame.size.height / 1.28))).isActive = true
        
        shareButtonImage.frame.size.height = 14
        shareButtonImage.frame.size.width = 13
        shareButton.center = shareButtonImage.center
        shareButton.frame.size.height = 30
        shareButton.frame.size.width = 30
        
        
        
        let navBarHeight = statusBarHeight +
           (navigationController?.navigationBar.frame.height ?? 0.0)
        actionButton.layer.borderWidth = 1
        actionButton.layer.borderColor = UIColor.black.cgColor
        secondActionButton.layer.borderWidth = 1
        secondActionButton.layer.borderWidth = 1
        secondActionButton.alpha = 0
        
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: navBarHeight).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // if screen ratio is 16:9
        if view.frame.size.height <= view.frame.size.width * 2{
            print("screen ratio is 16:9 as iphone 8")
            scrollView.contentSize = CGSize(width: view.frame.size.width, height: paddingView.frame.size.height + contentView.frame.size.height - navBarHeight + ((statusBarHeight) * 3))
        }
        // if screen ratio is 21:9
        else if view.frame.size.height >= view.frame.size.width * 2{
            print("screen ratio is 21:9 as iphone x")
            scrollView.contentSize = CGSize(width: view.frame.size.width, height: paddingView.frame.size.height + contentView.frame.size.height - navBarHeight + ((statusBarHeight / 5) * 2))
        }
        scrollView.delegate = self
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.heightAnchor.constraint(equalToConstant: CGFloat(scrollView.frame.size.height)).isActive = true
        contentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: paddingView.bottomAnchor).isActive = true
//        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
//        contentView.layer.shadowOpacity = 0.2
//        contentView.layer.shadowColor = UIColor.black.cgColor
        
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        paddingView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        paddingView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        paddingView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        paddingView.heightAnchor.constraint(equalToConstant: CGFloat(view.frame.size.height / 1.628)).isActive = true
        
        textViewLabel.translatesAutoresizingMaskIntoConstraints = false
        textViewLabel.topAnchor.constraint(equalTo: languageSegment.bottomAnchor , constant: 10).isActive = true
        textViewLabel.leftAnchor.constraint(equalTo: languageSegment.leftAnchor).isActive = true
        textViewLabel.rightAnchor.constraint(equalTo: languageSegment.rightAnchor).isActive = true
        textViewLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        navBackground.backgroundColor = .white
        navBackground.frame.size.width = view.frame.size.width
        navBackground.frame.size.height = navBarHeight
        navBackground.alpha = 0
        view.addSubview(navBackground)
        
        statusBackground.backgroundColor = .white
        statusBackground.frame.size.width = view.frame.size.width
        statusBackground.frame.size.height = statusBarHeight
        view.addSubview(statusBackground)
    }
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            textViewLabel.text = englishText
            textViewLabel.alpha = 0
            AudioServicesPlaySystemSound(1519)
            UIView.animate(withDuration: 1.0) {
                self.textViewLabel.alpha = 1
            }
        }
        else if sender.selectedSegmentIndex == 1 {
            textViewLabel.text = koreanText
            textViewLabel.alpha = 0
            AudioServicesPlaySystemSound(1519)
            UIView.animate(withDuration: 1.0) {
                self.textViewLabel.alpha = 1
            }
        }
        else if sender.selectedSegmentIndex == 2 {
            textViewLabel.text = spanishText
            textViewLabel.alpha = 0
            AudioServicesPlaySystemSound(1519)
            UIView.animate(withDuration: 1.0) {
                self.textViewLabel.alpha = 1
            }
        }
        else if sender.selectedSegmentIndex == 3 {
            textViewLabel.text = indonesianText
            textViewLabel.alpha = 0
            AudioServicesPlaySystemSound(1519)
            UIView.animate(withDuration: 1.0) {
                self.textViewLabel.alpha = 1
            }
        }
        else if sender.selectedSegmentIndex == 4 {
            textViewLabel.text = chineseText
            textViewLabel.alpha = 0
            UIView.animate(withDuration: 1.0) {
                self.textViewLabel.alpha = 1
            }
        }
    }
    
    @IBAction func actionButtonClicked(_ sender: UIButton) {
        if passedSectionTitle != "HISTORY OF REDEMPTION" {
            if !MFMailComposeViewController.canSendMail() {
                actionButton.shake()
            }
            sendEmail()
            AudioServicesPlaySystemSound(1519)
        }
        else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "CollectionViewController") as? CollectionViewController
            AudioServicesPlaySystemSound(1519)
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    @IBAction func secondActionButtonClicked(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "InfoViewController") as? InfoViewController else {
            return
        }
        vc.passedSectionTitle = passedSectionTitle
        vc.passedImage3Url = passedImage3Url
        AudioServicesPlaySystemSound(1519)
        present(vc, animated: true)
    }
    
    
    @IBAction func shareButtonClicked(_ sender: UIButton) {
        if passedSectionTitle == "ABOUT US" {
            shareButtonUrl = "http://nytreeoflife.com/"
        }
        if passedSectionTitle == "MISSIONARY" {
            shareButtonUrl = "http://nytreeoflife.com/missions-2/"
        }
        if passedSectionTitle == "HISTORY OF REDEMPTION BOOK" {
            shareButtonUrl = "http://horaministries.com/about-the-books/"
        }
        let items = [shareButtonUrl]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
        AudioServicesPlaySystemSound(1519)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let alpha: CGFloat = abs(1 - ((scrollView.contentOffset.y + paddingView.frame.size.height) / paddingView.frame.size.height))
        let fade: CGFloat = abs(2 - ((scrollView.contentOffset.y + paddingView.frame.size.height) / paddingView.frame.size.height))
        image.transform = CGAffineTransform(scaleX: 0.8 + ((fade / 10) * 2), y: 0.8 + ((fade / 10) * 2))
        navBackground.alpha = alpha
        if (alpha >= 0.99 && alpha <= 1.00) || (alpha == 0) {
            AudioServicesPlaySystemSound(1519)
        }
    }
    
    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["info.ttolc@gmail.com"])
            mail.setSubject("Request")
            mail.setMessageBody("Hello Tree of life church, ", isHTML: true)

            present(mail, animated: true)
        } else {
            let alert = UIAlertController(title: "Setup Your Email on Mail App", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
            alert.view.tintColor = UIColor.black
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    
//    private func sendEmail() {
//        let composeVC = MFMailComposeViewController()
//        composeVC.mailComposeDelegate = self
//        // Configure the fields of the interface.
//        composeVC.setToRecipients(["info.ttolc@gmail.com"])
//        composeVC.setSubject("Request")
//        composeVC.setMessageBody("Hello Tree of life church, ", isHTML: false)
//        // Present the view controller modally.
//        self.present(composeVC, animated: true, completion: nil)
//    }

    private func mailComposeController(controller: MFMailComposeViewController,
                           didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension SecondTypeMenuViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
}
