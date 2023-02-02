//
//  CaptionTextView.swift
//  TwitterClone
//
//  Created by Berk Kaya on 6.01.2023.
//

import UIKit

class CaptionTextView :UITextView {
    
    //MARK: - Properties
    let placeholderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "What's happening"
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = true
        heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        //Kendisi subview oldugu icin bir daha view. dememize gerek yok.
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor,left: leftAnchor,paddingTop: 8,paddingLeft: 4)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleTextInputChange(){
        //if text.isEmpty, placeholderlabel.ishidden = false else true
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    
}
