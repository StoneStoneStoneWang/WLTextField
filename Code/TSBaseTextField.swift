//
//  TSBaseTextField.swift
//  TSTFKit_Swift
//
//  Created by three stone 王 on 2018/11/14.
//  Copyright © 2018年 three stone 王. All rights reserved.
//
// 针对于edittype 为 define length的解决方案
// 以九宫格为例 用户点击 如果是九宫格
import UIKit
import TSToolKit_Swift

fileprivate let TSTOPLINE_TAG: Int = 1001

fileprivate let TSBOTTOMLINE_TAG: Int = 1002

fileprivate let TSDOTAFTERCOUNT: Int = 2

fileprivate typealias TSTextChanged = (TSBaseTextField) -> ()

public class TSBaseTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commitInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: topline
    fileprivate lazy var topLine: UIView = UIView().then {
        
        $0.tag = TSTOPLINE_TAG
    }
    
    public var topLineFrame: CGRect = .zero
    
    fileprivate var topLineColor: UIColor = .clear
    
    // MARK: bottomLine
    fileprivate lazy var bottomLine: UIView = UIView().then {
        
        $0.tag = TSBOTTOMLINE_TAG
    }
    
    fileprivate var bottomLineFrame: CGRect = .zero
    
    fileprivate var bottomLineColor: UIColor = .clear
    
    // MARK: maxLength 默认Int.max
    fileprivate var maxLength: Int = Int.max
    // MARK: 编辑类型 详情参考 枚举
    fileprivate var editType: TSTextFiledEditType = .phone {
        
        willSet {
            switch newValue {
            case .phone:
                fallthrough
            case .vcode_Length4:
                fallthrough
            case .vcode_length6:
                pattern = "^[0-9]*$"
                
                keyboardType = .phonePad
            case .priceEdit:
                let temp = maxLength == Int.max ? "" : "\(maxLength)"
                
                pattern = "^(([1-9]\\d{0,\(temp)})|0)(\\.\\d{0,2})?$"
                
                keyboardType = .decimalPad
            case .secret:
                
                pattern = "^[0-9a-zA-Z]*$"
                
                keyboardType = .asciiCapable
            }
        }
    }
    
    // MARK: 限制输入的正则表达式字符串
    //  参考文献 https://www.jianshu.com/p/ee27e37bd079
    fileprivate var pattern: String = ""
    // MARK: 文本变化回调（observer为UITextFiled）
    fileprivate var textChanged: TSTextChanged!
}

extension TSBaseTextField {
    
    public func commitInit() {
        
        backgroundColor = .clear
        
        font = UIFont.systemFont(ofSize: 15)
        
        clearButtonMode = .whileEditing
        
        returnKeyType = .done
        
        autocorrectionType = .no
        
        delegate = self
        
        addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        addSubview(topLine)
        
        addSubview(bottomLine)
    }
}

/** 文本框内容 样式 */
extension TSBaseTextField {
    
    public enum TSTextFiledEditType: Int {
        
        case priceEdit
        /** 手机号 默认判断是长度11位 首位为1的+86手机号 如果是复制过去的 加入了-处理机制 比如从通讯录复制*/
        case phone
        /** 密码 暗文 secureTextEntry true 6-18位 数字加字母*/
        case secret
        /** 4位验证码 */
        case vcode_Length4
        /** 6位验证码 */
        case vcode_length6
        //        /** 文本内容规定长度 比如只能输入2-10个字符 */
        //        case defineLength // 这个在swift中弃用
        //        case `default` // 默认 这个在swift中弃用
    }
}
extension TSBaseTextField {
    
    public func makeAttribute(_ closure: @escaping (TSBaseTextField) -> ()) {
        
        closure(self)
    }
}

// 新增属性的处理
extension TSBaseTextField {
    
    public func set_maxLength(_ maxLength: Int) {
        
        self.maxLength = maxLength
    }
    
    public func set_editType(_ editType: TSTextFiledEditType) {
        
        self.editType = editType
    }
    
    public func set_pattern(_ pattern: String) {
        
        self.pattern = pattern
    }
    
    public func set_textChanged(_ textChanged: @escaping (TSBaseTextField) -> ()) {
        
        self.textChanged = textChanged
    }
    public func set_topLineFrame(_ frame: CGRect) {
        
        topLine.frame = frame
    }
    
    public func set_bottomLineFrame(_ frame: CGRect) {
        
        bottomLine.frame = frame
    }
    public func set_topLineColor(_ color: UIColor) {
        
        topLine.backgroundColor = color
    }
    
    public func set_bottomLineColor(_ color: UIColor) {
        
        topLine.backgroundColor = color
    }
}

extension TSBaseTextField {
    
    public override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return __shouldChangeCharacters(target: textField as! TSBaseTextField,range: range,string: string)
    }
    
    private func __shouldChangeCharacters(target: TSBaseTextField , range: NSRange, string: String) -> Bool {
        
        let nowStr = target.text ?? ""
        
        let resultStr = NSMutableString(string: nowStr)
        
        if string.count == 0 {
            
            resultStr.deleteCharacters(in: range)
        } else {
            
            if range.length == 0 {
                
                resultStr.insert(string, at: range.location)
            } else {
                
                resultStr.replaceCharacters(in: range, with: string)
            }
        }
        
        // 长度判断
        if maxLength != Int.max {
            
            if resultStr.length > maxLength {
                
                return false
            }
        }
        
        //正则表达式匹配
        if resultStr.length > 0 {
            
            if pattern.isEmpty {
                
                return true
            }
            
            return __handlePattern(content: resultStr as String, pattern: pattern)
        }
        
        return true
    }
    
    // MARK: __handlePattern
    private func __handlePattern(content: String ,pattern: String) -> Bool {
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            
            let result = regex.matches(in: content, options: [.reportProgress], range: NSRange(location: 0, length: content.count))
            
            return result.count > 0
        } catch  {
            
            return true
        }
    }
}


// MARK: textFieldDidChange
extension TSBaseTextField {
    
    @objc public func textFieldDidChange(_ textField: TSBaseTextField) {
        
        __textDidChange(target: textField)
    }
    
    // MARK: editChanged
    private func __textDidChange(target: TSBaseTextField) {
        
        var resultText: String = target.text ?? ""
        
        // 内容适配
        if maxLength != Int.max {
            
            //先内容过滤
            if editType == .phone ||  editType == .vcode_Length4 ||  editType == .vcode_length6 {
                
                resultText = resultText.replacingOccurrences(of: " ", with: "")
            }
            //再判断长度
            
            if resultText.count > maxLength && target.value(forKey: "markedTextRange") == nil {
                
                while resultText.count > maxLength {
                    
                    resultText = "\(resultText[..<resultText.index(before: resultText.endIndex)])"
                }
                
                target.setValue(resultText, forKey: "text")
            } else {
                
                target.setValue(resultText, forKey: "text")
            }
        }
        
        if let textChanged = textChanged {
            
            textChanged(target)
        }
    }
}

// MARK: editingRect and textRect rightViewRect leftViewRect
extension TSBaseTextField {
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        return super.editingRect(forBounds: bounds)
    }
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        return super.textRect(forBounds: bounds)
    }
    public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        
        return super.rightViewRect(forBounds: bounds)
    }
    public override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        
        return super.leftViewRect(forBounds: bounds)
    }
}
