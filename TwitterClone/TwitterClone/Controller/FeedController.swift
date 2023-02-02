//
//  FeedController.swift
//  TwitterClone
//
//  Created by Berk Kaya on 28.12.2022.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "TweetCell"

//collectionview cell'lerden olusuyor tableview prototypecell gibi.
class FeedController : UICollectionViewController {
    
    // MARK: - Properties
    private var tweets = [Tweet](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    var user: User?{
        didSet{configureLeftBarButton()}
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        fetchTweets()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - API
    func fetchTweets(){
        TweetService().fetchTweets { tweets in
                self.tweets = tweets
        }
    }
    
    // MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .white
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
        
    }
    func configureLeftBarButton(){
        guard let user = user else {return}
        
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32/2
        profileImageView.layer.masksToBounds = true
        profileImageView.sd_setImage(with:user.profileImageUrl, completed: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
    
}

//MARK: - UICollectionViewDelegate/DataSource
//collectionview ozelliklerini ekleyecegiz
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        //tweetcell icinde olusturdugumuz protocolun delegateini burda handle ediyoruz.
        cell.delegate = self
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowlayout
extension FeedController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

//tweetcell icinde yapamadigimiz islemi burda yaptik (extention olustararak protocole eristip burda yapıyoruz navigationu. TweetCell line: 11, line: 80

//MARK: - TweetCellDelegate
extension FeedController: TweetCellDelegate {
    func handleProfileImageTapped(_ cell: TweetCell) {
        guard let user = cell.tweet?.user else {return}
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
