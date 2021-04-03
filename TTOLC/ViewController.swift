//
//  ViewController.swift
//  TTOLC
//
//  Created by Dowon on 5/13/20.
//  Copyright © 2020 Dowon. All rights reserved.
//

import UIKit
import AudioToolbox
import Firebase

class ViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var sectionTable: UITableView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var underbar: UIView!
    @IBOutlet weak var sermonButtonView: UIView!
    @IBOutlet weak var pagecontrol: UIPageControl!
    
    let currentVersion = "1.0"
    func checkLatestVersion() {
        ref = Database.database().reference().child("currentVersion")
        ref.observe(DataEventType.childAdded, with: { [self](snapshot) in
                print(Thread.isMainThread)
                if let dict = snapshot.value as? [String: Any] {
                    let latestVersionString = dict["latestVersion"] as! String
                    let appStoreIdString = dict["appStoreId"] as! String
                    
                    // The alert keeps popping up until the latest version is installed
                    if currentVersion != latestVersionString  {
                        self.mainView.alpha = 0
                        let alert = UIAlertController(title: "A new version has been released so please update it", message: nil, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Update", style: UIAlertAction.Style.default, handler: {_ in
                            let url  = NSURL(string: "itms-apps://itunes.apple.com/app/id" + appStoreIdString)
                            if UIApplication.shared.canOpenURL(url! as URL) == true  {
                                UIApplication.shared.open(url! as URL)
                            }
                        }))
                        alert.view.tintColor = UIColor.black
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }
    
    var mainMenu = [MainMenu]()
    var ref: DatabaseReference!
    let notification = UINotificationFeedbackGenerator()
    var liveClicked = 0
    var passingSection = ""
    @IBOutlet weak var liveButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var button1: UIView!
    @IBOutlet weak var button2: UIView!
    @IBOutlet weak var button3: UIView!
    @IBOutlet weak var button4: UIView!
    @IBOutlet weak var button5: UIView!
    @IBOutlet weak var button6: UIView!
    @IBOutlet weak var backButtonView: UIView!
    
    var bottom = UILabel()
    var passingIndex = 0
    let spinner = UIActivityIndicatorView(style: .gray)
    var searching = false
    var filteredArray = [Post]()

    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .darkGray
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pagecontrol.transform = pagecontrol.transform.rotated(by: .pi/2)
        pagecontrol.numberOfPages = 4
        
        if view.frame.size.height <= view.frame.size.width * 2{
            print("screen ratio is 16:9 as iphone 8")
            underbar.translatesAutoresizingMaskIntoConstraints = false
            underbar.heightAnchor.constraint(equalToConstant: underbar.frame.size.height).isActive = true
            underbar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            underbar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            underbar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            sectionTable.translatesAutoresizingMaskIntoConstraints = false
            sectionTable.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            sectionTable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            sectionTable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            sectionTable.bottomAnchor.constraint(equalTo: underbar.topAnchor).isActive = true
        }
        // if screen ratio is 21:9
        else if view.frame.size.height >= view.frame.size.width * 2{
            print("screen ratio is 21:9 as iphone x")
            sectionTable.translatesAutoresizingMaskIntoConstraints = false
            sectionTable.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            sectionTable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            sectionTable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            sectionTable.bottomAnchor.constraint(equalTo: underbar.topAnchor).isActive = true
            
            underbar.addSubview(bottom)
            bottom.backgroundColor = .white
            bottom.translatesAutoresizingMaskIntoConstraints = false
            bottom.topAnchor.constraint(equalTo: underbar.bottomAnchor).isActive = true
            bottom.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            bottom.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            bottom.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
        }
        checkLatestVersion()
        loadMainMenu()
        sectionTable.delegate = self
        sectionTable.dataSource = self
        sectionTable.refreshControl = refresher
        spinner.startAnimating()
        sectionTable.backgroundView = spinner
        
//        ConfiguretapGesture()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationController!.navigationBar.tintColor = .black
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        
//        navigation font change
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "GillSans-SemiBold", size: 16)!]

