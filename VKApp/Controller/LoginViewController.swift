//
//  ViewController.swift
//  VKApp
//
//  Created by Denis Kuzmin on 31.03.2021.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginScrollView: UIScrollView!
    @IBOutlet weak var loginContentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 1000.0, right: 0.0)
        //
        //loginScrollView.contentInset = contentInsets
        //loginScrollView.scrollIndicatorInsets = contentInsets
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    
    @objc func keyboardWasShown(notification: Notification) {
            
    // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as!   NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height - view.safeAreaInsets.bottom, right: 0.0)
            
    // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.loginScrollView.contentInset = contentInsets
        loginScrollView.scrollIndicatorInsets = contentInsets
    }
        
        //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        loginScrollView.contentInset = contentInsets
    }
}

