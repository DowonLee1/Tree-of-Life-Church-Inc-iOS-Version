//
//  WebViewController.swift
//  TTOLCKoreanTableViewController
//
//  Created by Dowon on 5/13/20.
//  Copyright © 2020 Dowon. All rights reserved.
//

import UIKit
import CoreData
import youtube_ios_player_helper
import AudioToolbox
import MediaPlayer
import PassKit

class VideoViewController: UIViewController, YTPlayerViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var shareButtonImage: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bibleVerseLabel: UILabel!
    @IBOutlet weak var pastorNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var offeringButton: UIButton!
    @IBOutlet weak var videoView: YTPlayerView!
    @IBOutlet weak var nextVideoTable: UITableView!
    @IBOutlet weak var nextVideoTableTitleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var donationButton: UIButton!
    @IBOutlet weak var donationView: UIView!
    @IBOutlet weak var scrollBackgroundView: UIView!
    
    let notification = UINotificationFeedbackGenerator()
    private var payment : PKPaymentRequest = PKPaymentRequest()
    var amt: Int = 0
    
    var passedCaption = ""
    var passedBibleVerse = ""
    var passedPastorName = ""
    var passedDate = ""
    var passedUrl = ""
    var counter = 0
    var passedIndex = 0
    var passedPost = [Post]()
    var keyboardOn = false
    var toggleSwitch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSetUp()
        toolBarSetUp()
        applePaySetUp()
        MPVolumeView.setVolume(0.7)
    }

    private func layoutSetUp() {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        if view.frame.size.height <= view.frame.size.width * 2 {
            print("screen ratio is 16:9 as iphone 8")
            shareButtonImage.frame.size.height = 12
            shareButtonImage.frame.size.width = 13
        }
        // if screen ratio is 21:9
        else if view.frame.size.height >= view.frame.size.width * 2 {
            print("screen ratio is 21:9 as iphone x")
            shareButtonImage.frame.size.height = 13
            shareButtonImage.frame.size.width = 13
        }
        
        // for better touch response, separate image and button then make button size bigger than image.
        shareButton.center = shareButtonImage.center
        shareButton.frame.size.height = 30
        shareButton.frame.size.width = 30
        
        donationView.translatesAutoresizingMaskIntoConstraints = false
        donationView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        donationView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        donationView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        donationView.heightAnchor.constraint(equalToConstant: donationView.frame.size.width * 1.091).isActive = true
        
        detailView.translatesAutoresizingMaskIntoConstraints = false
        detailView.topAnchor.constraint(equalTo: videoView.bottomAnchor).isActive = true
        detailView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        detailView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        detailView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        offeringButton.translatesAutoresizingMaskIntoConstraints = false
        offeringButton.topAnchor.constraint(equalTo: detailView.bottomAnchor, constant: 10).isActive = true
        offeringButton.heightAnchor.constraint(equalToConstant: (offeringButton.frame.size.width / 7.6)).isActive = true
        offeringButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 17).isActive = true
        offeringButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -17).isActive = true
        
        videoView.delegate = self
        videoView.frame.size.width = screenWidth
        videoView.frame.size.height = CGFloat((screenWidth / 16) * 9.6)
        videoView.load(withVideoId: passedUrl, playerVars: ["playsinline": 1])
        
        nextVideoTable.delegate = self
        nextVideoTable.dataSource = self
        
        nextVideoTableTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        nextVideoTableTitleLabel.topAnchor.constraint(equalTo: offeringButton.bottomAnchor, constant: 10).isActive = true
        nextVideoTableTitleLabel.heightAnchor.constraint(equalToConstant: offeringButton.frame.size.height).isActive = true
        nextVideoTableTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        nextVideoTableTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        nextVideoTable.translatesAutoresizingMaskIntoConstraints = false
        nextVideoTable.topAnchor.constraint(equalTo: nextVideoTableTitleLabel.bottomAnchor).isActive = true
        nextVideoTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        nextVideoTable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        nextVideoTable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nextVideoTable.insertRows(at: [IndexPath(row: self.passedPost.count - 1, section: 0)], with: UITableView.RowAnimation.automatic)
    
        nameTextField.delegate = self
        typeTextField.delegate = self
        amountTextField.delegate = self
        
        self.donationView.layer.cornerRadius = self.donationView.frame.width/10.0
        self.donationView.clipsToBounds = true
                
        scrollView.alpha = 0
        scrollBackgroundView.alpha = 0
        
        titleLabel.text = passedCaption
        bibleVerseLabel.text = passedBibleVerse
        pastorNameLabel.text = passedPastorName
        dateLabel.text = passedDate
        
        // check the label line for proper layout
        if countLabelLines(label: titleLabel) == 2 {
            bibleVerseLabel.text = ""
        }
        else {
            titleLabel.text = passedCaption + "\n"
        }
        
        while (counter < passedIndex + 1) {
            passedPost.remove(at: 0)
            counter += 1
        }
        
    }
    
    private func toolBarSetUp() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        doneButton.tintColor = UIColor.black
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        nameTextField.inputAccessoryView = toolbar
        typeTextField.inputAccessoryView = toolbar
        amountTextField.inputAccessoryView = toolbar
    }
    
    private func applePaySetUp() {
        self.donationButton.addTarget(self, action: #selector(tapForPay), for: .touchUpInside)
        payment.merchantIdentifier = "merchant.com.dowon.ttolc"
        payment.supportedNetworks = [.quicPay, .masterCard, .visa]
        payment.supportedCountries = ["US"]
        payment.merchantCapabilities = .capability3DS
        payment.countryCode = "US"
        payment.currencyCode = "USD"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if passedPost.count > 10 {
            return 10
        }
        else {
            return passedPost.count
        }
        
    }
    
    func countLabelLines(label: UILabel) -> Int {
        // Call self.layoutIfNeeded() if your view uses auto layout
        let myText = label.text! as NSString

        let rect = CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font!], context: nil)

        return Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = nextVideoTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomVideoViewCell
        let url = URL(string: "https://drive.google.com/uc?export=view&id=\(passedPost[indexPath.row].imageUrl)")
        cell.thumbnailImage.loadImage(from: url!)
        cell.titleLabel.text = passedPost[indexPath.row].title
        cell.bibleVerseLabel.text = passedPost[indexPath.row].bibleVerse
        cell.pastorNameLabel.text = passedPost[indexPath.row].pastorName
        cell.dateLabel.text = passedPost[indexPath.row].date
        
        // check the label line for proper layout
        if countLabelLines(label: cell.titleLabel) == 2 {
            cell.bibleVerseLabel.text = ""
        }
        else {
            cell.titleLabel.text = passedPost[indexPath.row].title + "\n"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        videoView.load(withVideoId: passedPost[indexPath.row].url, playerVars: ["playsinline": 1])
        passedUrl = passedPost[indexPath.row].url
        titleLabel.text = passedPost[indexPath.row].title
        bibleVerseLabel.text = passedPost[indexPath.row].bibleVerse
        pastorNameLabel.text = passedPost[indexPath.row].pastorName
        dateLabel.text = passedPost[indexPath.row].date
        
        // check the label line for proper layout
        if countLabelLines(label: titleLabel) == 2 {
            bibleVerseLabel.text = ""
        }
        else {
            titleLabel.text = passedPost[indexPath.row].title + "\n"
        }
        
        dateLabel.textColor = .black
        AudioServicesPlaySystemSound(1519)
    
        self.nextVideoTableTitleLabel.alpha = 0
        self.detailView.alpha = 0
        self.offeringButton.alpha = 0
        self.nextVideoTable.alpha = 0
        
        UIView.animate(withDuration: 1.0) {
            self.nextVideoTableTitleLabel.alpha = 1
            self.detailView.alpha = 1
            self.offeringButton.alpha = 1
            self.nextVideoTable.alpha = 1
        }
        counter = 0
        while (counter < indexPath.row + 1) {
            passedPost.remove(at: 0)
            counter += 1
        }
        nextVideoTable.reloadData()
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        AudioServicesPlaySystemSound(1519)
        videoView.playVideo()
    }
    
    // check the live status
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        playerView.duration { (duration, error) in
            print("time: \(playTime) duration: \(duration)")
            if (duration == 0.0 || duration == 15.0){
                if self.toggleSwitch == false {
//                    print("It is live")
                    self.dateLabel.text = "LIVE STREAMING"
                    self.dateLabel.textColor = UIColor(red: 225/255, green: 0/255, blue: 0/255, alpha: 1.0)
                    self.dateLabel.alpha = 0
                    UIView.animate(withDuration: 1) {
                        self.dateLabel.alpha = 1
                    }
                    self.toggleSwitch = true
                }
            }
            else {
//                print("It is not live")
            }
        }
    }

    @IBAction func offeringButtonClicked(_ sender: UIButton) {
        AudioServicesPlaySystemSound(1519)
        // Change Autroresizing Property for animating scroll content offset
        donationView.translatesAutoresizingMaskIntoConstraints = true
        UIView.animate(withDuration: 0.5) {
            self.scrollBackgroundView.alpha = 0.6
            self.scrollView.alpha = 1
        }
    }
        
    @objc func doneClicked(_ recognizer: UITapGestureRecognizer) {
            donationView.endEditing(true)
    }
    
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        AudioServicesPlaySystemSound(1519)
        nameTextField.text = ""
        typeTextField.text = ""
        amountTextField.text = ""
        UIView.animate(withDuration: 0.5) {
            self.scrollBackgroundView.alpha = 0
            self.scrollView.alpha = 0
        }
    }
    
        func textFieldDidBeginEditing(_ textField: UITextField) {
            keyboardOn = true
            scrollView.setContentOffset(CGPoint(x: 0,y: 300), animated: true)
            amt = 0
            donationButton.isEnabled = false
            if textField == nameTextField {
                donationButton.setTitle("N A M E", for: .normal)
            }
            else if textField == typeTextField {
                donationButton.setTitle("T Y P E", for: .normal)
            }
            else if textField == amountTextField {
                donationButton.setTitle("A M O U N T", for: .normal)
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            keyboardOn = false
            scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
            donationButton.isEnabled = true
            donationButton.setTitle("G  I  V  E", for: .normal)
            
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
        // When text filed cleared make amount to "0"
        func textFieldShouldClear(_ textField: UITextField) -> Bool {
            if textField == textField {
                amt = 0
            }
            return true
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == amountTextField{
                    if let digit = Int(string) {
                        amt = amt * 10 + digit
                        if amt > 1000 {
                            let alert = UIAlertController(title: "Exceeding one time payment limit ($1.000.00)", message: nil, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
                            alert.view.tintColor = UIColor.black
                            present(alert, animated: true, completion: nil)
                            textField.text = ""
                            amt = 0
                        }
                        textField.text = updateAmount()
                    }
                    return false
                }
                else {
                    return true
                }
        //        if string == "" {
        //            amt = amt/10
        //            textField.text = updateAmount()
        //        }
            }
        
        func updateAmount() -> String? {
            if amt == 0 {
                return ""
            }
            else {
                let formatter = NumberFormatter()
                formatter.numberStyle = NumberFormatter.Style.currency
                return formatter.string(from: NSNumber(value: amt))
            }
        }

        // Apple Pay
        @objc func tapForPay(){
            let name = String(nameTextField.text!)
            let type = String(typeTextField.text!)
            var offeringLabel = ""
            if (name != "") {
                offeringLabel = name + "'s " + type + " OFFERING"
            }
            else {
                offeringLabel = type + " OFFERING"
            }
            
            if amt == 0 {
                amountTextField.shake()
                offeringButtonClicked(offeringButton)
                self.notification.notificationOccurred(.error)
                return
            }
            if !amountTextField.text!.isEmpty {
                self.notification.notificationOccurred(.error)
                let amount = amt
                print(amt)
                payment.paymentSummaryItems = [PKPaymentSummaryItem(label: offeringLabel, amount: NSDecimalNumber(integerLiteral: amount))]
                
                let controller = PKPaymentAuthorizationViewController(paymentRequest: payment)
                if controller != nil {
                    controller!.delegate = self
                    present(controller!, animated: true, completion: nil)
                }
            }
        }
    @IBAction func shareButtonClicked(_ sender: UIButton) {
        let items = ["https://www.youtube.com/watch?v=\(passedUrl)"]
        AudioServicesPlaySystemSound(1519)
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
}

// Apple Pay
extension VideoViewController : PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
        offeringButtonClicked(offeringButton)
        
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        nameTextField.text = ""
        typeTextField.text = ""
        amountTextField.text = ""
    }
}

