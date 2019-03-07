# WLTextField

## 依托于MXThenAction 本想使用响应式 链式语法但是发现链式有链式的好 非链式有非链式的好 



## pod 'WLTextField'


        fileprivate final let tf = WLBaseTextField(frame: CGRect(x: 0, y: 100, width: 400, height: 44))

        view.addSubview(tf)
        
        tf.makeAttribute { (make) in
            
            make.set_maxLength(11)
            
            make.set_editType(.phone)
            
            make.set_textChanged({ (tf) in
                
                printLog(message: tf.text)
            })
            
            make.set_textColor(WLHEXCOLOR(hexColor: "#555555"))
            
            make.set_backgroundColor(WLHEXCOLOR(hexColor: "#eeeeee"))
        }
