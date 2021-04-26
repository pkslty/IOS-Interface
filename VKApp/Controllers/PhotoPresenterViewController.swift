//
//  PhotoPresenterViewController.swift
//  VKApp
//
//  Created by Denis Kuzmin on 23.04.2021.
//

import UIKit

enum AnimationType {
    case foldFromRight
    case fold
    case rotate
}
enum AnimatorKind: CGFloat {
    case left = -1
    case right = 1
}

class PhotoPresenterViewController: UIViewController {

    let animationType: AnimationType = .rotate
    var animatorKind: AnimatorKind?
    let maxPanDistance: CGFloat = 420
    lazy var mainImageView = UIImageView()
    lazy var secondImageView = UIImageView()
    var propertyAnimator: UIViewPropertyAnimator?
    var lastX: CGFloat = 0.0
    
    var transformRight = CATransform3D()
    var transformLeft = CATransform3D()
    
    var images = [(image: UIImage, likes: Int, likers: Set<String>)]()
    var currentImage: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard images.count > 0 else { return }
        
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(panTrack))
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        view.addGestureRecognizer(panGR)
        view.addGestureRecognizer(tapGR)
        
        let y = navigationController!.navigationBar.frame.minY + navigationController!.navigationBar.frame.height
        let height = (tabBarController?.tabBar.frame.minY)! - y
        let rect = CGRect(x: 0, y: y, width: view.frame.width, height: height)
        navigationController?.navigationBar.isOpaque = false
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isOpaque = false
        tabBarController?.tabBar.isHidden = false
        mainImageView.frame = rect
        mainImageView.bounds = rect
        
        mainImageView.image = images[currentImage].image
        mainImageView.frame = rect
        mainImageView.bounds = rect
        mainImageView.contentMode = .scaleAspectFill
        view.addSubview(mainImageView)
        mainImageView.clipsToBounds = true
    }
    
    @objc func panTrack(sender: UIPanGestureRecognizer) {
        
        switch sender.state {
        case .began:
            //Алгоритм:
            //Если есть аниматор, его надо завершить, чтоб обработался его комплишн блок, и удалить
            if propertyAnimator != nil {
                if propertyAnimator!.state == .active {
                    propertyAnimator!.stopAnimation(false)
                    propertyAnimator!.finishAnimation(at: UIViewAnimatingPosition.end) //Тут кажется может
                    //быть ошибка, если аниматор откатывал анимацию, а мы его завершили
                }
                propertyAnimator = nil
            }
        case .cancelled:
            //Наверное поскольку состояние неопределенное, надо удалить аниматор и все subview и вернуться к
            //состоянию как после viewDidLoad
            break
        
        case .changed:
            //Алгоритм:
            //Движение в минус/плюс:
            //1. Делаем левый/правый аниматор, если аниматор отсутствует
            //2. Двигаем анимацию в соответствии с перемещением.
            //Движение нулевое: если аниматор ненулевой - завершаем его и удаляем
            switch sender.translation(in: self.view).x {
            case var x where x < 0 && lastX <= 0:
                lastX = x
                if propertyAnimator == nil {
                    makeLeftAnimator()
                    print("made left")
                }
                x = x > -maxPanDistance ? x : -maxPanDistance
                if currentImage == images.count - 1 {
                    x = x / 2
                }
                propertyAnimator?.fractionComplete = x / -maxPanDistance
            case var x where x > 0 && lastX >= 0:
                lastX = x
                if propertyAnimator == nil {
                    makeRightAnimator()
                    print("made right")
                }
                x = x < maxPanDistance ? x : maxPanDistance
                if currentImage == 0 {
                    x = x / 2
                }
                propertyAnimator?.fractionComplete = x / maxPanDistance
            default:
                lastX = 0
                if let propertyAnimator = propertyAnimator {
                    propertyAnimator.stopAnimation(false)
                    propertyAnimator.finishAnimation(at: UIViewAnimatingPosition.start)
                    self.propertyAnimator = nil
                    print("Animator deleted in chaged because translation = \(sender.translation(in: self.view)) lastX = \(lastX)")
                }
            }
        case .ended:
            //Алгоритм:
            //Если движение нулевое и аниматор ненулевой - завершаем его и обнуляем
            //Если аниматор больше половины - завершаем его
            //Если меньше половины: если скорость больше предельной - завершаем, иначе - откатываем
            let noReturnSpeed = maxPanDistance
            print("pan ended")
            guard let propertyAnimator = propertyAnimator else { break }
            let x = sender.translation(in: self.view).x
            let speed = sender.velocity(in: self.view).x
            switch x {
            case let x where x != 0:
                if (propertyAnimator.fractionComplete > 0.5  || //Если больше половины
                        abs(speed) > noReturnSpeed && speed * animatorKind!.rawValue > 0) && //Скорость больше предельной и соответствует аниматору
                    !(currentImage == 0 && x > 0) && //Если не первая картинка и движение вправо
                    !(currentImage == images.count - 1 && x < 0) //Если не последняя картинка и движение влево
                {
                    let direction = x < 0 ? 1 : -1
                    propertyAnimator.addCompletion { [self] _ in
                        currentImage += direction
                        swap(&mainImageView, &secondImageView)
                        secondImageView.removeFromSuperview()
                    }
                    propertyAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                } else {
                    propertyAnimator.isReversed = true
                    propertyAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                }
            case 0:
                    propertyAnimator.stopAnimation(false)
                    propertyAnimator.finishAnimation(at: UIViewAnimatingPosition.end)
            default:
                print("Whatever")
                
            }
        default:
            break
        }
    }

    
    func makeLeftAnimator() {
        animatorKind = .left
        for subview in view.subviews {
         if subview != mainImageView {
             subview.removeFromSuperview()
            }
        }
        secondImageView = UIImageView()
        secondImageView.frame = mainImageView.frame
        secondImageView.bounds = mainImageView.bounds
        secondImageView.contentMode = .scaleAspectFill
        secondImageView.clipsToBounds = true
        if currentImage <= images.count - 2 {
            secondImageView.image = images[currentImage + 1].image
        }
        let keyframes = makeKeyframes()
        secondImageView.layer.transform = keyframes[0].5
        view.addSubview(secondImageView)
        
        propertyAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut)
        propertyAnimator!.addAnimations {
            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .calculationModeLinear) {
                UIView.addKeyframe(withRelativeStartTime: keyframes[0].0,
                                   relativeDuration: keyframes[0].1) {
                    self.mainImageView.layer.transform = keyframes[0].2
                }
                UIView.addKeyframe(withRelativeStartTime: keyframes[0].3,
                                   relativeDuration: keyframes[0].4) {
                    self.secondImageView.transform = .identity
                }
            }
        }

    }
    
    func makeRightAnimator() {
        animatorKind = .right
        for subview in view.subviews {
            if subview != mainImageView {
                subview.removeFromSuperview() }
        }
        //print(view.subviews)
        secondImageView = UIImageView()
        secondImageView.frame = mainImageView.frame
        secondImageView.bounds = mainImageView.bounds
        secondImageView.contentMode = .scaleAspectFill
        secondImageView.clipsToBounds = true
        //Если это первая картинка, то secondImageView будет пустой
        //Нельзя допусть завершение аниматора с currentImage == 0
        if currentImage > 0 {
            secondImageView.image = images[currentImage-1].image
        }
        let keyframes = makeKeyframes()
        secondImageView.layer.transform = keyframes[1].5
        view.addSubview(secondImageView)
        
        propertyAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut)
        propertyAnimator!.addAnimations {
            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .calculationModeLinear) {
                UIView.addKeyframe(withRelativeStartTime: keyframes[1].0,
                                   relativeDuration: keyframes[1].1) {
                    self.mainImageView.layer.transform = keyframes[1].2
                }
                UIView.addKeyframe(withRelativeStartTime: keyframes[1].3,
                                   relativeDuration: keyframes[1].4) {
                    self.secondImageView.transform = .identity
                }
            }
        }
    }
    
    @objc func tapAction() {
        if let navigationController = navigationController,
           navigationController.navigationBar.isHidden {
            UIView.animate(withDuration: 0.2, animations: {
                [self] in
                    navigationController.navigationBar.isOpaque = false
                    tabBarController?.tabBar.isOpaque = false
                    let y = navigationController.navigationBar.frame.minY + navigationController.navigationBar.frame.height
                    let height = (tabBarController?.tabBar.frame.minY)! - y
                    let rect = CGRect(x: 0, y: y, width: view.frame.width, height: height)
                    mainImageView.frame = rect
            }, completion: { [self] _ in
                navigationController.navigationBar.isHidden = false
                tabBarController?.tabBar.isHidden = false
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                [self] in
                navigationController?.navigationBar.isOpaque = true
                tabBarController?.tabBar.isOpaque = true
                mainImageView.frame = view.frame
            }, completion: { [self] _ in
                navigationController?.navigationBar.isHidden = true
                tabBarController?.tabBar.isHidden = true
            })
            
        }
    }
    
    private func makeKeyframes() ->
    [(Double, Double, CATransform3D, Double, Double, CATransform3D)] {
        
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 900
        
        switch animationType {
        case let type where type == .fold || type == .foldFromRight:
            
            let translationZ = CATransform3DTranslate(transform, 0, 0, -200)
            let translationRight = CATransform3DTranslate(transform, 420, 0, 0)
            let translationLeft = CATransform3DTranslate(transform, -420, 0, 0)
            
            if type == .fold {
                return [(0.0, 0.5, translationZ, 0.5, 0.5, translationRight),
                    (0.0, 0.5, translationZ, 0.5, 0.5, translationLeft)]
            } else {
                return [(0.0, 0.5, translationZ, 0.5, 0.5, translationRight),
                    (0.0, 0.5, translationRight, 0.5, 0.5, translationZ)]
            }
            
            
            
        default:

            let rotationRight = CATransform3DRotate(transform, -.pi/1.85, 0, 1, 0)
            let translationRight = CATransform3DTranslate(transform, 400, 0, -400)
            transformRight = CATransform3DConcat(rotationRight, translationRight)
            
            let rotationLeft = CATransform3DRotate(transform, .pi/1.85, 0, 1, 0)
            let translationLeft = CATransform3DTranslate(transform, -400, 0, -400)
            transformLeft = CATransform3DConcat(rotationLeft, translationLeft)
            
            return [(0.0, 1.0, transformLeft, 0.0, 1.0, transformRight),
                    (0.0, 1.0, transformRight, 0.0, 1.0, transformLeft)]
            
            
        }
    }
    
}

