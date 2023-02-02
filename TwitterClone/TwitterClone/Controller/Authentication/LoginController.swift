//
//  LoginController.swift
//  TwitterClone
//
//  Created by Berk Kaya on 29.12.2022.
//

import UIKit

class LoginController: UIViewController {
    
    // MARK: - Properties
    private let logoImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "TwitterLogo")
        return iv
    }()
    private lazy var emailContainerView: UIView = {
        let view =  Utilities().inputContainerView(image: "ic_mail_outline_white_2x-1", textField: emailTextField)

        return view
    }()
    private lazy var passwordContainerView: UIView = {
        let view = Utilities().inputContainerView(image: "ic_lock_outline_white_2x", textField: passwordTextField)
      
        return view
    }()
    private let emailTextField : UITextField = {
       let tf = Utilities().textField(withPlaceHolder: "Email")
        return tf
    }()
    private let passwordTextField : UITextField = {
       let tf = Utilities().textField(withPlaceHolder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    private let loginButton:UIButton={
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    private let dontHaveAccountButton:UIButton = {
        let button = Utilities().attributedButton("Don't have an account?", " Sign Up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    @objc func handleLogin(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        AuthService.shared.logUserIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: ERROR LOGGIN IN \(error.localizedDescription)")
                return
            }
//            guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {return}
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            guard let window = windowScene?.windows.first(where: {$0.isKeyWindow})else{return}
            guard let tab = window.rootViewController as? MainTabController else {return}
            tab.authenticateUserAndConfigureUI()
            
            self.dismiss(animated: true)
        }
    }
    @objc func handleShowSignUp(){
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        
        //LOGO
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(width: 150, height: 150)
        
        //Stack Elements (button, email, login button, pass etc)
        let stack = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView,loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,paddingLeft: 16,paddingRight: 16)
        
        //Dont Have an account button
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingRight: 40)
    }
    
}
