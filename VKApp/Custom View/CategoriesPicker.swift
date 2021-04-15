//
//  CategoriesPicker.swift
//  VKApp
//
//  Created by Denis Kuzmin on 11.04.2021.
//

import UIKit
import AudioToolbox

@IBDesignable class CategoriesPicker: UIControl {

    enum PickerStyle {
        case all
        case adaptive
    }
    
    var style: PickerStyle = .adaptive
    
    var categories = [String]() {
        didSet {
            setNeedsLayout()
        }
    }
    var pickedCategory: Int = 0
    private var buttons = [UIButton]()
    private var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCategories()
        stackView.frame = bounds
    }
    
    private func setUpView() {
        backgroundColor = .clear
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(controlPan(_:)))
        addGestureRecognizer(panGestureRecognizer)
        updateCategories()
    }
    
    
    @objc private func controlPan(_ recognizer: UIGestureRecognizer) {
        let y = recognizer.location(in: self).y
        pickedCategory = Int(y / bounds.height * CGFloat(categories.count))
        print("highlightcategory: \(pickedCategory)")
        sendActions(for: .valueChanged)
    }
    
    @objc private func buttonTouchUp(_ sender: UIButton) {
        pickedCategory = sender.tag
        sendActions(for: .valueChanged)
    }
    
    private func updateCategories() {
        let symbolHeight: CGFloat = 30.0
        buttons = []
        if stackView != nil {
            stackView.removeFromSuperview()
        }
        stackView = nil
        
        guard categories.count > 0 else { return}
        var maxSymbols = categories.count
        if Int(bounds.height / symbolHeight) < categories.count && style == .adaptive {
            maxSymbols = Int(bounds.height / symbolHeight)
        }
        let step = Int(Double(categories.count / maxSymbols).rounded())
        buttons.append(makeButton(title: categories.first!, tag: 0))
        if style == .adaptive {
            buttons.append(makeButton(title: "\u{2022}", tag: Int(step / 2)))
        }
        for i in 1 ..< maxSymbols - 1 {
            let tag = i * step
            let title = categories[tag]
            buttons.append(makeButton(title: title, tag: tag))
            if style == .adaptive {
                buttons.append(makeButton(title: "\u{2022}", tag: tag + Int(step / 2)))
            }
        }
        buttons.append(makeButton(title: categories.last!, tag: categories.count - 1))
        stackView = UIStackView(arrangedSubviews: buttons)
        stackView.backgroundColor = .clear
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
    }
    
    private func makeButton(title: String, tag: Int) -> UIButton {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(buttonTouchUp(_:)), for: .touchUpInside)
        button.tag = tag
        return button
    }

}
