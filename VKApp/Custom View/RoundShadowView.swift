//
//  RoundShadowView.swift
//  VKApp
//
//  Created by Denis Kuzmin on 09.04.2021.
//

import UIKit

@IBDesignable class RoundShadowView: UIView {

    //MARK - @IBInspectable properties
    
    @IBInspectable var autoSizeForShadow: Bool = true {
        didSet {
            if autoSizeForShadow {
                radius = bounds.height / 2
                shadowRadius = radius / 10
                shadowOffset = CGSize(width: radius / 10, height: radius / 10)
            }
        }
    }
    
    @IBInspectable var radius: CGFloat = 20 {
        didSet {
            if autoSizeForShadow {
                shadowRadius = radius / 10
                shadowOffset = CGSize(width: radius / 10, height: radius / 10)
            }
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 2, height: 2)
    
    var image: UIImage? {
        didSet {
            setNeedsLayout()
            draw(bounds)
        }
    }
    @IBInspectable var shadowOpacity: CGFloat = 0.9 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable private var shadowRadius: CGFloat = 2 {
        didSet {
            setNeedsLayout()
        }
    }
    
    //MARK - Properties
    
    private let imageView = UIImageView()
    
    var shadowColor = UIColor.black.cgColor {
        didSet {
            setNeedsLayout()
        }
    }
    
    private let shadowLayer = CALayer()
    
    // MARK - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    //MARK - Overrided methods
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        if autoSizeForShadow {
            radius = bounds.height / 2
            shadowRadius = radius / 10
        }
        layer.masksToBounds = false
        backgroundColor = .clear
        
        for subview in subviews {
            subview.removeFromSuperview()
        }
        addSubview(imageView)

        imageView.image = image
        imageView.bounds = bounds
        imageView.frame = bounds
        imageView.layer.cornerRadius = radius
        imageView.layer.masksToBounds = true
        imageView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
                
        if shadowLayer.superlayer == nil {
            layer.addSublayer(shadowLayer)
        }
        shadowLayer.bounds = bounds
        shadowLayer.cornerRadius = radius
        shadowLayer.shadowOpacity = 0.9
        shadowLayer.shadowColor = shadowColor
        shadowLayer.shadowRadius = shadowRadius
        shadowLayer.shadowOffset = shadowOffset
        shadowLayer.backgroundColor = UIColor.white.cgColor
        shadowLayer.frame = bounds
        shadowLayer.zPosition = -1

    }
    
    //MARK - Private methods    
    
    private func setUpView(){
        layer.addSublayer(shadowLayer)
    }
    
}
