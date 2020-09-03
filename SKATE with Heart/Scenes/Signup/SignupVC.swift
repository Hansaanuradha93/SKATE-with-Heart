import UIKit

class SignupVC: UIViewController {
    
    fileprivate let signupViewModel = SignUpViewModel()

    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let fullNameTextField = SHTextField(padding: 16, placeholderText: "Enter full name", radius: 25)
    fileprivate let emailTextField = SHTextField(padding: 16, placeholderText: "Enter email", radius: 25)
    fileprivate let passwordTextField = SHTextField(padding: 16, placeholderText: "Enter password", radius: 25)
    fileprivate let signupButton = SHButton(backgroundColor: UIColor.appColor(color: .lightGray), title: "Sign Up", titleColor: .gray, radius: 25, fontSize: 24)
    fileprivate let goToLoginButton = SHButton(backgroundColor: .clear, title: "Go to login", titleColor: .white, radius: 0, fontSize: 18)

    
    fileprivate lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fullNameTextField, emailTextField, passwordTextField, signupButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
        setupUI()
        addTargets()
        setupRegistrationViewModelObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    @objc fileprivate func handleTapDismiss() {
        view.endEditing(true)
    }
    
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        signupViewModel.fullName = fullNameTextField.text
        signupViewModel.email = emailTextField.text
        signupViewModel.password = passwordTextField.text
    }
    
    
    @objc fileprivate func handleSignUp() {
        handleTapDismiss()
        signupViewModel.performSignUp { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.presentAlert(title: "Signup Failed!", message: error.localizedDescription, buttonTitle: "OK")
                return
            }
            print("Yup, its working")
//            self.navigateToHome()
        }
    }
    
    
    fileprivate func setupRegistrationViewModelObserver() {
        signupViewModel.bindalbeIsFormValid.bind { [weak self] isFormValid in
            guard let self = self, let isFormValid = isFormValid else { return }
            if isFormValid {
                self.signupButton.backgroundColor = UIColor.appColor(color: .darkPink)
                self.signupButton.setTitleColor(.white, for: .normal)
            } else {
                self.signupButton.backgroundColor = UIColor.appColor(color: .lightGray)
                self.signupButton.setTitleColor(.gray, for: .disabled)
            }
            self.signupButton.isEnabled = isFormValid
        }
        
        signupViewModel.bindableIsRegistering.bind { [weak self] isRegistering in
            guard let self = self, let isRegistering = isRegistering else { return }
            if isRegistering {
                self.showPreloader()
            } else {
                self.hidePreloader()
            }
        }
    }
    
    
    fileprivate func addTargets() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        fullNameTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        signupButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
//        goToLoginButton.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
    }
    
    fileprivate func setupGradient() {
        gradientLayer.colors = [UIColor.appColor(color: .orange).cgColor, UIColor.appColor(color: .pink).cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    fileprivate func setupUI() {
        navigationController?.navigationBar.isHidden = true
        
        fullNameTextField.autocorrectionType = .no
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signupButton.isEnabled = false
        
        view.addSubview(verticalStackView)
        verticalStackView.centerInSuperview()
        verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        
        view.addSubview(goToLoginButton)
        goToLoginButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
}
