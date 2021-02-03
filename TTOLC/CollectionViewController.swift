//
//  CollectionViewController.swift
//  TTOLC
//
//  Created by Dowon on 5/26/20.
//  Copyright © 2020 Dowon. All rights reserved.
//

import UIKit
import Firebase
import AudioToolbox

struct Item {
    var imageName: String
}

class CollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var animationView = UIView()
    
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    let cellIdentifier = "CollectionViewCell"
    let notification = UINotificationFeedbackGenerator()
    var passedSection = ""
    var ref: DatabaseReference!
    let spinner = UIActivityIndicatorView(style: .gray)
    
    var currentHorBooks = ""
    var horBooksEnglish = [HorBooks]()
    var horBooksKorean = [HorBooks]()
    var horBooksSpanish = [HorBooks]()
    var horBooksIndonesian = [HorBooks]()
    var horBooksChinese = [HorBooks]()
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .darkGray
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        
        animationView.frame.size.width = view.frame.size.width
        animationView.frame.size.height = view.frame.size.height
        animationView.backgroundColor = .white
        view.addSubview(animationView)
        UIView.animate(withDuration: 1.0) {
            self.animationView.alpha = 0
        }
        AudioServicesPlaySystemSound(1519)
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Books"
        
        collectionView.refreshControl = refresher
        collectionView.backgroundView = spinner
        spinner.startAnimating()
        setupCollectionView()
        
        loadHorBooksEnglish()
        currentHorBooks = "horBooksEnglish"
        loadHorBooksKorean()
        loadHorBooksSpanish()
        loadHorBooksIndonesian()
        loadHorBooksChinese()
    }

   
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupCollectionViewItemSize()
    }
    
    func loadHorBooksEnglish() {
        ref = Database.database().reference().child("horBooks").child("horBooksEnglish")
        ref.observe(DataEventType.childAdded, with: {(snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let imageUrlString = dict["imageUrl"] as! String
                let bookTitleString = dict["bookTitle"] as! String
                let detailTitleString = dict["detailTitle"] as! String
                let image2UrlString = dict["image2Url"] as! String
                let descriptionString = dict["description"] as! String
                let seriesTitleString = dict["seriesTitle"] as! String
                let horBooks = HorBooks(imageUrlString: imageUrlString, bookTitleString: bookTitleString, detailTitleString: detailTitleString, image2UrlString: image2UrlString, descriptionString: descriptionString, seriesTitleString: seriesTitleString)
                self.horBooksEnglish.append(horBooks)
                //                self.posts.sort(by: {$0.caption > $1.caption})
//                self.collectionView.insertItems(at: [IndexPath(row: self.posts.count-1, section: 0)], with: UICollectionView)
//                self.collectionView.insertItems(at: [IndexPath(row: self.horBooksEnglish.count-1, section: 0)], with: UICollectionView)
                self.collectionView.reloadData()
                self.spinner.stopAnimating()
            }
        })
    }
    
    func loadHorBooksKorean() {
        ref = Database.database().reference().child("horBooks").child("horBooksKorean")
            ref.observe(DataEventType.childAdded, with: {(snapshot) in
                if let dict = snapshot.value as? [String: Any] {
                    let imageUrlString = dict["imageUrl"] as! String
                    let bookTitleString = dict["bookTitle"] as! String
                    let detailTitleString = dict["detailTitle"] as! String
                    let image2UrlString = dict["image2Url"] as! String
                    let descriptionString = dict["description"] as! String
                    let seriesTitleString = dict["seriesTitle"] as! String
                    let horBooks = HorBooks(imageUrlString: imageUrlString, bookTitleString: bookTitleString, detailTitleString: detailTitleString, image2UrlString: image2UrlString, descriptionString: descriptionString, seriesTitleString: seriesTitleString)
                    self.horBooksKorean.append(horBooks)
                    //                self.posts.sort(by: {$0.caption > $1.caption})
    //                self.collectionView.insertItems(at: [IndexPath(row: self.posts.count-1, section: 0)], with: UICollectionView)
    //                self.collectionView.insertItems(at: [IndexPath(row: self.horBooksEnglish.count-1, section: 0)], with: UICollectionView)
                }
            })
        }
    
    func loadHorBooksSpanish() {
        ref = Database.database().reference().child("horBooks").child("horBooksSpanish")
            ref.observe(DataEventType.childAdded, with: {(snapshot) in
                if let dict = snapshot.value as? [String: Any] {
                    let imageUrlString = dict["imageUrl"] as! String
                    let bookTitleString = dict["bookTitle"] as! String
                    let detailTitleString = dict["detailTitle"] as! String
                    let image2UrlString = dict["image2Url"] as! String
                    let descriptionString = dict["description"] as! String
                    let seriesTitleString = dict["seriesTitle"] as! String
                    let horBooks = HorBooks(imageUrlString: imageUrlString, bookTitleString: bookTitleString, detailTitleString: detailTitleString, image2UrlString: image2UrlString, descriptionString: descriptionString, seriesTitleString: seriesTitleString)
                    self.horBooksSpanish.append(horBooks)
                    //                self.posts.sort(by: {$0.caption > $1.caption})
    //                self.collectionView.insertItems(at: [IndexPath(row: self.posts.count-1, section: 0)], with: UICollectionView)
    //                self.collectionView.insertItems(at: [IndexPath(row: self.horBooksEnglish.count-1, section: 0)], with: UICollectionView)
                }
            })
        }
    
    func loadHorBooksIndonesian() {
        ref = Database.database().reference().child("horBooks").child("horBooksIndonesian")
            ref.observe(DataEventType.childAdded, with: {(snapshot) in
                if let dict = snapshot.value as? [String: Any] {
                    let imageUrlString = dict["imageUrl"] as! String
                    let bookTitleString = dict["bookTitle"] as! String
                    let detailTitleString = dict["detailTitle"] as! String
                    let image2UrlString = dict["image2Url"] as! String
                    let descriptionString = dict["description"] as! String
                    let seriesTitleString = dict["seriesTitle"] as! String
                    let horBooks = HorBooks(imageUrlString: imageUrlString, bookTitleString: bookTitleString, detailTitleString: detailTitleString, image2UrlString: image2UrlString, descriptionString: descriptionString, seriesTitleString: seriesTitleString)
                    self.horBooksIndonesian.append(horBooks)
                    //                self.posts.sort(by: {$0.caption > $1.caption})
    //                self.collectionView.insertItems(at: [IndexPath(row: self.posts.count-1, section: 0)], with: UICollectionView)
    //                self.collectionView.insertItems(at: [IndexPath(row: self.horBooksEnglish.count-1, section: 0)], with: UICollectionView)
                }
            })
        }
    
    func loadHorBooksChinese() {
        ref = Database.database().reference().child("horBooks").child("horBooksChinese")
            ref.observe(DataEventType.childAdded, with: {(snapshot) in
                if let dict = snapshot.value as? [String: Any] {
                    let imageUrlString = dict["imageUrl"] as! String
                    let bookTitleString = dict["bookTitle"] as! String
                    let detailTitleString = dict["detailTitle"] as! String
                    let image2UrlString = dict["image2Url"] as! String
                    let descriptionString = dict["description"] as! String
                    let seriesTitleString = dict["seriesTitle"] as! String
                    let horBooks = HorBooks(imageUrlString: imageUrlString, bookTitleString: bookTitleString, detailTitleString: detailTitleString, image2UrlString: image2UrlString, descriptionString: descriptionString, seriesTitleString: seriesTitleString)
                    self.horBooksChinese.append(horBooks)
                    //                self.posts.sort(by: {$0.caption > $1.caption})
    //                self.collectionView.insertItems(at: [IndexPath(row: self.posts.count-1, section: 0)], with: UICollectionView)
    //                self.collectionView.insertItems(at: [IndexPath(row: self.horBooksEnglish.count-1, section: 0)], with: UICollectionView)
                }
            })
        }
    
    
    @objc func requestData() {
        UIView.animate(withDuration: 0.2) {
                self.collectionView.alpha = 0
        }
        self.collectionView.reloadData()
        let deadline = DispatchTime.now() + .milliseconds(1000)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
            UIView.animate(withDuration: 1.0, animations: {
                self.collectionView.alpha = 1
            })
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    private func setupCollectionViewItemSize() {
        if collectionViewFlowLayout == nil {
            let numberOfItemPerRow: CGFloat = 2
            let lineSpacing: CGFloat = 40
            let interItemSpacing: CGFloat = 10
            
            let width = (collectionView.frame.width - (numberOfItemPerRow - 1) * interItemSpacing) / numberOfItemPerRow
            let height = width * 1.615
            
            collectionViewFlowLayout = UICollectionViewFlowLayout()
            collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
            collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
            collectionViewFlowLayout.scrollDirection = .vertical
            collectionViewFlowLayout.minimumLineSpacing = lineSpacing
            collectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
            
            collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        }
    }
    
    
    @IBAction func segementButtonClicked(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            currentHorBooks = "horBooksEnglish"
            collectionView.alpha = 0
            collectionView.reloadData()
            AudioServicesPlaySystemSound(1519)
            UIView.animate(withDuration: 1.0) {
                self.collectionView.alpha = 1
            }
        }
        else if sender.selectedSegmentIndex == 1 {
            currentHorBooks = "horBooksKorean"
            collectionView.alpha = 0
            collectionView.reloadData()
            AudioServicesPlaySystemSound(1519)
            UIView.animate(withDuration: 1.0) {
                self.collectionView.alpha = 1
            }
        }
        else if sender.selectedSegmentIndex == 2 {
            currentHorBooks = "horBooksSpanish"
            collectionView.alpha = 0
            collectionView.reloadData()
            AudioServicesPlaySystemSound(1519)
            UIView.animate(withDuration: 1.0) {
                self.collectionView.alpha = 1
            }
        }
        else if sender.selectedSegmentIndex == 3 {
            currentHorBooks = "horBooksIndonesian"
            collectionView.alpha = 0
            collectionView.reloadData()
            AudioServicesPlaySystemSound(1519)
            UIView.animate(withDuration: 1.0) {
                self.collectionView.alpha = 1
            }
        }
        else if sender.selectedSegmentIndex == 4 {
            currentHorBooks = "horBooksChinese"
            collectionView.alpha = 0
            collectionView.reloadData()
            AudioServicesPlaySystemSound(1519)
            UIView.animate(withDuration: 1.0) {
                self.collectionView.alpha = 1
            }
        }
        
    }
    
}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentHorBooks == "horBooksEnglish" {
            return horBooksEnglish.count
        }
        else if currentHorBooks == "horBooksKorean" {
            return horBooksKorean.count
        }
        else if currentHorBooks == "horBooksSpanish" {
            return horBooksSpanish.count
        }
        else if currentHorBooks == "horBooksIndonesian" {
            return horBooksIndonesian.count
        }
        else if currentHorBooks == "horBooksChinese" {
            return horBooksChinese.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CollectionViewCell
        let url = URL(string: "https://drive.google.com/uc?export=view&id=\(horBooksEnglish[indexPath.item].imageUrl)")
        
        cell.imageView.translatesAutoresizingMaskIntoConstraints = false
        cell.imageView.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
        cell.imageView.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
        cell.imageView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        cell.imageView.bottomAnchor.constraint(equalTo: cell.titleLabel.topAnchor, constant: -10).isActive = true
        cell.clipsToBounds = true
        
        
        cell.imageView.loadImage(from: url!)
        print("Here is Image Width: \(cell.imageView.frame.size.width)")
        print("Here is Image height: \(cell.imageView.frame.size.height)")
        print("Here is cell Width: \(cell.frame.size.width)")
        print("Here is cell height: \(cell.frame.size.height)")
        
        if currentHorBooks == "horBooksEnglish" {
            cell.titleLabel.text = horBooksEnglish[indexPath.item].bookTitle
            cell.detailLabel.text = horBooksEnglish[indexPath.item].detailTitle
            cell.seriesLabel.text = horBooksEnglish[indexPath.item].seriesTitle
        }
        else if currentHorBooks == "horBooksKorean" {
            cell.titleLabel.text = horBooksKorean[indexPath.item].bookTitle
            cell.detailLabel.text = horBooksKorean[indexPath.item].detailTitle
            cell.seriesLabel.text = horBooksKorean[indexPath.item].seriesTitle
        }
        else if currentHorBooks == "horBooksSpanish" {
            cell.titleLabel.text = horBooksSpanish[indexPath.item].bookTitle
            cell.detailLabel.text = horBooksSpanish[indexPath.item].detailTitle
            cell.seriesLabel.text = horBooksSpanish[indexPath.item].seriesTitle
        }
        else if currentHorBooks == "horBooksIndonesian" {
            cell.titleLabel.text = horBooksIndonesian[indexPath.item].bookTitle
            cell.detailLabel.text = horBooksIndonesian[indexPath.item].detailTitle
            cell.seriesLabel.text = horBooksIndonesian[indexPath.item].seriesTitle
        }
        else if currentHorBooks == "horBooksChinese" {
            cell.titleLabel.text = horBooksChinese[indexPath.item].bookTitle
            cell.detailLabel.text = horBooksChinese[indexPath.item].detailTitle
            cell.seriesLabel.text = horBooksChinese[indexPath.item].seriesTitle
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "DetailBookViewController") as? DetailBookViewController else {
                    return
        }
        //        let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController
        vc.passedIndex = indexPath.row
        
        if currentHorBooks == "horBooksEnglish" {
            vc.passedHorBooks = horBooksEnglish
        }
        else if currentHorBooks == "horBooksKorean" {
            vc.passedHorBooks = horBooksKorean
        }
        else if currentHorBooks == "horBooksSpanish" {
            vc.passedHorBooks = horBooksSpanish
        }
        else if currentHorBooks == "horBooksIndonesian" {
            vc.passedHorBooks = horBooksIndonesian
        }
        else if currentHorBooks == "horBooksChinese" {
            vc.passedHorBooks = horBooksChinese
        }
        
        AudioServicesPlaySystemSound(1519)
        present(vc, animated: true)
    }
    
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard let collectionView = collectionView else {
//            return
//        }
//
//        let offset = collectionView.contentOffset.y
//        let height = collectionView.frame.size.height
//        let width = collectionView.frame.size.width
//        for cell in collectionView.visibleCells {
//            let left = cell.frame.origin.x
//            if left >= width / 2 {
//                let top = cell.frame.origin.y
//                let alpha = (top - offset) / height
//                cell.alpha = alpha
//            } else {
//                cell.alpha = 1
//            }
//        }
//    }
}

//extension CollectionViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        //        search = posts.filter({$0.prefix(searchText.count) == searchText})
//        //        search = test.filter({$0.prefix(searchText.count) == searchText})
//        filteredArray = posts.filter { $0.caption.prefix(searchText.count) == searchText }
//        searching = true
//        tableView.reloadData()
//    }
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searching = false
//        searchBar.text = ""
//        tableView.reloadData()
//    }
//}