//        // Bluring Navigation Bar
//        navigationController?.navigationBar.installBlurEffect()
        
        
        underbar.layer.shadowOffset = CGSize(width: 0, height: 1)
        underbar.layer.shadowOpacity = 0.2
        underbar.layer.shadowColor = UIColor.black.cgColor
        
        button1.frame.size.width = 70
        button1.frame.size.height = 70
        button2.frame.size.width = 70
        button2.frame.size.height = 70
        button3.frame.size.width = 70
        button3.frame.size.height = 70
        button4.frame.size.width = 70
        button4.frame.size.height = 70
        button5.frame.size.width = 70
        button5.frame.size.height = 70
        button6.frame.size.width = 70
        button6.frame.size.height = 70
        backButtonView.frame.size.width = 70
        backButtonView.frame.size.height = 70
        button1.translatesAutoresizingMaskIntoConstraints = false
        button2.translatesAutoresizingMaskIntoConstraints = false
        button3.translatesAutoresizingMaskIntoConstraints = false
        button4.translatesAutoresizingMaskIntoConstraints = false
        button5.translatesAutoresizingMaskIntoConstraints = false
        button6.translatesAutoresizingMaskIntoConstraints = false
        backButtonView.translatesAutoresizingMaskIntoConstraints = false
        print(button1.frame.size.width)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = button1.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button1.addSubview(blurEffectView)
        button1.sendSubviewToBack(blurEffectView)
        
        let blurEffectView2 = UIVisualEffectView(effect: blurEffect)
        blurEffectView2.frame = button1.bounds
//        blurEffectView2.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button2.addSubview(blurEffectView2)
        button2.sendSubviewToBack(blurEffectView2)
        
        let blurEffectView3 = UIVisualEffectView(effect: blurEffect)
        blurEffectView3.frame = button1.bounds
//        blurEffectView3.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button3.addSubview(blurEffectView3)
        button3.sendSubviewToBack(blurEffectView3)
        
        let blurEffectView4 = UIVisualEffectView(effect: blurEffect)
        blurEffectView4.frame = button1.bounds
//        blurEffectView4.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button4.addSubview(blurEffectView4)
        button4.sendSubviewToBack(blurEffectView4)
        
        let blurEffectView5 = UIVisualEffectView(effect: blurEffect)
        blurEffectView5.frame = button1.bounds
//        blurEffectView5.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button5.addSubview(blurEffectView5)
        button5.sendSubviewToBack(blurEffectView5)
        
        let blurEffectView6 = UIVisualEffectView(effect: blurEffect)
        blurEffectView6.frame = button1.bounds
//        blurEffectView6.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button6.addSubview(blurEffectView6)
        button6.sendSubviewToBack(blurEffectView6)
        
        let blurEffectView7 = UIVisualEffectView(effect: blurEffect)
        blurEffectView7.frame = button1.bounds
//        blurEffectView7.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backButtonView.addSubview(blurEffectView7)
        backButtonView.sendSubviewToBack(blurEffectView7)

        let blurEffect2 = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView8 = UIVisualEffectView(effect: blurEffect2)
        blurEffectView8.frame = view.bounds
        sermonButtonView.addSubview(blurEffectView8)
        sermonButtonView.sendSubviewToBack(blurEffectView8)
        
        sermonButtonView.alpha = 0
        button1.layer.cornerRadius = button1.frame.size.height / 2
        button1.layer.masksToBounds = true
        button2.layer.cornerRadius = button2.frame.size.height / 2
        button2.layer.masksToBounds = true
        button3.layer.cornerRadius = button3.frame.size.height / 2
        button3.layer.masksToBounds = true
        button4.layer.cornerRadius = button4.frame.size.height / 2
        button4.layer.masksToBounds = true
        button5.layer.cornerRadius = button5.frame.size.height / 2
        button5.layer.masksToBounds = true
        button6.layer.cornerRadius = button6.frame.size.height / 2
        button6.layer.masksToBounds = true
        backButtonView.layer.cornerRadius = button1.frame.size.height / 2
        backButtonView.layer.masksToBounds = true

        
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = sectionTable.contentOffset.y / sectionTable.frame.height
        pagecontrol.currentPage = Int(page)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sectionTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomMainSectionTableViewCell
        cell.sectionLabel.text = ""
//            mainMenu[indexPath.row].title
//        let url = "https://drive.google.com/uc?export=view&id=\(mainMenu[indexPath.row].imageUrl)"
//        cell.sectionImage.downloaded(from: url)
        
        let url = URL(string: "https://drive.google.com/uc?export=view&id=\(mainMenu[indexPath.row].imageUrl)")
        cell.sectionImage.loadImage(from: url!)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Int(view.frame.size.height - underbar.frame.size.height - bottom.frame.size.height))
