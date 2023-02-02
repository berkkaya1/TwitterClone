//
//  MainTabController.swift
//  TwitterClone
//
//  Created by Berk Kaya on 28.12.2022.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    
    // MARK: - Properties
     let actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    var user: User?{
        //didset olusturulup icine atama yapılınca calisiyor.
        //feedcontrollerimiz navigation controller icine gomulu oldugu icin oncelikle navigation controllerimiz var mı diye control ediyoruz, sonrasında feedcontroller icine ulasiyoruz ve olusturdugumuz user objesini burdan oraya atıyoruz.
        didSet{
            guard let nav = viewControllers?[0] as? UINavigationController else {return}
            guard let feed = nav.viewControllers.first as? FeedController else {return}
            feed.user = user
            
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //logUserOut()
        view.backgroundColor = .twitterBlue
        authenticateUserAndConfigureUI()
    }
    
    //MARK: - API
    //If the current user is nil, program starts in login screen.
    func authenticateUserAndConfigureUI(){
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
            //if there is a user then open our main screen (for that: calling config functions.)
        }else {
            tabbarShowUpSettings()
            configureViewControllers()
            configureUI()
            fetchUser()
        }
    }
    func logUserOut(){
        do {
            try Auth.auth().signOut()
        }catch let error {
            print("DEBUG: FAILED TO SIGN OUT WITH ERROR \(error.localizedDescription)")
        }
    }
    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
    
    //MARK: - Selectors
    @objc func actionButtonTapped(){
        //Diger tarafta init olusturarak icine burdaki user bilgilerini yollayabiliyoruz.
        guard let user = user else {return}
        let controller = UploadTweetController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
      
    }
    
    // MARK: - Helpers
    func configureUI(){
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56 ,height: 56)
        actionButton.layer.cornerRadius = 56/2
        
    }
    //Tabbar-NavigationBar
    func configureViewControllers(){
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feed)
        
        let explore = ExploreController()
        let nav2 = templateNavigationController(image:  UIImage(named: "search_unselected"), rootViewController: explore)
        
        let notifications = NotificationsController()
        let nav3 = templateNavigationController(image:  UIImage(named: "like_unselected"), rootViewController: notifications)
        
        let conversations = ConversationsController()
        let nav4 = templateNavigationController(image:  UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: conversations)
        
        viewControllers = [nav1,nav2,nav3,nav4]
        
    }
    func templateNavigationController(image: UIImage?,rootViewController: UIViewController) -> UINavigationController{
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        //Navigation Bar show up settings.
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance
        return nav
    }
    //tabbar showup settings.
    func tabbarShowUpSettings() {
        if #available(iOS 15.0, *){
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
