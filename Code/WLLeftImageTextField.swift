//
//  WLLeftImageTextField.swift
//  TSTFKit_Swift
//
//  Created by three stone 王 on 2018/11/22.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

import UIKit
import TSToolKit_Swift
open class WLLeftImageTextField: WLBaseTextField {
    
    fileprivate var leftImageView: UIImageView = UIImageView()
    
    open var leftImageName: String = "" {
        
        willSet {
            
            guard !newValue.isEmpty else {
                
                return
            }
            leftViewMode = .always
            
            let image = UIImage(named: newValue)
            
            leftImageView.image = image
            
            leftImageView.contentMode = .center
            
            leftView = leftImageView
        }
    }
    
    open var leftImageFrame: CGRect = .zero {
        
        willSet {
            
            leftImageView.frame = newValue
        }
    }
}
extension WLLeftImageTextField {
    
    @objc open override func commitInit() {
        super.commitInit()
        
        leftImageFrame = CGRect(x: 0, y: 0, width: 80, height: 44)
    }
    
    @objc open override func makeAttribute(_ closure: @escaping (WLLeftImageTextField) -> ()) {
        
        closure(self)
    }
}
