//
//  Utilities.swift
//  TwitterClone
//
//  Created by Berk Kaya on 29.12.2022.
//

import UIKit

class Utilities {
    func inputContainerView(image: String, textField:UITextField) ->UIView {
        let view = UIView()
        let iv = UIImageView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        iv.image = UIImage(named: image)
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
        iv.setDimensions(width: 24, height: 24)
        
        view.addSubview(textField)
        textField.anchor(left: iv.rightAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,paddingLeft: 8,paddingBottom: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        view.addSubview(dividerView)
        dividerView.anchor(left: view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,paddingLeft: 10,paddingRight: 20,height: 0.75)
    
        return view
    }
    func textField(withPlaceHolder placeholder:String) -> UITextField {
        let tf = UITextField()
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
        return tf
    }
    func attributedButton(_ firstPartText: String, _ secondPartText: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: firstPartText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor:UIColor.white])
        attributedTitle.append(NSAttributedString(string: secondPartText, attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16),NSAttributedString.Key.foregroundColor:UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }
}
