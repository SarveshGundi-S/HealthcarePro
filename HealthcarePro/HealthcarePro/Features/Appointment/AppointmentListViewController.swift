import UIKit

@MainActor
final class AppointmentListViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: AppointmentListViewModel

    private let tableView = UITableView()

    private let emptyStateLabel = UILabel()

    private let activityIndicator = UIActivityIndicatorView(
        style: .medium
    )

    // MARK: - Initialization

    init(viewModel: AppointmentListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = StringConstants.Appointment.title.localized

        setupUI()
        bindViewModel()

        viewModel.loadAppointments()
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = AppColor.background

        configureTableView()
        configureEmptyState()
        configureActivityIndicator()
    }

    private func configureTableView() {
        tableView.backgroundColor = AppColor.background
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "AppointmentCell"
        )

        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }

    private func configureEmptyState() {
        emptyStateLabel.text =
            StringConstants.Common.noAppointments.localized

        emptyStateLabel.textAlignment = .center
        emptyStateLabel.font = AppFont.body
        emptyStateLabel.textColor = AppColor.textSecondary
        emptyStateLabel.numberOfLines = 0

        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(emptyStateLabel)

        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            emptyStateLabel.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),
            emptyStateLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: AppSpacing.medium
            ),
            emptyStateLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -AppSpacing.medium
            )
        ])
    }

    private func configureActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        activityIndicator.hidesWhenStopped = true

        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            activityIndicator.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            )
        ])
    }

    // MARK: - ViewModel Binding

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] in
            guard let self else {
                return
            }

            self.render()
        }
    }

    // MARK: - Rendering

    private func render() {

        // Loading
        if viewModel.isLoading {
            tableView.isHidden = true
            emptyStateLabel.isHidden = true

            activityIndicator.isHidden = false
            activityIndicator.startAnimating()

            return
        }

        // Stop loading
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true

        // Error
        if let error = viewModel.error {
            tableView.isHidden = true
            emptyStateLabel.isHidden = true

            presentError(error)

            return
        }

        // Empty
        if viewModel.appointments.isEmpty {
            tableView.isHidden = true
            emptyStateLabel.isHidden = false

            return
        }

        // Loaded
        tableView.isHidden = false
        emptyStateLabel.isHidden = true

        tableView.reloadData()
    }

    // MARK: - Error Handling

    private func presentError(_ error: Error) {
        guard presentedViewController == nil else {
            return
        }

        let alert = UIAlertController(
            title: StringConstants.Common.error.localized,
            message: errorMessage(for: error),
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: StringConstants.Common.ok.localized,
                style: .default
            )
        )

        present(alert, animated: true)
    }

    private func errorMessage(for error: Error) -> String {

        guard let networkError = error as? NetworkError else {
            return StringConstants.Common.somethingWentWrong.localized
        }

        switch networkError {

        case .unauthorized:
            return StringConstants.Common.sessionExpired.localized

        case .forbidden:
            return StringConstants.Common.noPermission.localized

        case .notFound:
            return StringConstants.Common.noAppointments.localized

        case .serverError:
            return StringConstants.Common.serverError.localized

        case .transport:
            return StringConstants.Common.networkError.localized

        case .apiError(let apiError):
            return apiError.message

        default:
            return StringConstants.Common.unableToLoadAppointments.localized
        }
    }
}

// MARK: - UITableViewDataSource

extension AppointmentListViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.appointments.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "AppointmentCell",
            for: indexPath
        )

        let appointment = viewModel.appointments[indexPath.row]

        var content = cell.defaultContentConfiguration()

        content.text = "Doctor ID: \(appointment.doctorId)"

        let formattedDate =
        appointment.appointmentDate.formattedDate(as: .custom("dd MMM yyyy, h:mm a"))

        content.secondaryText = formattedDate

        content.textProperties.font = AppFont.body
        content.textProperties.color = AppColor.textPrimary

        content.secondaryTextProperties.color =
            AppColor.textSecondary

        cell.contentConfiguration = content

        return cell
    }
}

// MARK: - UITableViewDelegate

extension AppointmentListViewController: UITableViewDelegate {

}
