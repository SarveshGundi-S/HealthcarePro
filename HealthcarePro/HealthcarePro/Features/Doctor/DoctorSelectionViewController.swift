import UIKit

@MainActor
final class DoctorSelectionViewController:
    UIViewController {

    private let viewModel: DoctorSelectionViewModel

    private let tableView = UITableView()

    private let activityIndicator =
        UIActivityIndicatorView(style: .medium)

    init(viewModel: DoctorSelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = StringConstants.Appointment.doctor.localized

        setupUI()
        bindViewModel()

        viewModel.loadDoctors()
    }

    private func setupUI() {

        view.backgroundColor = AppColor.background

        tableView.backgroundColor = AppColor.background
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "DoctorCell"
        )

        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

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
            ),

            activityIndicator.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),

            activityIndicator.centerYAnchor.constraint(
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
            self.tableView.reloadData()

            if let error = self.viewModel.error {
                self.showError(error)
            }
        }
    }

    private func updateLoadingState() {

        if viewModel.isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    private func showError(_ error: Error) {

        let alert = UIAlertController(
            title: StringConstants.Appointment.errorTitle.localized,
            message: error.localizedDescription,
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
}

extension DoctorSelectionViewController:
    UITableViewDataSource,
    UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        viewModel.doctors.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "DoctorCell",
            for: indexPath
        )

        let doctor = viewModel.doctors[indexPath.row]

        var content = cell.defaultContentConfiguration()

        content.text = doctor.displayName
        content.secondaryText = doctor.specialization

        content.textProperties.font = AppFont.body
        content.textProperties.color = AppColor.textPrimary

        content.secondaryTextProperties.color =
            AppColor.textSecondary

        cell.contentConfiguration = content

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        tableView.deselectRow(
            at: indexPath,
            animated: true
        )

        viewModel.selectDoctor(
            at: indexPath.row
        )
    }
}
