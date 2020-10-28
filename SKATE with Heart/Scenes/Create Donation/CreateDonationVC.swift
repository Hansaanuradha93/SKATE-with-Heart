import UIKit

class CreateDonationVC: UIViewController {
    
    // MARK: Properties
    fileprivate let viewModel = CreateDonationVM()
    
    fileprivate let fullNameTextField = SHTextField(padding: GlobalDimensions.textFieldPadding, placeholderText: Strings.yourName, radius: GlobalDimensions.radius)
    fileprivate let donationTextField = SHTextField(padding: GlobalDimensions.textFieldPadding, placeholderText: Strings.whatAreYouDonating, radius: GlobalDimensions.radius)
    fileprivate let pickupLocationTextField = SHTextField(padding: GlobalDimensions.textFieldPadding, placeholderText: Strings.pickupLocation, radius: GlobalDimensions.radius)
    fileprivate let saveDonationButton = SHButton(backgroundColor: UIColor.appColor(color: .lightGray), title: Strings.saveDonation, titleColor: .gray, radius: GlobalDimensions.radius, fontSize: GlobalDimensions.buttonTitleFontSize)
    
    fileprivate lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fullNameTextField, donationTextField, pickupLocationTextField, saveDonationButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = GlobalDimensions.paddingBetweenItems
        return stackView
    }()

    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addTargets()
        setupDonationViewModelObserver()
        setupNotifications()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - Objc Methods
fileprivate extension CreateDonationVC {
    
    @objc func handleTapDismiss() {
        view.endEditing(true)
    }
    
    
    @objc func handleTextChange(textField: UITextField) {
        viewModel.fullName = fullNameTextField.text
        viewModel.donation = donationTextField.text
        viewModel.pickupLocation = pickupLocationTextField.text
    }
    
    
    @objc func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.verticalStackView.transform = .identity
        })
    }
    
    
    @objc func handleKeyboardShow(notification: Notification) {
        self.verticalStackView.transform = CGAffineTransform(translationX: 0, y: -20)
    }
    
    
    @objc func handleDonation() {
        viewModel.saveDonationInfo { [weak self] status, message in
            guard let self = self else { return }
            if status {
                self.presentAlert(title: Strings.successful, message: message, buttonTitle: Strings.ok)
                self.clearData()
            } else {
                self.presentAlert(title: Strings.failed, message: message, buttonTitle: Strings.ok)
            }
        }
    }
}


// MARK: - Fileprivate Methods
fileprivate extension CreateDonationVC {
    
    func clearData() {
        fullNameTextField.text = ""
        donationTextField.text = ""
        pickupLocationTextField.text = ""
    }
    
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func setupDonationViewModelObserver() {
        viewModel.bindalbeIsFormValid.bind { [weak self] isFormValid in
            guard let self = self, let isFormValid = isFormValid else { return }
            if isFormValid {
                self.saveDonationButton.backgroundColor = UIColor.appColor(color: .darkPink)
                self.saveDonationButton.setTitleColor(.white, for: .normal)
            } else {
                self.saveDonationButton.backgroundColor = UIColor.appColor(color: .lightGray)
                self.saveDonationButton.setTitleColor(.gray, for: .disabled)
            }
            self.saveDonationButton.isEnabled = isFormValid
        }
        
        viewModel.bindableIsSaving.bind { [weak self] isSaving in
            guard let self = self, let isSaving = isSaving else { return }
            if isSaving {
                self.showPreloader()
            } else {
                self.hidePreloader()
            }
        }
    }
    
    
    func addTargets() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        fullNameTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        donationTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        pickupLocationTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        saveDonationButton.addTarget(self, action: #selector(handleDonation), for: .touchUpInside)
    }
    
    
    func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = Strings.createDonation
        view.backgroundColor = .white
        
        fullNameTextField.autocorrectionType = .no
        donationTextField.autocorrectionType = .no
        pickupLocationTextField.autocorrectionType = .no
        
        fullNameTextField.setRoundedBorder(borderColor: UIColor.appColor(color: .darkPink), borderWidth: GlobalDimensions.borderWidth, radius: GlobalDimensions.radius)
        donationTextField.setRoundedBorder(borderColor: UIColor.appColor(color: .darkPink), borderWidth: GlobalDimensions.borderWidth, radius: GlobalDimensions.radius)
        pickupLocationTextField.setRoundedBorder(borderColor: UIColor.appColor(color: .darkPink), borderWidth: GlobalDimensions.borderWidth, radius: GlobalDimensions.radius)

        saveDonationButton.heightAnchor.constraint(equalToConstant: GlobalDimensions.height).isActive = true
        saveDonationButton.isEnabled = false
        
        let padding: CGFloat = 24
        view.addSubview(verticalStackView)
        verticalStackView.centerHorizontallyInSuperView()
        verticalStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 40, left: padding, bottom: 0, right: padding))
    }
}
