import UIKit

@MainActor
final class AppointmentConfirmationViewController:
    UIViewController {

    private let appointment: Appointment

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.title1
        label.textColor = AppColor.textPrimary
        label.textAlignment = .center
        label.text = StringConstants.Appointment.successTitle.localized
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body
        label.textColor = AppColor.textSecondary
        label.textAlignment = .center
        return label
    }()

    init(appointment: Appointment) {
        self.appointment = appointment
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        configure()
    }

    private func setupUI() {

        view.backgroundColor = AppColor.background

        let stackView = UIStackView(
            arrangedSubviews: [
                titleLabel,
                dateLabel
            ]
        )

        stackView.axis = .vertical
        stackView.spacing = AppSpacing.medium
        stackView.alignment = .center

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

    private func configure() {

        let date = appointment.appointmentDate.formattedDate(as: .custom("dd MMM yyyy, h:mm a"))
        dateLabel.text = date
    }
}
