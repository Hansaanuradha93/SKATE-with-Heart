import UIKit

class LoginVC: UIViewController {

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
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    
    fileprivate func setupGradient() {
        gradientLayer.colors = [UIColor.appColor(color: .orange).cgColor, UIColor.appColor(color: .pink).cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.insertSublayer(gradientLayer, at: 0)
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
