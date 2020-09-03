import UIKit

class LoginVC: UIViewController {

    fileprivate let loginViewModel = LoginVM()

    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let emailTextField = SHTextField(padding: 16, placeholderText: "Enter email", radius: 25)
    fileprivate let passwordTextField = SHTextField(padding: 16, placeholderText: "Enter password", radius: 25)
    fileprivate let loginButton = SHButton(backgroundColor: UIColor.appColor(color: .lightGray), title: "Login", titleColor: .gray, radius: 25, fontSize: 24)
    fileprivate let goToSignupButton = SHButton(backgroundColor: .clear, title: "Go to Signup", titleColor: .white, radius: 0, fontSize: 18)
    
    fileprivate lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
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
        setupLoginViewModelObserver()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    
    @objc fileprivate func handleTapDismiss() {
        view.endEditing(true)
    }
    
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        loginViewModel.email = emailTextField.text
        loginViewModel.password = passwordTextField.text
    }
    
    
    fileprivate func setupLoginViewModelObserver() {
        loginViewModel.bindalbeIsFormValid.bind { [weak self] isFormValid in
            guard let self = self, let isFormValid = isFormValid else { return }
            if isFormValid {
                self.loginButton.backgroundColor = UIColor.appColor(color: .darkPink)
                self.loginButton.setTitleColor(.white, for: .normal)
            } else {
                self.loginButton.backgroundColor = UIColor.appColor(color: .lightGray)
                self.loginButton.setTitleColor(.gray, for: .disabled)
            }
            self.loginButton.isEnabled = isFormValid
        }
        
        loginViewModel.bindableIsRegistering.bind { [weak self] isRegistering in
            guard let self = self, let isRegistering = isRegistering else { return }
            if isRegistering {
                self.showPreloader()
            } else {
                self.hidePreloader()
            }
        }
    }
    
    
    fileprivate func setupGradient() {
        gradientLayer.colors = [UIColor.appColor(color: .orange).cgColor, UIColor.appColor(color: .pink).cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    fileprivate func addTargets() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        emailTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
//        loginButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
//        goToSignupButton.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
    }
    
    
    fileprivate func setupUI() {
        navigationController?.navigationBar.isHidden = true
        
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.isEnabled = false
        
        view.addSubview(verticalStackView)
        verticalStackView.centerInSuperview()
        verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0,left: 50, bottom: 0, right: 50))
        
        view.addSubview(goToSignupButton)
        goToSignupButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing:view.trailingAnchor)
    }
}
