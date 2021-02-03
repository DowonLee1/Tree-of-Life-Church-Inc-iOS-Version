//
//  TableViewController.swift
//  TTOLC
//
//  Created by Dowon on 5/14/20.
//  Copyright © 2020 Dowon. All rights reserved.
//

import UIKit
import Firebase

class TableViewController: UITableViewController {
    
    var posts = [Post]()
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        tableView.dataSource = self
        loadPosts()
        
    }
    
    func loadPosts() {
        ref = Database.database().reference().child("posts")
        ref.observe(DataEventType.value, with: {(snapshot) in
            print(Thread.isMainThread)
            if let dict = snapshot.value as? [String: Any] {
                let captionText = dict["caption"] as! String
                let urlString = dict["url"] as! String
                let post = Post(captionText: captionText, urlString: urlString)
                self.posts.append(post)
                //print(self.posts)
                self.tableView.reloadData()
                //print(snapshot.value)
                
            }
        })
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = posts[indexPath.row].caption
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.textLabel?.text = "Hello"
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "show", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
}
