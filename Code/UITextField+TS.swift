//
//  UITextField+TS.swift
//  TSTFKit_Swift
//
//  Created by three stone 王 on 2018/11/17.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    public func set_backgroundColor(_ color: UIColor) {
        
        backgroundColor = color
    }
    
    public func set_font(_ font: UIFont) {
        
        self.font = font
    }
    public func set_textColor(_ color: UIColor) {
        
        textColor = color
    }
    public func set_textAlignment(_ alignment: NSTextAlignment) {
        
        textAlignment = alignment
    }
    
    public func set_keyboardType(_ keyboardType: UIKeyboardType) {
        
        self.keyboardType = keyboardType
    }
    
    public func set_clearButtonMode(_ clearButtonMode: UITextField.ViewMode) {
        
        self.clearButtonMode = clearButtonMode
        
    }
    
    public func set_returnKeyType(_ returnKeyType: UIReturnKeyType) {
        
        self.returnKeyType = returnKeyType
    }
    
    public func set_rightViewMode(_ rightViewMode: UITextField.ViewMode) {
        
        self.rightViewMode = rightViewMode
    }
    public func set_leftViewMode(_ leftViewMode: UITextField.ViewMode) {
        
        self.leftViewMode = leftViewMode
    }
    
    public func set_leftView(_ leftView: UIView) {
        
        self.leftView = leftView
    }
    public func set_rightView(_ rightView: UIView) {
        
        self.rightView = rightView
    }
    
    
}

public typealias TSShouldReturn = () -> Bool

public typealias TSShouldClear = () -> Bool

extension UITextField: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    fileprivate var shouldReturn: TSShouldReturn! {
        set {
            
            objc_setAssociatedObject(self, "shouldReturn", newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            
            return objc_getAssociatedObject(self, "shouldReturn") as? TSShouldReturn
        }
    }
    
    public func set_shouldReturn(_ shouldReturn: @escaping () -> Bool) {
        
        self.shouldReturn = shouldReturn
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if shouldReturn == nil {
            
            return true
        }
        
        return shouldReturn!()
    }
    
    fileprivate var shouldClear: TSShouldClear! {
        
        set {
            
            objc_setAssociatedObject(self, "shouldClear", newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            
            return objc_getAssociatedObject(self, "shouldClear") as? TSShouldClear
        }
    }
    
    public func set_shouldClear(_ shouldClear: @escaping () -> Bool) {
        
        self.shouldClear = shouldClear
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        if shouldClear == nil {
            
            return true
        }
        
        return shouldClear!()
    }
}
