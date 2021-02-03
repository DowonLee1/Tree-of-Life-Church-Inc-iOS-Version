//
//  TableViewController.swift
//  TTOLC
//
//  Created by Dowon on 5/14/20.
//  Copyright © 2020 Dowon. All rights reserved.
//

import UIKit
import Firebase
import AudioToolbox

class TableViewController: UITableViewController {
    @IBOutlet var mainView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var passedParentSection = ""
    var passedSection = ""
    var posts = [Post]()
    var ref: DatabaseReference!
    let notification = UINotificationFeedbackGenerator()
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
        layoutSetUp()
        toolBarSetUp()
        loadPosts()
        tableView.reloadData()
        
    }
    
    private func toolBarSetUp() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        doneButton.tintColor = UIColor.black
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        searchBar.inputAccessoryView = toolbar
    }
    
    private func layoutSetUp() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "SERMONS"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refresher
        spinner.startAnimating()
        tableView.backgroundView = spinner
    }
    
    @objc func doneClicked() {
        tableView.endEditing(true)
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
    
    @objc func requestData() {
        self.tableView.reloadData()
        let deadline = DispatchTime.now() + .milliseconds(1000)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
    
    func loadPosts() {
        ref = Database.database().reference().child("sermon").child(passedParentSection).child(passedSection)
        ref.observe(DataEventType.childAdded, with: {(snapshot) in
            print(Thread.isMainThread)
            if let dict = snapshot.value as? [String: Any] {
                let titleString = dict["title"] as! String
                let bibleVerseString = dict["bibleVerse"] as! String
                let pastorNameString = dict["pastorName"] as! String
                let dateString = dict["date"] as! String
                let urlString = dict["url"] as! String
                let imageUrlString = dict["imageUrl"] as! String
                let post = Post(titleString: titleString, bibleVerseString: bibleVerseString, pastorNameString: pastorNameString, dateString: dateString, urlString: urlString, imageUrlString: imageUrlString)
                self.posts.append(post)
//                self.posts.sort(by: {$0.caption > $1.caption})
                self.mainView.insertRows(at: [IndexPath(row: self.posts.count-1, section: 0)], with: UITableView.RowAnimation.automatic)
                self.spinner.stopAnimating()
            }
        })
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let safeArea = UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
        let safeAreaTop: CGFloat = safeArea + (navigationController?.navigationBar.frame.height ?? 0)
        
        let offset = scrollView.contentOffset.y + safeAreaTop
        
        let alpha: CGFloat = 1 - ((scrollView.contentOffset.y + safeAreaTop) / safeAreaTop)
        navigationController?.navigationBar.alpha = alpha
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    // TableView
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
        if searching {
            let url = URL(string: "https://drive.google.com/uc?export=view&id=\(filteredArray[indexPath.row].imageUrl)")
            cell.thumbnailImage.loadImage(from: url!)
            cell.titleLabel.text = filteredArray[indexPath.row].title
            cell.bibleVerseLabel.text = filteredArray[indexPath.row].bibleVerse
            cell.pastorNameLabel.text = filteredArray[indexPath.row].pastorName
            cell.dateLabel.text = filteredArray[indexPath.row].date
        }
        else {
            let url = URL(string: "https://drive.google.com/uc?export=view&id=\(posts[indexPath.row].imageUrl)")
            cell.thumbnailImage.loadImage(from: url!)
            
            cell.titleLabel.text = posts[indexPath.row].title
            cell.bibleVerseLabel.text = posts[indexPath.row].bibleVerse
            cell.pastorNameLabel.text = posts[indexPath.row].pastorName
            cell.dateLabel.text = posts[indexPath.row].date
        }
//        let url = "https://img.youtube.com/vi/\(posts[indexPath.row].url)/0.jpg"
//        let url = "https://drive.google.com/uc?export=view&id=\("1-hgQrXxb8E_iw0BZDX7BgvamJcfXBxSv")"
//        cell.thumbnailImage.downloaded(from: url)
//        cell.dateImage.frame.size.width = 72
//        cell.dateImage.frame.size.height = 70
//        cell.dateImage.image = UIImage(named: "date")
//        cell.dateImage.downloaded
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filteredArray.count
        }
        else {
            return posts.count
        }
    }
//    func showVideo() {
//        if let keyWindow = UIApplication.shared.keyWindow {
//            videoView.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
//            keyWindow.addSubview(videoView)
//            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut ,animations: {
//                self.videoView.frame = keyWindow.frame
//            }, completion: { (completedAnimation) in
//
//            })
//        }
//    }

//    @IBAction func buttonClicked(_ sender: Any) {
//        if let keyWindow = UIApplication.shared.keyWindow {
//            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut ,animations: {
//            self.videoView.frame = CGRect(x: keyWindow.frame.width - 160, y: keyWindow.frame.height - 120, width: 156, height: 90)
//            }, completion: { (completedAnimation) in
//            })
//        }
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "VideoViewController") as? VideoViewController else {
            return
        }
