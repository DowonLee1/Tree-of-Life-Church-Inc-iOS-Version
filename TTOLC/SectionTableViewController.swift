//
//  SectionTableViewController.swift
//  TTOLC
//
//  Created by Dowon on 5/21/20.
//  Copyright © 2020 Dowon. All rights reserved.
//

import UIKit
import Firebase
import AudioToolbox

class SectionTableViewController: UITableViewController {
    @IBOutlet var mainView: UITableView!
    var passedSection = ""
    var sections = [Section]()
    var liveTranslations = [LiveTranslation]()
    var ref: DatabaseReference!
    let notification = UINotificationFeedbackGenerator()
    let spinner = UIActivityIndicatorView(style: .gray)
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .darkGray
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSetUp()
        loadPosts()
        print(liveTranslations)
    }

    private func layoutSetUp() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.isNavigationBarHidden = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refresher
        spinner.startAnimating()
        tableView.backgroundView = spinner
        self.navigationController?.isNavigationBarHidden = false
        if passedSection == "liveTranslation" {
            self.navigationItem.title = "CHANNEL"
        }
        else {
            self.navigationItem.title = "SERVICE"
        }
    }
    
    @objc func requestData() {
        self.tableView.reloadData()
        let deadline = DispatchTime.now() + .milliseconds(1000)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
        self.refresher.endRefreshing()
        }
    }
    
    func loadPosts() {
        if passedSection == "liveTranslation" {
            ref = Database.database().reference().child(passedSection)
            ref.observe(DataEventType.childAdded, with: {(snapshot) in
                print(Thread.isMainThread)
                if let dict = snapshot.value as? [String: Any] {
                    let sectionTitle = dict["sectionTitle"] as! String
                    let liveUrl = dict["liveUrl"] as! String
                    let translatorName = dict["translatorName"] as! String
                    
                    let liveTranslation = LiveTranslation(liveUrlString: liveUrl, sectionTitleString: sectionTitle, translatorNameString: translatorName)
                    self.liveTranslations.append(liveTranslation)
                    self.mainView.insertRows(at: [IndexPath(row: self.liveTranslations.count-1, section: 0)], with: UITableView.RowAnimation.automatic)
                    self.spinner.stopAnimating()
                }
            })
            
        }
        else {
            ref = Database.database().reference().child("sermonSection").child(passedSection)
            ref.observe(DataEventType.childAdded, with: {(snapshot) in
                print(Thread.isMainThread)
                if let dict = snapshot.value as? [String: Any] {
                    let sectionTitle = dict["sectionTitle"] as! String
                    let detailSection = dict["detailSection"] as! Int
                    let section = Section(sectionTitle: sectionTitle, detailSectionTitle: detailSection)
                    self.sections.append(section)
                    self.mainView.insertRows(at: [IndexPath(row: self.sections.count-1, section: 0)], with: UITableView.RowAnimation.automatic)
                    //                self.tableView.reloadData()
                    self.spinner.stopAnimating()
                }
            })
        }
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.width / 2.3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell") as! CustomSectionTableViewCell
        if passedSection == "liveTranslation" {
            cell.sectionLable.text = liveTranslations[indexPath.row].sectionTitle
        }
        else {
            cell.sectionLable.text = sections[indexPath.row].section
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if passedSection == "liveTranslation" {
            return liveTranslations.count
        }
        else {
            return sections.count
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if passedSection == "liveTranslation" {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "LiveTranslationViewController") as? LiveTranslationViewController else {
                return
            }
            vc.passedSection = liveTranslations[indexPath.row].sectionTitle
            AudioServicesPlaySystemSound(1519)
            present(vc, animated: true)
            
        }
        else if sections[indexPath.row].detailSection == 0 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "TableViewController") as? TableViewController
            vc?.passedParentSection = passedSection
            vc?.passedSection = sections[indexPath.row].section
            AudioServicesPlaySystemSound(1519)
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "DetailSectionTableViewController") as? DetailSectionTableViewController
            vc?.passedParentSection = passedSection
            vc?.passedSection = sections[indexPath.row].section
            AudioServicesPlaySystemSound(1519)
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
