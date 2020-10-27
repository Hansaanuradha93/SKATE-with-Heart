import UIKit

class CreateDonationVC: UIViewController {
    
    // MARK: Properties
    fileprivate let createDonationViewModel = CreateDonationVM()
    
    fileprivate let fullNameTextField = SHTextField(padding: 16, placeholderText: Strings.yourName, radius: 25)
    fileprivate let donationTextField = SHTextField(padding: 16, placeholderText: Strings.whatAreYouDonating, radius: 25)
    fileprivate let pickupLocationTextField = SHTextField(padding: 16, placeholderText: Strings.pickupLocation, radius: 25)
    fileprivate let saveDonationButton = SHButton(backgroundColor: UIColor.appColor(color: .lightGray), title: Strings.saveDonation, titleColor: .gray, radius: 25, fontSize: 24)
    
    fileprivate lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fullNameTextField, donationTextField, pickupLocationTextField, saveDonationButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
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
extension CreateDonationVC {
    
    @objc fileprivate func handleTapDismiss() {
        view.endEditing(true)
    }
    
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        createDonationViewModel.fullName = fullNameTextField.text
        createDonationViewModel.donation = donationTextField.text
        createDonationViewModel.pickupLocation = pickupLocationTextField.text
    }
    
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.verticalStackView.transform = .identity
        })
    }
    
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        self.verticalStackView.transform = CGAffineTransform(translationX: 0, y: -20)
    }
    
    
    @objc fileprivate func handleDonation() {
        createDonationViewModel.saveDonationInfo { [weak self] status, message in
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


// MARK: - Methods
extension CreateDonationVC {
    
    fileprivate func clearData() {
        fullNameTextField.text = ""
        donationTextField.text = ""
        pickupLocationTextField.text = ""
    }
    
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    fileprivate func setupDonationViewModelObserver() {
        createDonationViewModel.bindalbeIsFormValid.bind { [weak self] isFormValid in
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
        
        createDonationViewModel.bindableIsSaving.bind { [weak self] isSaving in
            guard let self = self, let isSaving = isSaving else { return }
            if isSaving {
                self.showPreloader()
            } else {
                self.hidePreloader()
            }
        }
    }
    
    
    fileprivate func addTargets() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        fullNameTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        donationTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        pickupLocationTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        saveDonationButton.addTarget(self, action: #selector(handleDonation), for: .touchUpInside)
    }
    
    
    fileprivate func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = Strings.createDonation
        view.backgroundColor = .white
        
        fullNameTextField.autocorrectionType = .no
        donationTextField.autocorrectionType = .no
        pickupLocationTextField.autocorrectionType = .no
        
        fullNameTextField.setRoundedBorder(borderColor: UIColor.appColor(color: .darkPink), borderWidth: 0.5, radius: 25)
        donationTextField.setRoundedBorder(borderColor: UIColor.appColor(color: .darkPink), borderWidth: 0.5, radius: 25)
        pickupLocationTextField.setRoundedBorder(borderColor: UIColor.appColor(color: .darkPink), borderWidth: 0.5, radius: 25)

        saveDonationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveDonationButton.isEnabled = false
        
        let padding: CGFloat = 24
        view.addSubview(verticalStackView)
        verticalStackView.centerHorizontallyInSuperView()
        verticalStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 40, left: padding, bottom: 0, right: padding))
    }
}
