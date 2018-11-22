//
//  WLLeftTitleTextField.swift
//  TSTFKit_Swift
//
//  Created by three stone 王 on 2018/11/22.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

import UIKit
import TSToolKit_Swift
class WLLeftTitleTextField: WLBaseTextField {
    
    open var leftTitleLabel: UILabel = UILabel()
    
    open var leftTitle: String = "" {
        
        willSet {
            
            guard !newValue.isEmpty else {
                
                return
            }
            leftViewMode = .always
            
            leftTitleLabel.textAlignment = .center
            
            leftTitleLabel.textColor = TSHEXCOLOR(hexColor: "#666666")
            
            leftTitleLabel.font = UIFont.systemFont(ofSize: 15)
            
            leftView = leftTitleLabel
        }
    }
    
    open var leftTitleFrame: CGRect = .zero {
        
        willSet {
            
            leftTitleLabel.frame = newValue
        }
    }
    
}
extension WLLeftTitleTextField {
    
    @objc open override func commitInit() {
        super.commitInit()
        
        leftTitleFrame = CGRect(x: 0, y: 0, width: 80, height: 44)
    }
}
