//
//  PhotoPresenterViewController.swift
//  VKApp
//
//  Created by Denis Kuzmin on 23.04.2021.
//

import UIKit


class PhotoPresenterViewController: UIViewController {

    enum AnimationType {
        case foldFromRight
        case fold
        case rotate
    }
    enum AnimatorKind: CGFloat {
        case left = -1
        case right = 1
    }
    
    let animationType: AnimationType = .rotate
    var animatorKind: AnimatorKind?
    let maxPanDistance: CGFloat = 420
    lazy var mainImageView = UIImageView()
    lazy var secondImageView = UIImageView()
    var propertyAnimator: UIViewPropertyAnimator?
    var lastX: CGFloat = 0.0
    var centerX:CGFloat = 0.0
    var centerY: CGFloat = 0.0
    
    var transformRight = CATransform3D()
    var transformLeft = CATransform3D()
    
    var images = [(image: UIImage, likes: Int, likers: Set<String>)]()
    var currentImage: Int = 0
    var rect = CGRect.zero
    var targetFrame = CGRect.zero
    
    weak var interactiveTransition: PercentDrivenInteractiveTransition?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard images.count > 0 else { return }
        
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(panTrack))
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        view.addGestureRecognizer(panGR)
        view.addGestureRecognizer(tapGR)
        let y = navigationController!.navigationBar.frame.minY + navigationController!.navigationBar.frame.height
        //let y:CGFloat = 100.0
        //let height: CGFloat = 800.0
        let height = (tabBarController?.tabBar.frame.minY)! - y
        rect = CGRect(x: 0, y: y, width: view.frame.width, height: height)
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
        view.backgroundColor = .clear
        centerX = mainImageView.center.x
        centerY = mainImageView.center.y
        view.addSubview(mainImageView)
        mainImageView.clipsToBounds = true
        if let navigationController = navigationController as? NavigationController {
            //navigationController.recognizer.delegate = self
            interactiveTransition = navigationController.interactiveTransition
        }
    }
    
    @objc func panTrack(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        
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
            print("currentImage in began = \(currentImage)")
            //Если перемещение началось по оси y, а по x нулевое - это смахивание и надо запустить pop
            if translation.y > 0 && translation.x == 0 {
                
                interactiveTransition?.isStarted = true
                navigationController?.popViewController(animated: true)
                if let destination = navigationController?.topViewController as? FriendPhotosViewController {
                    let index = IndexPath(row: currentImage, section: 0)
                    //Move cell in collectionview into center
                    destination.collectionView.scrollToItem(at: index,
                                                            at: UICollectionView.ScrollPosition.centeredVertically, animated: false)
                    targetFrame = destination.collectionView.layoutAttributesForItem(at: index)?.frame ?? CGRect.zero
                    let contentOffset = destination.collectionView.contentOffset
                    print("targetframe: \(targetFrame) contentOffset: \(contentOffset)")
                    targetFrame.origin = CGPoint(x: targetFrame.minX, y: targetFrame.minY - contentOffset.y)
                    //targetFrame.size = CGSize(width: 400, height: 400)
                }
                print("target frame in began = \(targetFrame)")
            }
        case .cancelled:
            //Наверное поскольку состояние неопределенное, надо удалить аниматор и все subview и вернуться к
            //состоянию как после viewDidLoad
            if let interactiveTransition = interactiveTransition,
               interactiveTransition.isStarted {
                interactiveTransition.isStarted = false
                interactiveTransition.cancel()
            }
            break
        
        case .changed:
            //Алгоритм:
            //Движение в минус/плюс:
            //1. Делаем левый/правый аниматор, если аниматор отсутствует
            //2. Двигаем анимацию в соответствии с перемещением.
            //Движение нулевое: если аниматор ненулевой - завершаем его и удаляем
            if let interactiveTransition = interactiveTransition,
               interactiveTransition.isStarted {
                let progress = max(0, translation.y / view.frame.height)
                //print("trx: \(translation.x) try: \(translation.y) pr: \(progress) center: \(mainImageView.center) velosity: \(velocity)")
                mainImageView.center.x = centerX + translation.x
                mainImageView.center.y = centerY + translation.y
                let transform = CGAffineTransform(scaleX: 1 - progress / 2, y: 1 - progress / 2)
                mainImageView.transform = transform
                interactiveTransition.update(progress)
                interactiveTransition.shouldFinish = progress > 0 && velocity.y >= 0
                
            } else {
                switch translation.x {
                case var x where x < 0 && lastX <= 0:
                    lastX = x
                    if propertyAnimator == nil {
                        makeLeftAnimator()
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
                    }
                }
                
            }
        case .ended:
            //Алгоритм:
            //Если движение нулевое и аниматор ненулевой - завершаем его и обнуляем
            //Если аниматор больше половины - завершаем его
            //Если меньше половины: если скорость больше предельной - завершаем, иначе - откатываем
            if let interactiveTransition = interactiveTransition,
               interactiveTransition.isStarted {
                interactiveTransition.isStarted = false
                interactiveTransition.shouldFinish ? {
                    interactiveTransition.pause()
                    UIView.animate(withDuration: 0.2, animations: { [self] in
                        mainImageView.center = CGPoint(x: targetFrame.midX, y: targetFrame.midY)
                        mainImageView.frame = targetFrame
                    }, completion: { _ in interactiveTransition.finish() }) }():
                    UIView.animate(withDuration: 0.2, animations: { [self] in
                        mainImageView.center = CGPoint(x: centerX, y: centerY)
                        mainImageView.frame = rect
                    }, completion: { _ in interactiveTransition.cancel()
                        print("cancelled")
                    })
                
            } else {
                let noReturnSpeed = maxPanDistance
                guard let propertyAnimator = propertyAnimator else { break }
                let x = translation.x
                let speed = velocity.x
                switch x {
                case let x where x != 0:
                    if (propertyAnimator.fractionComplete > 0.5  || //Если больше половины
                            abs(speed) > noReturnSpeed && speed * animatorKind!.rawValue > 0) && //Скорость больше предельной и соответствует направлению аниматора
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
        //navigationController?.popViewController(animated: false)
        if let navigationController = navigationController,
           navigationController.navigationBar.isHidden {
            let y = navigationController.navigationBar.frame.minY + navigationController.navigationBar.frame.height
            let height = (tabBarController?.tabBar.frame.minY)! - y
            rect = CGRect(x: 0, y: y, width: view.frame.width, height: height)
            UIView.animate(withDuration: 0.2, animations: {
                [self] in
                    navigationController.navigationBar.isOpaque = false
                    tabBarController?.tabBar.isOpaque = false
                    mainImageView.frame = rect
            }, completion: { [self] _ in
                navigationController.navigationBar.isHidden = false
                tabBarController?.tabBar.isHidden = false
            })
        } else {
            rect = view.frame
            UIView.animate(withDuration: 0.2, animations: {
                [self] in
                navigationController?.navigationBar.isOpaque = true
                tabBarController?.tabBar.isOpaque = true
                mainImageView.frame = rect
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

extension PhotoPresenterViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
