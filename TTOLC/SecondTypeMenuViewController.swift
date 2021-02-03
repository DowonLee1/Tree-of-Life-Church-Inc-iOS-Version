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

class SecondTypeMenuViewController: UIViewController, UIScrollViewDelegate, MFMailComposeViewControllerDelegate{

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var paddingView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var textViewLabel: UITextView!
    @IBOutlet weak var sinceLabel: UILabel!
    
    var passedSectionTitle = ""
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
            sinceLabel.text = "SINCE 2016 04 17"
            textViewLabel.text = "The Tree of Life Church was founded upon on the faith ideology of Reverend Abraham Park with the mission of spreading the gospel of the cross, the Word of redemptive history, to all nations. The Tree of Life Church embraces all races, languages, and cultures, as one body of Christ. Our mission statement focuses on world missions by obeying the Word of Jesus Christ to make disciples of all nations so that they may return dancing to the Lord. The Tree of Life Church breaks away from the fixed formalities and habits of the standard church and works with all congregation members to serve the church with their individual talents and passion. We aim to fulfill the vision of the current times and the ultimate vision of the Bible, which is the history of redemption."
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
            sinceLabel.text = "SINCE 2007 10 27"
            textViewLabel.text = "In 2007, Reverend Abraham Park, the founder of Pyungkang Cheil Presbyterian Church published the first volume of the The History of Redemption series. The series sold more than 450,000, making an unprecedented record for biblical research books. What also surprised many was that the English version of the series (from volume 1 to 5 currently) also sold 30,0000 copies on Amazon.com, the largest online bookstore, and in Barnes& Noble which holds the largest bookstore network in the United States. The series has been translated not only in English but also in Chinese, Japanese, Hebrew, Spanish and Indonesian. The seminars on The History of Redemption Series took place in over 20 countries around the world."
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
//        image.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        let navBarHeight = statusBarHeight +
           (navigationController?.navigationBar.frame.height ?? 0.0)
        actionButton.layer.borderWidth = 1
        actionButton.layer.borderColor = UIColor.black.cgColor
        
        
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
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowColor = UIColor.black.cgColor
        
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        paddingView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        paddingView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        paddingView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        paddingView.heightAnchor.constraint(equalToConstant: CGFloat(view.frame.size.height / 1.628)).isActive = true
        
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
            if passedIndex == 1 {
                textViewLabel.text = "The Tree of Life Church was founded upon on the faith ideology of Reverend Abraham Park with the mission of spreading the gospel of the cross, the Word of redemptive history, to all nations. The Tree of Life Church embraces all races, languages, and cultures, as one body of Christ. Our mission statement focuses on world missions by obeying the Word of Jesus Christ to make disciples of all nations so that they may return dancing to the Lord. The Tree of Life Church breaks away from the fixed formalities and habits of the standard church and works with all congregation members to serve the church with their individual talents and passion. We aim to fulfill the vision of the current times and the ultimate vision of the Bible, which is the history of redemption."
            }
            if passedIndex == 3 {
                textViewLabel.text = "In 2007, Reverend Abraham Park, the founder of Pyungkang Cheil Presbyterian Church published the first volume of the The History of Redemption series. The series sold more than 450,000, making an unprecedented record for biblical research books. What also surprised many was that the English version of the series (from volume 1 to 5 currently) also sold 30,0000 copies on Amazon.com, the largest online bookstore, and in Barnes& Noble which holds the largest bookstore network in the United States. The series has been translated not only in English but also in Chinese, Japanese, Hebrew, Spanish and Indonesian. The seminars on The History of Redemption Series took place in over 20 countries around the world."
            }
            
