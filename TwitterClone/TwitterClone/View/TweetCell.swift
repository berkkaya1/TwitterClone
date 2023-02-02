//
//  TweetCell.swift
//  TwitterClone
//
//  Created by Berk Kaya on 7.01.2023.
//

import UIKit

//handle.. func icinde aciklamasi var.
protocol TweetCellDelegate : AnyObject {
    func handleProfileImageTapped(_ cell: TweetCell)
}

class TweetCell : UICollectionViewCell {
    
    var tweet : Tweet? {
        didSet{
            configure()
        }
    }
    
    //weak memory management sagliyor sanirim isimiz bitince yok ediyor, strong olsaydı yok olmadigi icin sürekli memoryde yer kaplayacakti.
    weak var delegate : TweetCellDelegate?
    
    //MARK: - Properties
    
    private lazy var profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48/2
        iv.backgroundColor = .twitterBlue
        
        //button olmadigi icin tapgesturerecognizer ile profile yonlendirme saglayacagiz.
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        
        return iv
        
    }()
    
    private let captionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "Some test Caption"
        return label
    }()
    
    private let infoLabel = UILabel()
    
    private lazy var commentButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "retweet"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton : UIButton =  {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "share"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor,
                                left: leftAnchor,
                                paddingTop: 8,
                                paddingLeft: 8)
        
        let stack = UIStackView(arrangedSubviews: [infoLabel,captionLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 4
        
        addSubview(stack)
        stack.anchor(top: profileImageView.topAnchor,
                     left: profileImageView.rightAnchor,
                     right: rightAnchor,
                     paddingLeft: 12,
                     paddingRight: 12)
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        infoLabel.text = "Berk Kaya @berkkaya"
        
        let underlineView = UIView()
        underlineView.backgroundColor = .systemGroupedBackground
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor,
                             bottom: bottomAnchor,
                             right: rightAnchor,
                             height: 1)
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton,retweetButton,likeButton,shareButton])
        actionStack.axis = .horizontal
        actionStack.spacing = 72
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(bottom: bottomAnchor, paddingBottom: 8)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Selectors
    
    @objc func handleCommentTapped(){
        print("HELLO")
        
    }
    @objc func handleRetweetTapped(){
        
    }
    @objc func handleLikeTapped(){
        
    }
    @objc func handleShareTapped(){
        
    }
    
    @objc func handleProfileImageTapped(){
        //print("DEBUG: GO TO USER PROFILE")
        
        //bu bir viewcontroller olmadigi icin controller olusturup navigation yapamiyoruz
        //bunun ustesinden gelmek icin protocol olusturdu ve feedcontroller icinde bu protocolu bit extention icinde cagirdi boylece icine kod yazabiliyoruz.
        delegate?.handleProfileImageTapped(self)
        
        
    }
    
    //MARK: - Helpers
    
    func configure(){
        guard let tweet = tweet else {return}
        let viewModel = TweetViewModel(tweet: tweet)
        captionLabel.text = tweet.caption
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        infoLabel.attributedText = viewModel.userInfoText
        
    }
    
    
  
}
