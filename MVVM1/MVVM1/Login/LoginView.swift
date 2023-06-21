//
//  ViewController.swift
//  MVVM1
//
//  Created by user240251 on 6/21/23.
//

import UIKit
import Combine


class LoginView: UIViewController {
    
    var cancellables = Set<AnyCancellable>()
    
    private let loginViewModel = LoginViewModel(apiClient: APIClient())
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add Email"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Login"
        configuration.subtitle = "¡BIENVENIDO MVVM!"
        configuration.image = UIImage(systemName: "play.circle.fill")
        configuration.imagePadding = 8
        
        let button = UIButton(type: .system, primaryAction: UIAction(handler: { [weak self] action in
            self?.startLogin()
               }))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = configuration
        
        return button
    }()

    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.textColor = .red
        label.font = .systemFont(ofSize: 20,
                                 weight: .regular,
                                 width: .condensed)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        createBindingViewWithViewModel()
        
        [emailTextField,
         passwordTextField,
         loginButton, errorLabel
        ].forEach(view.addSubview)
        
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -20),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            passwordTextField.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -20),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    errorLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20)
            
        ])
    }
    
    private func startLogin() {
        print("Start login")
        loginViewModel.userLogin(withEmail: emailTextField.text?.lowercased() ?? "",
                                 withPassword: passwordTextField.text?.lowercased() ?? "")
    }
    
    private func createBindingViewWithViewModel() {
        emailTextField.textPublisher
            .assign(to: \LoginViewModel.email, on: loginViewModel)
            .store(in: &cancellables)
            
        passwordTextField.textPublisher
            .assign(to: \LoginViewModel.password, on: loginViewModel)
            .store(in: &cancellables)
        
        
        loginViewModel.$isEnabled
                .assign(to: \.isEnabled, on: loginButton)
                .store(in: &cancellables)
        
        loginViewModel.$userModel.sink { [weak self] _ in
              print("Success, navigate to home view controller")
              // Esta lógica la podría realizar el ViewModel
              let homeView = HomeView()
              self?.present(homeView, animated: true)
          }.store(in: &cancellables)
        
        loginViewModel.$showLoading
                .assign(to: \.configuration!.showsActivityIndicator, on: loginButton)
                .store(in: &cancellables)
     
        loginViewModel.$errorMessage
                .assign(to: \UILabel.text!, on: errorLabel)
                .store(in: &cancellables)
        
        
        
        
    }
}

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        return NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { notification in
                return (notification.object as? UITextField)?.text ?? ""
            }
            .eraseToAnyPublisher()
    }
}
