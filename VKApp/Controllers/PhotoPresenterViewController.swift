//
//  PhotoPresenterViewController.swift
//  VKApp
//
//  Created by Denis Kuzmin on 23.04.2021.
//

import UIKit

class PhotoPresenterViewController: UIViewController {

    lazy var firstImageView = UIImageView()
    //lazy var secondImageView = UIImageView()
    
    var transformRight = CATransform3D()
    var transformLeft = CATransform3D()
    
    var images = [UIImage(named: "man01"), UIImage(named: "man02"), UIImage(named: "man03"), UIImage(named: "man04"), UIImage(named: "man05"), UIImage(named: "woman01"), UIImage(named: "woman02"), UIImage(named: "woman03"), UIImage(named: "group01"), UIImage(named: "group02"), UIImage(named: "group03")]
    var currentImage: Int = 0
    var onScreenView = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(panTrack))
        let swipeLeftGR = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftTrack))
        let swipeRightGR = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightTrack))
        swipeLeftGR.direction = .left
        swipeRightGR.direction = .right
        //panGestureRecognizer.delegate = self
        //view.addGestureRecognizer(panGestureRecognizer)
        view.addGestureRecognizer(swipeLeftGR)
        view.addGestureRecognizer(swipeRightGR)
        
        var rect = CGRect(x: 50,y: 50,width: view.frame.width-100,height: view.frame.height-100)
        rect = view.bounds
        firstImageView.frame = rect
        
        firstImageView.bounds = rect
        
        guard images.count > 0 else { return }
        //views[0] = firstImageView
        firstImageView.image = images[0]
        //secondImageView.image = images[1]
        firstImageView.frame = rect
        firstImageView.bounds = rect
        firstImageView.contentMode = .scaleAspectFill
        //views[1] = secondImageView
        //secondImageView.frame = rect
        //secondImageView.bounds = rect
        //secondImageView.contentMode = .scaleAspectFill
        //view.addSubview(secondImageView)
        view.addSubview(firstImageView)
        //print(imageView.frame, imageView.bounds, secondImage.frame, secondImage.bounds, rect)
        firstImageView.clipsToBounds = true
        //secondImageView.clipsToBounds = true

        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 900
        let rotation = CATransform3DRotate(transform, -.pi/1.85, 0, 1, 0)
        let rotation2 = CATransform3DRotate(transform, .pi/1.85, 0, 1, 0)
        print(rotation)
        
        let translation = CATransform3DTranslate(transform, 400, 0, -400)
        let translation2 = CATransform3DTranslate(transform, -400, 0, -400)
        transformLeft = CATransform3DConcat(rotation2, translation2)
       // let scale = CATransform3DMakeScale(1, 0.7, 1)
        transformRight = CATransform3DConcat(rotation, translation)
        //secondImageView.layer.transform = transformRight
        print(firstImageView.transform)
        //print(secondImageView.transform)
        
        
    }
    
    @objc func panTrack(sender: UIPanGestureRecognizer) {
        
        switch sender.state {
        case .began:
            break
        case .cancelled:
            break
        case .changed:
            print("translation: \(sender.translation(in: self.view))")
            print("velosity: \(sender.velocity(in: self.view))")
        case .ended:
            break
        default:
            break
        }
    }
    
    @objc func swipeRightTrack(sender: UISwipeGestureRecognizer) {
        
        guard currentImage > 0 else { return }
        
        
        let secondImageView = UIImageView()
        secondImageView.frame = firstImageView.frame
        secondImageView.bounds = firstImageView.bounds
        secondImageView.contentMode = .scaleAspectFill
        secondImageView.clipsToBounds = true
        secondImageView.image = images[currentImage-1]
        secondImageView.layer.transform = transformLeft
        view.addSubview(secondImageView)
        
        //secondImageView.layer.transform = rotatetranslate2
        UIView.animate(withDuration: 0.5, delay: 0) { [self] in
            firstImageView.layer.transform = transformRight
            secondImageView.transform = .identity
        } /*completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0) { [self] in
                firstImageView.transform = .identity
                secondImageView.layer.transform = rotatetranslate2
                
            }
        }*/
        currentImage -= 1
        firstImageView = secondImageView
        
        //sender.direction = [.right, .left]
        //print("swipe state: \(sender.state)")
    }
    
    @objc func swipeLeftTrack(sender: UISwipeGestureRecognizer) {
        
        guard currentImage <= images.count - 2 else { return }
        let secondImageView = UIImageView()
        secondImageView.frame = firstImageView.frame
        secondImageView.bounds = firstImageView.bounds
        secondImageView.contentMode = .scaleAspectFill
        secondImageView.clipsToBounds = true
        secondImageView.image = images[currentImage + 1]
        secondImageView.layer.transform = transformRight
        view.addSubview(secondImageView)
        
        //secondImageView.layer.transform = rotatetranslate2
        UIView.animate(withDuration: 0.5, delay: 0) { [self] in
            firstImageView.layer.transform = transformLeft
            secondImageView.transform = .identity
        } /*completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0) { [self] in
                firstImageView.transform = .identity
                secondImageView.layer.transform = rotatetranslate2
                
            }
        }*/
        firstImageView = secondImageView
        currentImage += 1
        
        //sender.direction = [.right, .left]
        //print("swipe state: \(sender.state)")
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PhotoPresenterViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print("Here")
        if let _ = gestureRecognizer as? UIPanGestureRecognizer {
            if let _ = otherGestureRecognizer as? UISwipeGestureRecognizer {
                return true
            }
        }
        return false
    }
    
}
