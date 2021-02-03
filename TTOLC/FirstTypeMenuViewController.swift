//
//  FirstTypeMenuViewController.swift
//  TTOLC
//
//  Created by Dowon on 9/5/20.
//  Copyright © 2020 Dowon. All rights reserved.
//

import UIKit
import Firebase
import AudioToolbox

class FirstTypeMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var ref: DatabaseReference!
    let spinner = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        spinner.startAnimating()
        tableView.backgroundView = spinner

//        check_permission(start_date: Date(), event_name: "Meeting")
    }
    

    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomFirstTypeMenuTableViewCell
            return cell
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            (view.frame.size.height / 3) * 2
        }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let safeArea = UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
        let safeAreaTop: CGFloat = safeArea + (navigationController?.navigationBar.frame.height ?? 0)
        
        let offset = scrollView.contentOffset.y + safeAreaTop
        
        let alpha: CGFloat = 1 - ((scrollView.contentOffset.y + safeAreaTop) / safeAreaTop)
        navigationController?.navigationBar.alpha = alpha
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
        
}


