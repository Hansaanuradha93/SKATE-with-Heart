import UIKit

class SignupVC: UIViewController {
    
    // MARK: Properties
    fileprivate let viewModel = SignUpVM()

    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let fullNameTextField = SHTextField(padding: GlobalDimensions.textFieldPadding, placeholderText: Strings.enterFullName, radius: GlobalDimensions.radius)
    fileprivate let emailTextField = SHTextField(padding: GlobalDimensions.textFieldPadding, placeholderText: Strings.enterEmail, radius: GlobalDimensions.radius)
    fileprivate let passwordTextField = SHTextField(padding: GlobalDimensions.textFieldPadding, placeholderText: Strings.enterPassword, radius: GlobalDimensions.radius)
    fileprivate let signupButton = SHButton(backgroundColor: UIColor.appColor(color: .lightGray), title: Strings.signup, titleColor: .gray, radius: GlobalDimensions.radius, fontSize: GlobalDimensions.buttonTitleFontSize)
    fileprivate let goToLoginButton = SHButton(backgroundColor: .clear, title: Strings.goToLogin, titleColor: .white, radius: 0, fontSize: 18)

    fileprivate lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fullNameTextField, emailTextField, passwordTextField, signupButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = GlobalDimensions.paddingBetweenItems
        return stackView
    }()

    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
        setupUI()
        addTargets()
        setupRegistrationViewModelObserver()
        setupNotifications()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - Objc Methods
fileprivate extension SignupVC {
     
    @objc func handleTapDismiss() {
        view.endEditing(true)
    }
    
    
    @objc func handleTextChange(textField: UITextField) {
        viewModel.fullName = fullNameTextField.text
        viewModel.email = emailTextField.text
        viewModel.password = passwordTextField.text
    }
    
    
    @objc func handleSignUp() {
        handleTapDismiss()
        viewModel.performSignUp { [weak self] status, message in
            guard let self = self else { return }
            if status {
                self.navigateToHome()
            } else {
                self.presentAlert(title: Strings.failed, message: message, buttonTitle: Strings.ok)
            }
        }
    }
    
    
    @objc func handleGoToLogin() {
        self.dismiss(animated: true)
    }
    
    
    @objc func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    
    @objc func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - verticalStackView.frame.origin.y - verticalStackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -(difference + 10))
    }
}

// MARK: - Fileprivate Methods
fileprivate extension SignupVC {
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
        
    func navigateToHome() {
        let controller = SHTabBar()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }
    
    
    func setupRegistrationViewModelObserver() {
        viewModel.bindalbeIsFormValid.bind { [weak self] isFormValid in
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
        
        viewModel.bindableIsRegistering.bind { [weak self] isRegistering in
            guard let self = self, let isRegistering = isRegistering else { return }
            if isRegistering {
                self.showPreloader()
            } else {
                self.hidePreloader()
            }
        }
    }
        
        
    func addTargets() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        fullNameTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        signupButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        goToLoginButton.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
    }
    
    
    func setupGradient() {
        gradientLayer.colors = [UIColor.appColor(color: .orange).cgColor, UIColor.appColor(color: .pink).cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    func setupUI() {
        navigationController?.navigationBar.isHidden = true
        
        fullNameTextField.autocorrectionType = .no
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        signupButton.heightAnchor.constraint(equalToConstant: GlobalDimensions.height).isActive = true
        signupButton.isEnabled = false
        
        let padding: CGFloat = 24
        view.addSubview(verticalStackView)
        verticalStackView.centerInSuperview()
        verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: padding, bottom: 0, right: padding))
        
        view.addSubview(goToLoginButton)
        goToLoginButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
}
