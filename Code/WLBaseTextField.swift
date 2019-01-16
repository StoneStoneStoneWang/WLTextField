//
//  WLBaseTextField.swift
//  WLTFKit_Swift
//
//  Created by three stone 王 on 2018/11/14.
//  Copyright © 2018年 three stone 王. All righWL reserved.
//
// 针对于edittype 为 define length的解决方案
// 以九宫格为例 用户点击 如果是九宫格
import UIKit
import WLToolsKit

// 参考文献 https://blog.csdn.net/Mazy_ma/article/details/70135990

//非中文：[^\\u4E00-\\u9FA5]
//非英文：[^A-Za-z]
//非数字：[^0-9]
//非中文或英文：[^A-Za-z\\u4E00-\\u9FA5]
//非英文或数字：[^A-Za-z0-9]
//非因为或数字或下划线：[^A-Za-z0-9_]

public let WLTOPLINE_TAG: Int = 1001

public let WLBOTTOMLINE_TAG: Int = 1002

fileprivate let WLDOTAFTERCOUNT: Int = 2

fileprivate let WLNUMBER_PARTTERN: String = "^[0-9]*$"

fileprivate let WLNUMBERANDCHAR_PARTTERN: String = "^[0-9a-zA-Z]*$"

fileprivate let WL_ZH_CN: String = "[^\\u4E00-\\u9FA5]"

fileprivate typealias WLTextChanged = (WLBaseTextField) -> ()

open class WLBaseTextField: UITextField {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        commitInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: topline
    fileprivate lazy var topLine: UIView = UIView().then {
        
        $0.tag = WLTOPLINE_TAG
    }
    
    fileprivate var topLineFrame: CGRect = .zero {
        
        willSet {
            
            bottomLine.frame = newValue
        }
    }
    
    fileprivate var topLineColor: UIColor = .clear {
        
        willSet {
            
            bottomLine.backgroundColor = newValue
        }
    }
    
    // MARK: bottomLine
    fileprivate lazy var bottomLine: UIView = UIView().then {
        
        $0.tag = WLBOTTOMLINE_TAG
    }
    
    fileprivate var bottomLineFrame: CGRect = .zero  {
        
        willSet {
            
            bottomLine.frame = newValue
        }
    }
    
    fileprivate var bottomLineColor: UIColor = .clear  {
        
        willSet {
            
            bottomLine.backgroundColor = newValue
        }
    }
    
    // MARK: maxLength 默认Int.max
    fileprivate var maxLength: Int = Int.max
    // MARK: 编辑类型 详情参考 枚举
    fileprivate var editType: WLTextFiledEditType = .phone {
        
        willSet {
            switch newValue {
            case .phone:
                fallthrough
            case .vcode_Length4:
                fallthrough
            case .vcode_length6:
                pattern = WLNUMBER_PARTTERN
                
                keyboardType = .phonePad
            case .priceEdit:
                let temp = maxLength == Int.max ? "" : "\(maxLength)"
                
                pattern = "^(([1-9]\\d{0,\(temp)})|0)(\\.\\d{0,2})?$"
                
                keyboardType = .decimalPad
            case .secret:
                
                pattern = WLNUMBERANDCHAR_PARTTERN
                
                keyboardType = .asciiCapable
            case .defineLength:
                //            case .only_zh_cn:
                
                NotificationCenter
                    .default
                    .addObserver(self, selector: #selector(greetingTextFieldChanged), name: NSNotification.Name(rawValue: "UITextFieldTextDidChangeNotification"), object: self)
                
                maxLength = 10
                
                keyboardType = .default
            case .only_zh_cn:
                
                NotificationCenter
                    .default
                    .addObserver(self, selector: #selector(greetingTextFieldChanged), name: NSNotification.Name(rawValue: "UITextFieldTextDidChangeNotification"), object: self)
                keyboardType = .default
            case .default:
                
                keyboardType = .default
                
                maxLength = Int.max
            }
        }
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "UITextFieldTextDidChangeNotification"), object: self)
    }
    
    // MARK: 限制输入的正则表达式字符串
    //  参考文献 https://www.jianshu.com/p/ee27e37bd079
    fileprivate var pattern: String = ""
    // MARK: 文本变化回调（observer为UITextFiled）
    fileprivate var textChanged: WLTextChanged!
}

extension WLBaseTextField {
    