//        let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController
        if searching {
            let searchCaption = filteredArray[indexPath.row].title
            var index = 0
            while index < posts.count {
                if searchCaption == posts[index].title {
                    print(index)
                    break
                }
                index += 1
            }
            vc.passedUrl = filteredArray[indexPath.row].url
            vc.passedCaption = filteredArray[indexPath.row].title
            vc.passedBibleVerse = filteredArray[indexPath.row].bibleVerse
            vc.passedPastorName = filteredArray[indexPath.row].pastorName
            vc.passedDate = filteredArray[indexPath.row].date
            vc.passedIndex = index
            vc.passedPost = posts
        }
        else {
            vc.passedUrl = posts[indexPath.row].url
            vc.passedCaption = posts[indexPath.row].title
            vc.passedBibleVerse = posts[indexPath.row].bibleVerse
            vc.passedPastorName = posts[indexPath.row].pastorName
            vc.passedDate = posts[indexPath.row].date
            vc.passedIndex = indexPath.row
            vc.passedPost = posts
        }
        AudioServicesPlaySystemSound(1519)
//        self.navigationController?.pushViewController(vc, animated: true)
        present(vc, animated: true)
    }
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if segue.identifier == "show" {
            //let webViewVC = segue.destination as! WebViewController
            //webViewVC.label.text = "Hello"
            
        //}
    //}
}

extension TableViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        search = posts.filter({$0.prefix(searchText.count) == searchText})
//        search = test.filter({$0.prefix(searchText.count) == searchText})
//        filteredArray = posts.filter { $0.caption.prefix(searchText.count) == searchText }
        filteredArray = posts.filter { ($0.title.lowercased().contains(searchText.lowercased())) || ($0.bibleVerse.lowercased().contains(searchText.lowercased())) || ($0.pastorName.lowercased().contains(searchText.lowercased())) || ($0.date.lowercased().contains(searchText.lowercased()))}
        searching = true
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.showsCancelButton = false
        searchBar.text = ""
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

//extension UIImageView {
//    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
//        contentMode = mode
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            DispatchQueue.main.async() {
//                self.image = image
//            }
//            }.resume()
//    }
//
//    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
//        guard let url = URL(string: link) else { return }
//        downloaded(from: url, contentMode: mode)
//    }
//}



let imageCache = NSCache<AnyObject, AnyObject>()
var task: URLSessionTask!
var spinner = UIActivityIndicatorView(style: .gray)

extension UIImageView {
    func loadImage(from url: URL) {
        
        
        image = nil
        
        addSpinner()
        
//        if let task = task {
//            task.cancel()
//        }
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            image = imageFromCache
            removeSpinner()
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                let newImage = UIImage(data: data)
                else { return }
            imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
            
            DispatchQueue.main.async() {
                self.image = newImage
                self.removeSpinner()
                self.alpha = 0
                UIView.animate(withDuration: 0.7) {
                    self.alpha = 1
                }
                
            }
            }
        task.resume()
    }
    func addSpinner() {
        addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinner.startAnimating()
    }
    
    func removeSpinner() {
        spinner.removeFromSuperview()
    }
}


// Bluring navigation bar
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
