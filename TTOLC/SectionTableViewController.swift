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
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.isNavigationBarHidden = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refresher
        spinner.startAnimating()
        tableView.backgroundView = spinner
        loadPosts()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "SECTION"
    }
    
    @objc func requestData() {
        self.tableView.reloadData()
        let deadline = DispatchTime.now() + .milliseconds(1000)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
        self.refresher.endRefreshing()
        }
    }
    
    func loadPosts() {
        ref = Database.database().reference().child("sermonSection").child(passedSection)
        ref.observe(DataEventType.childAdded, with: {(snapshot) in
            print(Thread.isMainThread)
            if let dict = snapshot.value as? [String: Any] {
                let sectionTitle = dict["sectionTitle"] as! String
                let imageUrl = dict["imageUrl"] as! String
                let section = Section(sectionTitle: sectionTitle, imageUrl: imageUrl)
                self.sections.append(section)
                self.mainView.insertRows(at: [IndexPath(row: self.sections.count-1, section: 0)], with: UITableView.RowAnimation.automatic)
                //                self.tableView.reloadData()
                self.spinner.stopAnimating()
            }
        })
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.width / 2.3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell") as! CustomSectionTableViewCell
        //let cell = UITableViewCell()
        cell.sectionLable.text = sections[indexPath.row].section
//        let image = UIImage(named: sections[indexPath.row].image)
//        cell.sectionTitleWithImage.setImage(image, for: .normal)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        let vc = storyboard?.instantiateViewController(withIdentifier: "TableViewController") as? TableViewController
        vc?.passedParentSection = passedSection
        vc?.passedSection = sections[indexPath.row].section
        AudioServicesPlaySystemSound(1519)
        self.navigationController?.pushViewController(vc!, animated: true)
        //performSegue(withIdentifier: "show", sender: self)
    }
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //if segue.identifier == "show" {
    //let webViewVC = segue.destination as! WebViewController
    //webViewVC.label.text = "Hello"
    
    //}
    //}
}