            textViewLabel.alpha = 0
            AudioServicesPlaySystemSound(1519)
            UIView.animate(withDuration: 1.0) {
                self.textViewLabel.alpha = 1
            }
            
        }
        else if sender.selectedSegmentIndex == 1 {
            if passedIndex == 1 {
                textViewLabel.text = "생명 나무 교회는 십자가의 복음, 구속사 말씀을 모든 민족에 전파한다는 사명으로 박 아브라함 목사의 신앙 이념을 바탕으로 설립되었습니다. 생명 나무 교회는 모든 인종, 언어, 문화를 그리스도의 한 몸으로 받아들입니다. 우리의 사명 선언문은 예수 그리스도의 말씀에 순종하여 모든 민족의 제자를 삼아 주님 께 춤을 추도록함으로써 세계 선교에 초점을 맞추고 있습니다. 생명 나무 교회는 표준 교회의 고정 된 형식과 습관에서 벗어나 모든 성도들과 협력하여 각자의 재능과 열정으로 교회를 섬기고 있습니다. 구속의 역사 인 성경의 현재 비전과 궁극적 인 비전을 성취하고자합니다."
            }
            if passedIndex == 3 {
                textViewLabel.text = "2007년 평강 제일 장로 교회 창립자인 박 아브라함 목사는 구속사 시리즈 1권을 발간했다. 이 시리즈는 45만개가 넘는 판매량으로 성경 연구 서적에 전례없는 기록을 세웠습니다. 또한 많은 사람들이 놀란것은 이 시리즈의 영어 버전 (현재 1 권에서 5 권까지)이 ​​최대 온라인 서점 인 Amazon.com과 미국 최대 서점 네트워크를 보유한 Barnes & Noble에서 30,0000 부를 판매했다는 것입니다. 이 시리즈는 영어뿐만 아니라 중국어, 일본어, 히브리어, 스페인어 및 인도네시아어로도 번역되었습니다. The History of Redemption Series에 대한 세미나는 전 세계 20여 개국에서 열렸습니다."
            }
            
            textViewLabel.alpha = 0
            AudioServicesPlaySystemSound(1519)
            UIView.animate(withDuration: 1.0) {
                self.textViewLabel.alpha = 1
            }
        }
        else if sender.selectedSegmentIndex == 2 {
            if passedIndex == 1 {
                textViewLabel.text = "La Iglesia Tree of Life se fundó sobre la ideología de fe del Reverendo Abraham Park con la misión de difundir el evangelio de la cruz, la Palabra de la historia redentora, a todas las naciones. La Iglesia Árbol de la Vida abarca todas las razas, idiomas y culturas como un solo cuerpo de Cristo. Nuestra declaración de misión se enfoca en misiones mundiales al obedecer la Palabra de Jesucristo para hacer discípulos de todas las naciones para que puedan regresar bailando al Señor. La Iglesia Árbol de la Vida rompe con las formalidades y hábitos fijos de la iglesia estándar y trabaja con todos los miembros de la congregación para servir a la iglesia con sus talentos y pasión individuales. Nuestro objetivo es cumplir la visión de los tiempos actuales y la visión última de la Biblia, que es la historia de la redención."
            }
            if passedIndex == 3 {
                textViewLabel.text = "En 2007, el Reverendo Abraham Park, fundador de la Iglesia Presbiteriana Pyungkang Cheil, publicó el primer volumen de la serie La Historia de la Redención. La serie vendió más de 450,000, haciendo un récord sin precedentes para los libros de investigación bíblica. Lo que también sorprendió a muchos fue que la versión en inglés de la serie (del volumen 1 al 5 actualmente) también vendió 30,0000 copias en Amazon.com, la librería en línea más grande, y en Barnes & Noble, que posee la red de librerías más grande de los Estados Unidos. . La serie ha sido traducida no solo al inglés, sino también al chino, japonés, hebreo, español e indonesio. Los seminarios sobre la serie La historia de la redención se llevaron a cabo en más de 20 países de todo el mundo."
            }
            
            textViewLabel.alpha = 0
            AudioServicesPlaySystemSound(1519)
            UIView.animate(withDuration: 1.0) {
                self.textViewLabel.alpha = 1
            }
        }
        else if sender.selectedSegmentIndex == 3 {
            if passedIndex == 1 {
                textViewLabel.text = "Gereja Pohon Kehidupan didirikan di atas ideologi iman Pendeta Abraham Park dengan misi menyebarkan Injil salib, Firman sejarah penebusan, ke semua bangsa. Gereja Pohon Kehidupan merangkul semua ras, bahasa, dan budaya, sebagai satu tubuh Kristus. Pernyataan misi kami berfokus pada misi dunia dengan mematuhi Firman Yesus Kristus untuk menjadikan semua bangsa murid sehingga mereka dapat kembali menari kepada Tuhan. The Tree of Life Church memisahkan diri dari formalitas dan kebiasaan tetap gereja standar dan bekerja dengan semua anggota jemaat untuk melayani gereja dengan bakat dan semangat individu mereka. Kami bertujuan untuk memenuhi visi zaman sekarang dan visi akhir dari Alkitab, yaitu sejarah penebusan."
            }
            if passedIndex == 3 {
                textViewLabel.text = "Pada tahun 2007, Pendeta Abraham Park, pendiri Gereja Presbyterian Pyungkang Cheil menerbitkan volume pertama seri The History of Redemption. Seri tersebut terjual lebih dari 450.000, membuat rekor yang belum pernah terjadi sebelumnya untuk buku-buku penelitian alkitabiah. Yang juga mengejutkan banyak orang adalah bahwa versi bahasa Inggris dari serial tersebut (dari volume 1 hingga 5 saat ini) juga terjual 30.0000 eksemplar di Amazon.com, toko buku online terbesar, dan di Barnes & Noble yang memegang jaringan toko buku terbesar di Amerika Serikat. . Serial ini telah diterjemahkan tidak hanya dalam bahasa Inggris tetapi juga dalam bahasa Cina, Jepang, Ibrani, Spanyol dan Indonesia. Seminar tentang The History of Redemption Series berlangsung di lebih dari 20 negara di seluruh dunia."
            }
            textViewLabel.alpha = 0
            AudioServicesPlaySystemSound(1519)
            UIView.animate(withDuration: 1.0) {
                self.textViewLabel.alpha = 1
            }
        }
        else if sender.selectedSegmentIndex == 4 {
            if passedIndex == 1 {
                textViewLabel.text = "生命之树教会的建立基于牧师亚伯拉罕·帕克（Reverend Abraham Park）的信仰思想，其使命是向所有国家传播十字架的福音，救赎历史的道。生命之树教会包含所有种族，语言和文化，是基督的身体。我们的宣教声明集中在世界宣教上，遵守耶稣基督的圣言，使万民作门徒，使他们可以跳舞归主。生命之树教会摆脱了标准教会的固定形式和习惯，并与所有会众一起努力，以自己的才华和热情为教会服务。我们的目标是实现当今时代的愿景和圣经的最终愿景，这是救赎的历史。"
            }
            if passedIndex == 3 {
                textViewLabel.text = "Pyungkang Cheil长老会的创始人Reverend Abraham Park于2007年出版了《救赎史》系列的第一卷。该系列书的销量超过了450,000，创下了圣经研究书籍的空前纪录。令人惊讶的是，该系列的英文版（目前从第1卷到第5卷）还在最大的在线书店Amazon.com和拥有美国最大的书店网络的Barnes＆Noble上卖出了30,0000册。 。该系列不仅翻译成英文，还翻译成中文，日文，希伯来文，西班牙文和印度尼西亚文。赎回历史系列研讨会在全球20多个国家举行。"
            }
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
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["info.ttolc@gmail.com"])
        composeVC.setSubject("Request")
        composeVC.setMessageBody("Hello Tree of life church, ", isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }

    private func mailComposeController(controller: MFMailComposeViewController,
                           didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismiss(animated: true, completion: nil)
    }
}


