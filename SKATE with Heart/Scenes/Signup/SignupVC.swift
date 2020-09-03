import UIKit

class SignupVC: UIViewController {

    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let fullNameTextField = SHTextField(padding: 16, placeholderText: "Enter full name", radius: 25)
    fileprivate let emailTextField = SHTextField(padding: 16, placeholderText: "Enter email", radius: 25)
    fileprivate let passwordTextField = SHTextField(padding: 16, placeholderText: "Enter password", radius: 25)
    fileprivate let signupButton = SHButton(backgroundColor: UIColor.appColor(color: .lightGray), title: "Sign Up", titleColor: .gray, radius: 25, fontSize: 24)
    
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    @objc fileprivate func handleTap() {
        view.endEditing(true)
    }
    
    fileprivate func setupGradient() {
        gradientLayer.colors = [UIColor.appColor(color: .orange).cgColor, UIColor.appColor(color: .pink).cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    fileprivate func setupUI() {
        navigationController?.navigationBar.isHidden = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signupButton.isEnabled = false
        
        view.addSubview(verticalStackView)
        verticalStackView.centerInSuperview()
        verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
    }
}
