//
//  CustomTextField.swift
//  uiimageview_scaleaspectfill_image_rect
//
//  Created by AamirR on 5/21/19.
//  Copyright © 2019 AamirR. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    private let normalStateColor = UIColor.lightGray.cgColor
    private let focusStateColor = UIColor.black.cgColor
    
    private let padding = UIEdgeInsets.zero
    private let border = CALayer()
    private let borderHeight: CGFloat = 4.0
    
    // MARK:- Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        setup()
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    // MARK:- Overrides
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = self.frame.size
        self.border.frame = CGRect(x: 0, y: size.height - borderHeight, width: size.width, height: borderHeight)
    }
    
    override func willMove(toSuperview newSuperview: UIView!) {
        guard newSuperview != nil else {
            NotificationCenter.default.removeObserver(self)
            return
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(beginEdit),
                                               name: UITextField.textDidBeginEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(endEdit),
                                               name: UITextField.textDidEndEditingNotification, object: self)
    }
    
    @objc func beginEdit() {
        border.backgroundColor = self.focusStateColor
    }
    
    @objc func endEdit() {
        border.backgroundColor = self.normalStateColor
    }
    
    private func setup() {
        border.backgroundColor = self.normalStateColor
        textAlignment = .center
        borderStyle = .none
        layer.addSublayer(border)
        delegate = self
    }
}

extension CustomTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.count < 1  && string.count > 0 {
            textField.text = string
            textField.superview?.viewWithTag(textField.tag + 1)?.becomeFirstResponder()
            return false
        } else if textField.text!.count >= 1  && string.count == 0 {
            let previousTag = textField.tag - 1
            var previousResponder = textField.superview?.viewWithTag(previousTag)
            
            if (previousResponder == nil){
                previousResponder = textField.superview?.viewWithTag(1)
            }
            textField.text = ""
            previousResponder?.becomeFirstResponder()
            return false
        }
        
        return true
    }
}