//        return CGFloat(Int(view.frame.size.height / 2.5))
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "SecondTypeMenuViewController") as? SecondTypeMenuViewController else {
                        return
            }
            vc.passedIndex = indexPath.row
            vc.passedMainMenu = mainMenu
            vc.passedSectionTitle = mainMenu[indexPath.row].title
            vc.passedImage2Url = mainMenu[indexPath.row].image2Url
            vc.passedImage3Url = mainMenu[indexPath.row].image3Url
            AudioServicesPlaySystemSound(1519)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 0 {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "SectionTableViewController") as? SectionTableViewController else {
                        return
            }
            vc.passedSection = "liveTranslation"
            AudioServicesPlaySystemSound(1519)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func loadMainMenu() {
            ref = Database.database().reference().child("mainMenu")
            ref.observe(DataEventType.childAdded, with: {(snapshot) in
                print(Thread.isMainThread)
                if let dict = snapshot.value as? [String: Any] {
                    let titleString = dict["title"] as! String
                    let imageUrlString = dict["imageUrl"] as! String
                    let image2UrlString = dict["image2Url"] as! String
                    let image3UrlString = dict["image3Url"] as! String
                    let menu = MainMenu(titleString: titleString, imageUrlString: imageUrlString, image2UrlString: image2UrlString, image3UrlString: image3UrlString)
                    self.mainMenu.append(menu)
    //                self.posts.sort(by: {$0.caption > $1.caption})
                    self.sectionTable.insertRows(at: [IndexPath(row: self.mainMenu.count-1, section: 0)], with: UITableView.RowAnimation.automatic)
                    self.spinner.stopAnimating()
                }
            })
        }
    
    @objc func requestData() {
        self.sectionTable.reloadData()
        let deadline = DispatchTime.now() + .milliseconds(1000)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
    
    private func liveButtonClicked() {
        UIView.animate(withDuration: 0, animations: {
            self.backButtonView.alpha = 1
//            self.navigationItem.leftBarButtonItem?.isEnabled = false
            self.backButtonView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.button1.alpha = 0
            self.button2.alpha = 0
            self.button3.alpha = 0
            self.button4.alpha = 0
            self.button5.alpha = 0
            self.button6.alpha = 0
            self.button1.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.button2.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.button3.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.button4.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.button5.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.button6.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//            AudioServicesPlaySystemSound(1519) // Actuate `Pop` feedback (strong boom)
//            self.notification.notificationOccurred(.success)
//            self.notification.notificationOccurred(.warning)
            self.notification.notificationOccurred(.error)
            
        })
        
        UIView.animate(withDuration: 0.8, animations: {
            self.backButtonView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.sectionTable.transform = CGAffineTransform(scaleX: 0.75, y: 0.8)
            self.sermonButtonView.alpha = 1
            //self.cover.alpha = 1
            self.navigationController?.isNavigationBarHidden = true
            self.backButtonView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            
            //self.view1.layer.cornerRadius = self.view.frame.width/26.0
            //self.view1.clipsToBounds = true
            //self.view2.layer.cornerRadius = self.view.frame.width/26.0
            //self.view2.clipsToBounds = true
            //self.view3.layer.cornerRadius = self.view.frame.width/26.0
            //self.view3.clipsToBounds = true
            
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.4 ,animations: {
            self.button1.alpha = 1
            self.button1.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        UIView.animate(withDuration: 0.5, delay: 0.4 ,animations: {
            self.button2.alpha = 1
            self.button2.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        UIView.animate(withDuration: 0.6, delay: 0.4 ,animations: {
            self.button3.alpha = 1
            self.button3.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        UIView.animate(withDuration: 0.7, delay: 0.4 ,animations: {
            self.button4.alpha = 1
            self.button4.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        UIView.animate(withDuration: 0.8, delay: 0.4 ,animations: {
            self.button5.alpha = 1
            self.button5.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        UIView.animate(withDuration: 0.9, delay: 0.4 ,animations: {
            self.button6.alpha = 1
            self.button6.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    private func backButtonClicked() {
        UIView.animate(withDuration: 0.8,delay: 0 ,animations: {
            
            self.sectionTable.transform = CGAffineTransform(scaleX: 1, y: 1)
            
            
            //self.cover.alpha = 0
            self.navigationController?.isNavigationBarHidden = false
            // self.backButton.alpha = 0
            //AudioServicesPlaySystemSound(1519) // Actuate `Pop` feedback (strong boom)
            self.notification.notificationOccurred(.error)
            
            //self.view1.layer.cornerRadius = self.view.frame.width
            //self.view1.clipsToBounds = true
            //self.view2.layer.cornerRadius = self.view.frame.width
            //self.view2.clipsToBounds = true
            //self.view3.layer.cornerRadius = self.view.frame.width
            //self.view3.clipsToBounds = true
        })
        UIView.animate(withDuration: 0.8,delay: 0.3 ,animations: {
            self.sermonButtonView.alpha = 0
            //self.cover.alpha = 0
            //self.navigationController?.isNavigationBarHidden = false
            // self.backButton.alpha = 0
            //AudioServicesPlaySystemSound(1519) // Actuate `Pop` feedback (strong boom)
            //self.view1.layer.cornerRadius = self.view.frame.width
            //self.view1.clipsToBounds = true
            //self.view2.layer.cornerRadius = self.view.frame.width
            //self.view2.clipsToBounds = true
            //self.view3.layer.cornerRadius = self.view.frame.width
            //self.view3.clipsToBounds = true
        })
        
        
        
        UIView.animate(withDuration: 0.8, animations: {
            self.button1.alpha = 0
            self.button1.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.backButtonView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.backButtonView.alpha = 0
        })
        UIView.animate(withDuration: 0.7, animations: {
            self.button2.alpha = 0
            self.button2.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        })
        UIView.animate(withDuration: 0.6, animations: {
            self.button3.alpha = 0
            self.button3.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        })
        UIView.animate(withDuration: 0.5, animations: {
            self.button4.alpha = 0
            self.button4.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        })
        UIView.animate(withDuration: 0.4, animations: {
            self.button5.alpha = 0
            self.button5.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        })
        UIView.animate(withDuration: 0.3, animations: {
            self.button6.alpha = 0
            self.button6.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        })
        
    }
    
    private func ConfiguretapGesture() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.doneClicked))
//        view.addGestureRecognizer(tapGesture)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(doneClicked(_:)))
        singleTap.cancelsTouchesInView = false
        singleTap.numberOfTapsRequired = 1
        sermonButtonView.addGestureRecognizer(singleTap)
    }
    
    @objc func doneClicked(_ recognizer: UITapGestureRecognizer) {
        if liveClicked != 0 { //prevent extra function calling
            liveClicked = 0
            backButtonClicked()
        }
    }

    @IBAction func liveButtonClicked(_ sender: UIButton) {
        liveButtonClicked()
        liveClicked = 1 // true
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        backButtonClicked()
        liveClicked = 0 // false
    }
    
    
    func segueAction() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SectionTableViewController") as? SectionTableViewController
        vc?.passedSection = passingSection
        AudioServicesPlaySystemSound(1519)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func koreanButtonClicked(_ sender: UIButton) {
        passingSection = "koreanSection"
        segueAction()
    }
    
    @IBAction func englishButtonClicked(_ sender: UIButton) {
        passingSection = "englishSection"
        segueAction()
    }
    
    @IBAction func spanishButtonClicked(_ sender: UIButton) {
        passingSection = "spanishSection"
        segueAction()
    }

    @IBAction func IndonesianButtonClicked(_ sender: UIButton) {
        passingSection = "indonesianSection"
        segueAction()
    }
    
    @IBAction func chineseButtonClicked(_ sender: UIButton) {
        passingSection = "chineseSection"
        segueAction()
    }
    
    @IBAction func missionaryButtonClicked(_ sender: UIButton) {
        passingSection = "seminarSection"
        segueAction()
    }
    
    
}

//// Bluring navigation bar
//extension UINavigationBar {
//    func installBlurEffect() {
//        isTranslucent = true
//        setBackgroundImage(UIImage(), for: .default)
//        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
//        var blurFrame = bounds
//        blurFrame.size.height += statusBarHeight
//        blurFrame.origin.y -= statusBarHeight
//        let blurView  = UIVisualEffectView(effect: UIBlurEffect(style: .light))
//        blurView.isUserInteractionEnabled = false
//        blurView.frame = blurFrame
//        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        addSubview(blurView)
//        blurView.layer.zPosition = -1
//    }
//}
