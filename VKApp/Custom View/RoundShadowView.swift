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
            //draw(bounds)
            
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
        
        /*for subview in subviews {
            subview.removeFromSuperview()
        }*/

        let x = bounds.minX
        let y = bounds.midY
        let height = bounds.height
        let width = bounds.width
        let dx = width * 0.2
        let dy = height * 0.2
        
        let rect = CGRect(x: x+dx, y: y+dy, width: width - 2 * dx, height: height - 2 * dy)
        
        
        imageView.image = image
        imageView.bounds = rect
        imageView.frame = rect
        imageView.layer.cornerRadius = radius
        imageView.layer.masksToBounds = true
        imageView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        imageView.contentMode = .scaleAspectFill
        //addSubview(imageView)
                
        /*if shadowLayer.superlayer == nil {
            layer.addSublayer(shadowLayer)
        }*/
        shadowLayer.bounds = bounds
        shadowLayer.cornerRadius = radius
        shadowLayer.shadowOpacity = 0.9
        shadowLayer.shadowColor = shadowColor
        shadowLayer.shadowRadius = shadowRadius
        shadowLayer.shadowOffset = shadowOffset
        shadowLayer.backgroundColor = UIColor.white.cgColor
        shadowLayer.frame = frame
        shadowLayer.zPosition = -1
        
        

    }
    
    func springAnimateBounds(duration: TimeInterval, scale: CGFloat) {
        
        var rect: CGRect = bounds
        draw(rect)
        
        print("bounds start = \(bounds)")
        print("frame start = \(frame)")
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1) { [self] in
            let dx = bounds.width * scale
            let dy = bounds.height * scale
            bounds = CGRect(x: bounds.minX + dx, y: bounds.minY + dy, width: bounds.width - dx, height: bounds.height - dy)
            
            //draw(rect)
        }
        //draw(rect)
        print("bounds end = \(bounds)")
        print("frame end = \(frame)")
    }
    
    //MARK - Private methods    
    
    private func setUpView(){
        layer.addSublayer(shadowLayer)
        addSubview(imageView)
    }
    
}
