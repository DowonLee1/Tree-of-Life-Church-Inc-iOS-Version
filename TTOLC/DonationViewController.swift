//
//  DonationViewController.swift
//  TTOLC
//
//  Created by Dowon on 5/15/20.
//  Copyright © 2020 Dowon. All rights reserved.
//

import UIKit
import PassKit
import AudioToolbox
import MessageUI

class DonationViewController: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var donationView: UIView!
    @IBOutlet var applePayView: UIView!
    @IBOutlet var bankTransferView: UIView!
    @IBOutlet weak var donationButton: UIButton!
    @IBOutlet weak var donationLabel1: UILabel!
    @IBOutlet weak var donationLabel2: UILabel!
    @IBOutlet weak var donationLabel3: UITextView!
    @IBOutlet weak var applePayButton: UIButton!
    @IBOutlet weak var bankButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    
    let notification = UINotificationFeedbackGenerator()
    private var payment : PKPaymentRequest = PKPaymentRequest()
    var amt: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ConfiguretapGesture()
        AudioServicesPlaySystemSound(1519)
        image.alpha = 0
        
        //Apple pay
        self.donationButton.addTarget(self, action: #selector(tapForPay), for: .touchUpInside)
        
        payment.merchantIdentifier = "merchant.com.dowon.ttolc"
        payment.supportedNetworks = [.quicPay, .masterCard, .visa]
        payment.supportedCountries = ["US"]
        payment.merchantCapabilities = .capability3DS
        payment.countryCode = "US"
        payment.currencyCode = "USD"

        
        //TextField Done Button Insert Code
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        doneButton.tintColor = UIColor.black
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        nameTextField.inputAccessoryView = toolbar
        typeTextField.inputAccessoryView = toolbar
        amountTextField.inputAccessoryView = toolbar
        
        self.donationLabel1.alpha = 0
        self.donationLabel2.alpha = 0
        self.donationLabel3.alpha = 0
        
        self.image.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        self.donationView.alpha = 0
        UIView.animate(withDuration: 1.2) {
            self.image.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.image.alpha = 1
            
        }
        UIView.animate(withDuration: 1.0, delay: 0.5 ,animations: {
            self.donationView.alpha = 1
            self.donationLabel1.alpha = 1
            self.donationLabel2.alpha = 1
            self.donationLabel3.alpha = 1
        })
        
        self.navigationController!.navigationBar.tintColor = .black
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        //self.navigationController?.isNavigationBarHidden = true
        
        donationView.translatesAutoresizingMaskIntoConstraints = false
        donationView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        donationView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        donationView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        donationView.heightAnchor.constraint(equalToConstant: donationView.frame.size.width * 1.091).isActive = true
        //        corner radius donationView
        self.donationView.layer.cornerRadius = self.donationView.frame.width/10.0
        self.donationView.clipsToBounds = true
        
        applePayView.translatesAutoresizingMaskIntoConstraints = false
        applePayView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        applePayView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        applePayView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        applePayView.heightAnchor.constraint(equalToConstant: donationView.frame.size.width * 1.091).isActive = true
        applePayView.alpha = 0
        self.applePayView.layer.cornerRadius = self.applePayView.frame.width/10.0
        self.applePayView.clipsToBounds = true
        
        bankTransferView.translatesAutoresizingMaskIntoConstraints = false
        bankTransferView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        bankTransferView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        bankTransferView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        bankTransferView.heightAnchor.constraint(equalToConstant: donationView.frame.size.width * 1.091).isActive = true
        self.bankTransferView.layer.cornerRadius = self.bankTransferView.frame.width/10.0
        self.bankTransferView.clipsToBounds = true
        bankTransferView.alpha = 0

        applePayButton.layer.borderWidth = 1
        applePayButton.layer.borderColor = UIColor.black.cgColor
        bankButton.layer.borderWidth = 1
        bankButton.layer.borderColor = UIColor.black.cgColor
        emailButton.layer.borderWidth = 1
        emailButton.layer.borderColor = UIColor.black.cgColor
        
        nameTextField.delegate = self
        typeTextField.delegate = self
        amountTextField.delegate = self
        
    }
    private func ConfiguretapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DonationViewController.doneClicked))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func doneClicked() {
        applePayView.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.scrollView.layoutIfNeeded()
        
        // Change Autoresizing property to true for animating scroll content offset
        applePayView.translatesAutoresizingMaskIntoConstraints = true
        scrollView.setContentOffset(CGPoint(x: 0, y: 300), animated: true)
        
        print("SCROLLED")
        print(scrollView.contentOffset.y)
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
                    alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
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
    @IBAction func applePayButtonClicked(_ sender: UIButton) {
        scrollView.addSubview(applePayView)
        nameTextField.text = ""
        typeTextField.text = ""
        amountTextField.text = ""
        AudioServicesPlaySystemSound(1519)
        UIView.animate(withDuration: 0.5) {
            self.applePayView.alpha = 1
        }
        UIView.animate(withDuration: 0, delay: 0.5 ,animations: {
            self.donationView.alpha = 0
        })
    }
    
    @IBAction func applePayBackButtonClicked(_ sender: UIButton) {
        AudioServicesPlaySystemSound(1519)
        self.donationView.alpha = 1
        UIView.animate(withDuration: 0.5) {
            self.applePayView.alpha = 0
        }
    }
    
    @IBAction func bankButtonClicked(_ sender: UIButton) {
        AudioServicesPlaySystemSound(1519)
        scrollView.addSubview(bankTransferView)
        UIView.animate(withDuration: 0.5) {
            self.bankTransferView.alpha = 1
        }
    }
    
    @IBAction func bankBackButtonClicked(_ sender: UIButton) {
        AudioServicesPlaySystemSound(1519)
        UIView.animate(withDuration: 0.5) {
            self.bankTransferView.alpha = 0
        }
    }
    
    @IBAction func emailButtonClicked(_ sender: Any) {
        if !MFMailComposeViewController.canSendMail() {
            emailButton.shake()
        }
        sendEmail()
        AudioServicesPlaySystemSound(1519)
    }
    
    private func sendEmail() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["info.ttolc@gmail.com"])
        composeVC.setSubject("Offering Questions")
        composeVC.setMessageBody("Hello Tree of life church, ", isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }

    private func mailComposeController(controller: MFMailComposeViewController,
                           didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismiss(animated: true, completion: nil)
    }

}
// Apple Pay
extension DonationViewController : PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        applePayBackButtonClicked(applePayButton)
    }
}

// Shaking Animation
public extension UIView {
    
    func shake(count : Float = 4,for duration : TimeInterval = 0.2,withTranslation translation : Float = 7) {
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.values = [translation, -translation]
        layer.add(animation, forKey: "shake")
    }
}
