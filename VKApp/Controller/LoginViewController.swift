//
//  ViewController.swift
//  VKApp
//
//  Created by Denis Kuzmin on 31.03.2021.
//

import UIKit
import CryptoKit

class LoginViewController: UIViewController {

    // MARK: - @IBOutlets
    
    @IBOutlet weak var loginScrollView: UIScrollView!
    @IBOutlet weak var loginContentView: UIView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    // MARK: - Properties
    
    var eyeButton: UIButton?
    
    // MARK: - Methods
        
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
 
        guard let username = username.text,
              let password = password.text,
              username == "dnk",
              MD5(string: password) == "827ccb0eea8a706c4c34a16891f84e7b"
        else {
            showLoginError()
            return false
        }
        self.username.text = ""
        self.password.text = ""
        hideKeyboard()
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keyboardHideGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        loginScrollView.addGestureRecognizer(keyboardHideGesture)
        
        //Добавляем кнопку с глазом
        let eyeButtonRect = CGRect(x: 0, y: 0, width: password.frame.height, height: password.frame.height)
        eyeButton = UIButton(frame: eyeButtonRect)
        eyeButton?.imageView?.tintColor = .gray
        eyeButton?.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        password.rightView = eyeButton
        password.rightViewMode = UITextField.ViewMode.always
        
        //Добавлляем gesture recognizer для глаза
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
        
    
    // MARK: - Private methods
    
    //Увеличиваем размер ScrollView при появлении клавиатуры
    @objc private func keyboardWasShown(notification: Notification) {
        
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as!   NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height - view.safeAreaInsets.bottom, right: 0.0)
        
        loginScrollView.contentInset = contentInsets
        loginScrollView.scrollIndicatorInsets = contentInsets
    }
    
    
    //Уменьшаем обратно ScrollView при исчезновении клавиатуры
    @objc private func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        loginScrollView.contentInset = contentInsets
    }
    
    
    //Скрытие кдавиатуры
    @objc private func hideKeyboard() {
        loginScrollView.endEditing(true)
    }
    
    
    //Переключение вида поля ввода пароля с видимого на скрытый
    @objc private func showHidePassword() {
        if password.isSecureTextEntry {
            password.isSecureTextEntry = false
            eyeButton?.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            password.isSecureTextEntry = true
            eyeButton?.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
    
    
    //Отображение алерта с ошибкой при неправильном логине или пароле
    private func showLoginError() {
        
        let alertTitle = NSLocalizedString("Error", comment: "Error")
        let alertMessage = NSLocalizedString("Wrong username or password", comment: "Wrong username or password")
        let alertAction = NSLocalizedString("OK", comment: "Default action")
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: alertAction, style: .default))
        present(alert, animated: true)
    }
    
    private func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}

