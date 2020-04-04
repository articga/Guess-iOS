//
//  MenuCollectionVC.swift
//  Guess
//
//  Created by Rene Dubrovski on 4/4/20.
//  Copyright © 2020 articga. All rights reserved.
//

import UIKit

class MenuCollectionVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let collectionViewCellID = "mainCell"
    let modeCollectionView = UICollectionView(frame: CGRect.null, collectionViewLayout: UICollectionViewFlowLayout())
    var collectionViewData = [Topic]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let quizSession = QuizSession()
        collectionViewData = quizSession.fetchForCollectionView(type: .offline)
        setUPCollectionView()
        modeCollectionView.register(CatCell.self, forCellWithReuseIdentifier: collectionViewCellID)
        
        navigationItem.title = "Modes"
        navigationController?.navigationBar.prefersLargeTitles = true
        setProfileButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layer.insertSublayer(generateBGGradient(), at: 0)
    }
    
    func setProfileButton() {
        let avatarSize: CGFloat = 30
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: avatarSize, height: avatarSize)
        button.setImage(UIImage(named: "placeholder_avatar")?.resizeImage(avatarSize, opaque: false), for: .normal)
        button.addTarget(self, action: #selector(launchProfileView), for: .touchUpInside)

        if let buttonImageView = button.imageView {
            button.imageView?.layer.cornerRadius = buttonImageView.frame.size.width / 2
            button.imageView?.clipsToBounds = true
            button.imageView?.contentMode = .scaleAspectFit
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc func launchProfileView() {
        let vc = ProfileDetailsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setUPCollectionView() {
        modeCollectionView.backgroundColor = .clear
        modeCollectionView.dataSource = self
        modeCollectionView.delegate = self
        view.addSubview(modeCollectionView)
        modeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        modeCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        modeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        modeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        modeCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellID, for: indexPath) as! CatCell
        cell.categoryData = collectionViewData[indexPath.row]
        cell.menuCollectionVC = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 160)
    }
    
    func show(mode: QuizSession.QuizMode) {
        print(mode)
        let vc = QuizModeVC()
        vc.mode = mode
        vc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
    }
    

}

class CatCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private let cellID = "mCell"
    let count = 0
    
    //To call pushfunc
    var menuCollectionVC: MenuCollectionVC?
    
    var categoryData: Topic? {
        didSet {
            if let title = categoryData?.title {
                topicLabel.text = title
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let modesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let divLine: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let topicLabel: UILabel = {
        let l = UILabel()
        l.text = "N/A"
        l.numberOfLines = 1
        l.font = UIFont(name: "HelveticaNeue-Bold", size: 15.0)
        l.textColor = .white
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    func setupViews() {
        backgroundColor = .clear
        addSubview(modesCollectionView)
        addSubview(divLine)
        addSubview(topicLabel)
        
        modesCollectionView.dataSource = self
        modesCollectionView.delegate = self
        
        modesCollectionView.register(ModeCell.self, forCellWithReuseIdentifier: cellID)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": modesCollectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lab(30)][v0][v1(0.5)]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": modesCollectionView, "v1": divLine, "lab": topicLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": topicLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": divLine]))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = categoryData?.quizzes?.count {
            return count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ModeCell
        cell.mode = categoryData?.quizzes![indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: frame.height - 34)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let mode = categoryData?.quizzes![indexPath.row].mode {
            menuCollectionVC?.show(mode: mode)
        }
    }
    
}

class ModeCell: UICollectionViewCell {
    
    var mode: Quiz? {
        didSet {
            if let name = mode?.title {
                modeTitle.text = name
            }
            
            if let bgColor = mode?.boxColor {
                modeBG.backgroundColor = bgColor
            }
            
            if let imageString = mode?.imageTitle {
                modeImage.image = UIImage(named: imageString)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUPViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let modeBG: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 30
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let modeImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let modeTitle: UILabel = {
        let l = UILabel()
        l.text = "N/A"
        l.textColor = .white
        l.font = UIFont(name: "HelveticaNeue-Regular", size: 15.0)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    func setUPViews() {
        addSubview(modeBG)
        modeBG.addSubview(modeImage)
        addSubview(modeTitle)
        
        modeBG.topAnchor.constraint(equalTo: topAnchor, constant: 0.0).isActive = true
        modeBG.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        modeBG.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        modeImage.topAnchor.constraint(equalTo: modeBG.topAnchor, constant: 10.0).isActive = true
        modeImage.leadingAnchor.constraint(equalTo: modeBG.leadingAnchor, constant: 10.0).isActive = true
        modeImage.trailingAnchor.constraint(equalTo: modeBG.trailingAnchor, constant: -10.0).isActive = true
        modeImage.bottomAnchor.constraint(equalTo: modeBG.bottomAnchor, constant: -10.0).isActive = true
        
        modeTitle.topAnchor.constraint(equalTo: modeBG.bottomAnchor, constant: 2.0).isActive = true
        modeTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1.0).isActive = true
        modeTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1.0).isActive = true
        modeTitle.heightAnchor.constraint(equalToConstant: 17.0).isActive = true
    }
    
}
