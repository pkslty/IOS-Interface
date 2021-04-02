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
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    var eyeButton: UIButton?
        
    @IBAction func loginPressed(_ sender: Any) {
        

    }
    
    @objc func hideKeyboerd() {
        loginScrollView.endEditing(true)
    }
    
    @objc func showHidePassword() {
        if password.isSecureTextEntry {
            password.isSecureTextEntry = false
            eyeButton?.tintColor = .systemBlue
        } else {
            password.isSecureTextEntry = true
            eyeButton?.tintColor = .green
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
 
        guard let username = username.text,
              let password = password.text,
              username == "dnk",
              password == "12345"
        else {
            return false
        }
            
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keyboardHideGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboerd))
        loginScrollView.addGestureRecognizer(keyboardHideGesture)
        
        //Add eye button to show password
        let eyeButtonRect = CGRect(x: 0, y: 0, width: password.frame.height, height: password.frame.height)
        eyeButton = UIButton(frame: eyeButtonRect)
        eyeButton?.tintColor = .green
        eyeButton?.setImage(UIImage(systemName: "eye"), for: .normal)
        password.rightView = eyeButton
        password.rightViewMode = UITextField.ViewMode.always
        //Add gesture recognizer for it
        
        
        
        let eyeTapGesture = UITapGestureRecognizer(target: self, action: #selector(showHidePassword))
        eyeButton?.addGestureRecognizer(eyeTapGesture)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    @objc func keyboardWasShown(notification: Notification) {
            
    // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as!   NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height - view.safeAreaInsets.bottom, right: 0.0)
            
    // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        loginScrollView.contentInset = contentInsets
        loginScrollView.scrollIndicatorInsets = contentInsets
    }
        
        //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        loginScrollView.contentInset = contentInsets
    }
}

