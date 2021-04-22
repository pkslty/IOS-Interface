//
//  LoadingIndicator.swift
//  VKApp
//
//  Created by Denis Kuzmin on 22.04.2021.
//

import UIKit

@IBDesignable class LoadingIndicator: UIView {

    @IBInspectable var color: UIColor = .systemBlue
    @IBInspectable var dotSize: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    

        
    
    private func setupView() {
        var layers = [CAShapeLayer]()
        let width = bounds.width
        let height = bounds.height
        //let diameter = height / 10
        
        for i in 1...3 {
            let shapelayer = CAShapeLayer()
            shapelayer.path = UIBezierPath(ovalIn: CGRect(x: 0.25 * CGFloat(i) * width, y: 0.5 * height, width: dotSize, height: dotSize)).cgPath
            shapelayer.fillColor = color.cgColor
            layer.addSublayer(shapelayer)
            layers.append(shapelayer)
        }
        
        
        
        
        CATransaction.begin()
        var animations = [CABasicAnimation]()
        //let bt = 0
        //for i in 0 ... 2 {
            let animation1 = CABasicAnimation(keyPath: "opacity")
            animation1.fromValue = 1
            animation1.toValue = 0
            //if i > 0 {
            //    animation1.beginTime = animations[i - 1].beginTime + Double(i) * 0.5
            //}
            animation1.duration = 1
            animations.append(animation1)
            let animation2 = CABasicAnimation(keyPath: "opacity")
            animation2.fromValue = 0
            animation2.toValue = 1
            animation2.duration = 1
            animation2.beginTime = animation1.beginTime + 1
            animations.append(animation2)
        
        let animation3 = CABasicAnimation(keyPath: "opacity")
        animation3.fromValue = 0.5
        animation3.toValue = 1
        animation3.duration = 0.5
        //animation3.beginTime = animation1.beginTime + 0.5
        animations.append(animation3)
        
        let animation4 = CABasicAnimation(keyPath: "opacity")
        animation4.fromValue = 1
        animation4.toValue = 0
        animation4.duration = 1
        animation4.beginTime = animation1.beginTime + 0.5
        animations.append(animation4)
        
        let animation5 = CABasicAnimation(keyPath: "opacity")
        animation5.fromValue = 0
        animation5.toValue = 0.5
        animation5.duration = 0.5
        animation5.beginTime = animation4.beginTime + 1
        animations.append(animation5)
        
        let animation6 = CABasicAnimation(keyPath: "opacity")
        animation6.fromValue = 0
        animation6.toValue = 1
        animation6.duration = 1
        //animation6.beginTime = animation1.beginTime + 1
        animations.append(animation6)
        
        let animation7 = CABasicAnimation(keyPath: "opacity")
        animation7.fromValue = 1
        animation7.toValue = 0
        animation7.duration = 1
        animation7.beginTime = animation1.beginTime + 1
        animations.append(animation7)
        
       // }
        
        for anim in animations {
            print(anim.beginTime)
        }
        
        let group = CAAnimationGroup()
        group.animations = [animations[0], animations[1]]
        group.duration = 2
        group.repeatCount = .infinity
        layer.sublayers![0].add(group, forKey: nil)
        
        let group1 = CAAnimationGroup()
        group1.animations = [animations[2], animations[3], animations[4]]
        group1.duration = 2
        group1.repeatCount = .infinity
        layer.sublayers![1].add(group1, forKey: nil)
        
        let group2 = CAAnimationGroup()
        group2.animations = [animations[5], animations[6]]
        group2.duration = 2
        group2.repeatCount = .infinity
        layer.sublayers![2].add(group2, forKey: nil)
        
        //layers[1].add(animation2, forKey: nil)
        CATransaction.commit()
    }
}
