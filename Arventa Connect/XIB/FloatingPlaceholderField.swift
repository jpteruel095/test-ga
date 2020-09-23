//
//  PlaceholderField.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/23/20.
//

import UIKit

@objc protocol FloatingPlaceholderFieldDelegate{
    @objc optional func fieldDidBeginEditing(_ field: FloatingPlaceholderField)
    @objc optional func fieldDidEndEditing(_ field: FloatingPlaceholderField)
    @objc optional func fieldEditingChanged(_ field: FloatingPlaceholderField)
    @objc optional func fieldShouldReturn(_ field: FloatingPlaceholderField) -> Bool
}

class FloatingPlaceholderField: UIView{
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var floatingPlaceholderLabel: UILabel!
    @IBOutlet weak var largePlaceholderLabel: UILabel!
    
    private let nibName = "FloatingPlaceholderField"
    private var placeholderLabel: UILabel?
    
    @IBOutlet var delegate: FloatingPlaceholderFieldDelegate?
    
    var contentView: UIView?
    var isFloating = false
    
    @IBInspectable
    var text: String?{
        get{
            return textField.text
        }
        set{
            textField.text = newValue
            toggleFloatingLabel()
        }
    }
    
    @IBInspectable
    var placeholder: String?{
        get{
            return placeholderLabel?.text
        }set{
            largePlaceholderLabel.text = newValue
            floatingPlaceholderLabel.text = newValue
            placeholderLabel?.text = newValue
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        
        //add here?
        let label = UILabel(frame: .zero)
        label.text = largePlaceholderLabel.text
        label.font = largePlaceholderLabel.font
        label.textColor = largePlaceholderLabel.textColor
        label.sizeToFit()
        view.addSubview(label)
        label.center = largePlaceholderLabel.center
        placeholderLabel = label
        
        self.addSubview(view)
        contentView = view
    }
    
    override func awakeFromNib() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        
        layoutSubviews()
        isFloating = true
        toggleFloatingLabel()
        layoutIfNeeded()
    }
    
    func toggleFloatingLabel(){
        if textField.trimmedText.count > 0 || textField.isFirstResponder {
            if isFloating{
                return
            }
            // Will Float
            isFloating = true
            UIView.animate(withDuration: 0.25) {
                self.placeholderLabel?.font = self.floatingPlaceholderLabel.font
                self.placeholderLabel?.sizeToFit()
                self.placeholderLabel?.center = self.floatingPlaceholderLabel.center
            }
        }else{
            if !isFloating{
                return
            }
            // Will Rest
            isFloating = false
            UIView.animate(withDuration: 0.25) {
                self.placeholderLabel?.font = self.largePlaceholderLabel.font
                self.placeholderLabel?.sizeToFit()
                self.placeholderLabel?.center = self.largePlaceholderLabel.center
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension FloatingPlaceholderField: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.toggleFloatingLabel()
        delegate?.fieldDidBeginEditing?(self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.toggleFloatingLabel()
        delegate?.fieldDidEndEditing?(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let delegate = delegate{
            return delegate.fieldShouldReturn?(self) ?? true
        }
        return true
    }
    
    @objc func textFieldEditingChanged(_ textField: UITextField){
        delegate?.fieldEditingChanged?(self)
    }
}
