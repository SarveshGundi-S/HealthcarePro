import UIKit

@MainActor
final class BookAppointmentViewController: UIViewController {

    private let viewModel: BookAppointmentViewModel

    var onSelectDoctor: (() -> Void)?
    var onBookingSuccess: ((Appointment) -> Void)?

    private let doctorButton: UIButton = {
        let button = UIButton(type: .system)

        button.setTitle(
            StringConstants.Appointment.doctor.localized,
            for: .normal
        )

        button.titleLabel?.font = AppFont.body
        button.contentHorizontalAlignment = .left

        return button
    }()

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.minimumDate = Date()
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()

    private let selectedDateLabel: UILabel = {
        let label = UILabel()

        label.font = AppFont.body
        label.textColor = AppColor.textPrimary
        label.textAlignment = .center

        return label
    }()

    private let bookButton: UIButton = {
        let button = UIButton(type: .system)

        button.setTitle(
            StringConstants.Appointment.bookButton.localized,
            for: .normal
        )

        button.titleLabel?.font = AppFont.body
        button.backgroundColor = AppColor.primary
        button.setTitleColor(.white, for: .normal)

        return button
    }()

    private let activityIndicator =
        UIActivityIndicatorView(style: .medium)

    init(viewModel: BookAppointmentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = StringConstants.Appointment.title.localized

        updateSelectedDate()
        setupUI()
        bindViewModel()

        bookButton.addTarget(self,
                             action: #selector(bookButtonTapped),
                             for: .touchUpInside)

        doctorButton.addTarget(self,
                               action: #selector(doctorButtonTapped),
                               for: .touchUpInside)
        datePicker.addTarget(self,
                             action: #selector(dateChanged),
                             for: .valueChanged)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func updateSelectedDate() {

        selectedDateLabel.text = datePicker.date.formatted(
            as: .custom("dd MMM yyyy, h:mm a"))
    }

    private func setupUI() {

        view.backgroundColor = AppColor.background

        let stackView = UIStackView(arrangedSubviews: [
            doctorButton,
            selectedDateLabel,
            datePicker,
            bookButton,
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

            guard let self else {
                return
            }

            self.updateLoadingState()

            if let doctor = self.viewModel.selectedDoctor {
                self.doctorButton.setTitle(doctor.displayName, for: .normal)
            }

            if let error = self.viewModel.error {
                self.showError(error)
            }
        }

        viewModel.onBookingSuccess = { [weak self] appointment in

            self?.showBookingSuccess(appointment: appointment)
        }
    }

    private func updateLoadingState() {

        bookButton.isEnabled = !viewModel.isLoading
        doctorButton.isEnabled = !viewModel.isLoading
        datePicker.isEnabled = !viewModel.isLoading

        if viewModel.isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    @objc private func bookButtonTapped() {
        viewModel.bookAppointment(appointmentDate: datePicker.date)
    }

    @objc private func doctorButtonTapped() {
        onSelectDoctor?()
    }

    @objc private func dateChanged() {
        updateSelectedDate()
    }

    private func showError(_ error: Error) {

        let message: String

        if let validationError =
            error as? AppointmentValidationError {

            switch validationError {

            case .doctorRequired:
                message =
                    StringConstants.Appointment
                        .doctorRequired
                        .localized

            case .invalidAppointmentDate:
                message =
                    StringConstants.Appointment
                        .invalidDate
                        .localized
            }

        } else {
            message = error.localizedDescription
        }

        let alert = UIAlertController(
            title: StringConstants.Appointment
                .errorTitle
                .localized,
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

    private func showBookingSuccess(appointment: Appointment) {
        onBookingSuccess?(appointment)
    }
}