    @objc open func commitInit() {
        
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
extension WLBaseTextField {
    
    public enum WLTextFiledEditType: Int {
        
        case priceEdit
        /** 手机号 默认判断是长度11位 首位为1的+86手机号 如果是复制过去的 加入了-处理机制 比如从通讯录复制*/
        case phone
        /** 密码 暗文 secureTextEntry true 6-18位 数字加字母*/
        case secret
        /** 4位验证码 */
        case vcode_Length4
        /** 6位验证码 */
        case vcode_length6
        
        case only_zh_cn // 简体中文
        
        case defineLength
        
        case `default`
        //        /** 文本内容规定长度 比如只能输入2-10个字符 */
        //        case defineLength // 这个在swift中弃用
        //        case `default` // 默认 这个在swift中弃用
    }
}
extension WLBaseTextField {
    
    @objc open func makeAttribute(_ closure: @escaping (WLBaseTextField) -> ()) {
        
        closure(self)
    }
}

// 新增属性的处理
extension WLBaseTextField {
    
    public func set_maxLength(_ maxLength: Int) {
        
        self.maxLength = maxLength
    }
    
    public func set_editType(_ editType: WLTextFiledEditType) {
        
        self.editType = editType
    }
    
    public func set_pattern(_ pattern: String) {
        
        self.pattern = pattern
    }
    
    public func set_textChanged(_ textChanged: @escaping (WLBaseTextField) -> ()) {
        
        self.textChanged = textChanged
    }
    public func set_topLineFrame(_ frame: CGRect) {
        
        topLineFrame = frame
    }
    
    public func set_bottomLineFrame(_ frame: CGRect) {
        
        bottomLineFrame = frame
    }
    public func set_topLineColor(_ color: UIColor) {
        
        topLineColor = color
    }
    
    public func set_bottomLineColor(_ color: UIColor) {
        
        bottomLineColor = color
    }
}
// MARK: UITextFieldDelegate
extension WLBaseTextField {
    
    open override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return __shouldChangeCharacters(target: textField as! WLBaseTextField,range: range,string: string)
    }
    
    private func __shouldChangeCharacters(target: WLBaseTextField , range: NSRange, string: String) -> Bool {
        
        if editType == .defineLength || editType == .only_zh_cn || editType == .default {
            
            return true
        }
        
        let nowStr = target.text ?? ""
        
        let resulWLtr = NSMutableString(string: nowStr)
        
        if string.count == 0 {
            
            resulWLtr.deleteCharacters(in: range)
        } else {
            
            if range.length == 0 {
                
                resulWLtr.insert(string, at: range.location)
            } else {
                
                resulWLtr.replaceCharacters(in: range, with: string)
            }
        }
        
        // 长度判断
        if maxLength != Int.max {
            
            if resulWLtr.length > maxLength {
                
                return false
            }
        }
        
        //正则表达式匹配
        if resulWLtr.length > 0 {
            
            if pattern.isEmpty {
                
                return true
            }
            
            return __handlePattern(content: resulWLtr as String, pattern: pattern)
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
extension WLBaseTextField {
    
    @objc open func greetingTextFieldChanged(obj: Notification) {
        
        
        
        guard let _: UITextRange = markedTextRange else{
            //当前光标的位置（后面会对其做修改）
            let cursorPostion = offset(from: endOfDocument,
                                       to: selectedTextRange!.end)
            //判断非中文的正则表达式
            let pattern = "[^\\u4E00-\\u9FA5]"
            //替换后的字符串（过滤调非中文字符）
            var str = text!.pregReplace(pattern: pattern, with: "")
            
            if editType == .defineLength {
                
                if str.count > maxLength {
                    
                    str = String(str.prefix(maxLength))
                }
            }
            
            text = str
            
            //让光标停留在正确位置
            let targetPostion = position(from: endOfDocument,
                                         offset: cursorPostion)!
            selectedTextRange = textRange(from: targetPostion,
                                          to: targetPostion)
            
            return
        }
    }
    
    @objc open func textFieldDidChange(_ textField: WLBaseTextField) {
        
        __textDidChange(target: textField)
    }
    
    // MARK: editChanged
    private func __textDidChange(target: WLBaseTextField) {
        
        switch target.editType {
        case .defineLength: break
            
        default:
            
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
        }
        
        if let textChanged = textChanged {  textChanged(target) }
        
    }
}

// MARK: editingRect and textRect rightViewRect leftViewRect
extension WLBaseTextField {
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        return super.editingRect(forBounds: bounds)
    }
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        return super.textRect(forBounds: bounds)
    }
    open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        
        return super.rightViewRect(forBounds: bounds)
    }
    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        
        return super.leftViewRect(forBounds: bounds)
    }
}
extension String {
    //使用正则表达式替换
    func pregReplace(pattern: String, with: String,
                     options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSMakeRange(0, self.count),
                                              withTemplate: with)
    }
}
