//
//  RegistrationController.swift
//  TwitterClone
//
//  Created by Berk Kaya on 29.12.2022.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    
    // MARK: - Properties
    private let imagePicker = UIImagePickerController()
    private var profileImage : UIImage?
    private let plusPhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
        return button
    }()
    private lazy var emailContainerView: UIView = {
        let view =  Utilities().inputContainerView(image: "ic_mail_outline_white_2x-1", textField: emailTextField)
        
        return view
    }()
    private lazy var passwordContainerView: UIView = {
        let view = Utilities().inputContainerView(image: "ic_lock_outline_white_2x", textField: passwordTextField)
        
        return view
    }()
    private lazy var fullnameContainerView: UIView = {
        let view =  Utilities().inputContainerView(image: "ic_person_outline_white_2x", textField: fullnameTextField)
        
        return view
    }()
    private lazy var usernameContainerView: UIView = {
        let view = Utilities().inputContainerView(image: "ic_person_outline_white_2x", textField: usernameTextField)
        
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
    private let fullnameTextField : UITextField = {
        let tf = Utilities().textField(withPlaceHolder: "Full Name")
        return tf
    }()
    private let usernameTextField : UITextField = {
        let tf = Utilities().textField(withPlaceHolder: "Username")
        return tf
    }()
    private let alreadyHaveAccountButton:UIButton = {
        let button = Utilities().attributedButton("Already have an account?", " Sign In")
        button.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        return button
    }()
    private let registrationButton:UIButton={
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    @objc func handleLogIn(){
        navigationController?.popViewController(animated: true)
    }
    @objc func handleRegistration(){
        guard let profileImage = profileImage else {
            print("DEBUG: PLEASE SELECT A PROFILE IMAGE...")
            return
        }
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let fullname = fullnameTextField.text else {return}
        guard let username = usernameTextField.text?.lowercased() else {return}
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        
        AuthService.shared.registerUser(credentials: credentials) { error, ref in
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            guard let window = windowScene?.windows.first(where: {$0.isKeyWindow})else{return}
            guard let tab = window.rootViewController as? MainTabController else {return}
            tab.authenticateUserAndConfigureUI()
            
            self.dismiss(animated: true)
        }
    }
    @objc func handleAddProfilePhoto(){
        present(imagePicker,animated: true,completion: nil)
    }
    
    // MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.isHidden = true
        
        //ImagePicker
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        //Photo adding button.
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor,paddingTop: 30)
        plusPhotoButton.setDimensions(width: 128, height: 128)
        
        //Stack Elements (button, email, login button, pass etc)
        let stack = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView,fullnameContainerView,usernameContainerView,registrationButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,paddingTop: 10,paddingLeft: 32,paddingRight: 32)
        
        
        //Already have an account button
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,paddingLeft: 40, paddingRight: 40)
        
        
    }
}

//MARK: - UIIMAGEPICKERCONTROLLERDELEGATE
extension RegistrationController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else {return}
        self.profileImage = profileImage
        plusPhotoButton.layer.cornerRadius = 128/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleToFill
        plusPhotoButton.imageView?.clipsToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3
        self.plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true)
    }
}
