//
//  ViewController.swift
//  TSTFKit_Swift
//
//  Created by three stone 王 on 2018/11/14.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

import UIKit
import WLToolsKit

class ViewController: UIViewController {
    
    let aaa = UITextField(frame: CGRect(x: 0, y: 200, width: 300, height: 44))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    fileprivate final let tf = WLBaseTextField(frame: CGRect(x: 0, y: 100, width: 400, height: 44))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tf)
        
        tf.makeAttribute { (make) in
            
            make.set_maxLength(12)
            
            make.set_editType(.defineLength)
            
            make.set_textChanged({ (tf) in
                
                printLog(message: tf.text)
            })
            
            make.set_textColor(WLHEXCOLOR(hexColor: "#555555"))
            
            make.set_backgroundColor(WLHEXCOLOR(hexColor: "#eeeeee"))
        }
        
        tf.backgroundColor = .red
        
        tf.set_bottomLineColor(.green)
    
        tf.set_bottomLineFrame(CGRect(x: 80, y: 43, width: 80, height: 1))
    }
}
