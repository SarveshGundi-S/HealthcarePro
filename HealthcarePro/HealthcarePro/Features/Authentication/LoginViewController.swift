import UIKit

class LoginViewController: UIViewController {

    private let viewModel: LoginViewModel

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.title1
        label.textColor = AppColor.textPrimary
        label.text = StringConstants.Login.title.localized
        return label
    }()

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = StringConstants.Login.email.localized
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = StringConstants.Login.password.localized
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            StringConstants.Login.button.localized,
            for: .normal
        )
        return button
    }()

    private let activityIndicator = UIActivityIndicatorView(
        style: .medium
    )
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
        loginButton.addTarget(self,
                              action: #selector(loginTapped),
                              for: .touchUpInside)
    }

    private func setupUI() {

        view.backgroundColor = AppColor.background

        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            emailTextField,
            passwordTextField,
            loginButton,
            activityIndicator
        ])

        stackView.axis = .vertical
        stackView.spacing = AppSpacing.medium

        view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: AppSpacing.large
            ),
            stackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -AppSpacing.large
            ),
            stackView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            )
        ])
    }

    private func bindViewModel() {

        viewModel.onStateChange = { [weak self] in
            guard let self else { return }

            self.activityIndicator.isHidden =
                !self.viewModel.isLoading

            if self.viewModel.isLoading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }

            if let error = self.viewModel.error {
                self.showError(error)
            }
        }
    }

    @objc private func loginTapped() {

        viewModel.login(
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
    }

    private func showError(_ error: Error) {
        
        let message: String
        
        if let validationError = error as? LoginValidationError {
            message = validationMessage(for: validationError)
        } else {
            message = error.localizedDescription
        }
        
        let alert = UIAlertController(
            title: StringConstants.Login.errorTitle.localized,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )
        
        present(alert, animated: true)
    }

    private func validationMessage(for error: LoginValidationError) -> String {
        switch error {
        case .emailRequired:
            return StringConstants.Login.emailRequired.localized
            
        case .invalidEmail:
            return StringConstants.Login.invalidEmail.localized
            
        case .passwordRequired:
            return StringConstants.Login.passwordRequired.localized
        }
    }
}
