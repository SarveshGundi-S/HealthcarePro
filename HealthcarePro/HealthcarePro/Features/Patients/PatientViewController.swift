//
//  PatientViewController.swift
//  HealthcarePro
//
//  Created by Sarvesh on 21/09/26.
//

import UIKit

class PatientViewController: UIViewController {

    private let viewModel: PatientViewModel

    private let nameLabel = UILabel()
    private let detailsLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let bookAppointmentButton: UIButton = {
        let button = UIButton(type: .system)

        button.setTitle(
            StringConstants.Appointment.bookButton.localized,
            for: .normal
        )

        button.titleLabel?.font = AppFont.body

        return button
    }()
    private let appointmentsButton = UIButton(type: .system)

    var onBookAppointment: (() -> Void)?
    var onViewAppointments: (() -> Void)?

    init(viewModel: PatientViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        setupUI()
        bindViewModel()
        viewModel.fetchPatient(patientId: "P001")
    }

    func bindViewModel() {
        viewModel.onStateChange = { [weak self] in
            guard let self else {
                return
            }
            self.updateUI()
        }
    }

    func updateUI() {
        if viewModel.isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }

        if let patient = viewModel.patient {
            nameLabel.text = "\(patient.firstName) \(patient.lastName)"
            detailsLabel.text = """
                        \(StringConstants.Patient.dateOfBirth.localized): \(patient.dateOfBirth)
                        \(StringConstants.Patient.phone): \(patient.phoneNumber)
                        \(StringConstants.Patient.email): \(patient.email)
                        """
            
            return
        }

        if let error = viewModel.error {
            nameLabel.text = "Unable to load patient"
            detailsLabel.text = error.localizedDescription
        }
    }

    @objc private func bookAppointmentTapped() {
        onBookAppointment?()
    }

    @objc private func appointmentsTapped() {
        onViewAppointments?()
    }
}

private extension PatientViewController {

    func setupUI() {

        view.backgroundColor = AppColor.background
        nameLabel.textColor = AppColor.primary

        nameLabel.font = AppFont.title1

        detailsLabel.font = AppFont.body

        detailsLabel.numberOfLines = 0

        let stackView = UIStackView(
            arrangedSubviews: [
                nameLabel,
                detailsLabel,
                activityIndicator
            ]
        )
        stackView.addArrangedSubview(bookAppointmentButton)
        stackView.addArrangedSubview(appointmentsButton)

        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),

            stackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),

            stackView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            )
        ])
    }

    private func configureButtons() {
        bookAppointmentButton.setTitle(
            StringConstants.Appointment.bookAppointment.localized,
            for: .normal
        )

        appointmentsButton.setTitle(
            StringConstants.Appointment.viewAppointments.localized,
            for: .normal
        )

        bookAppointmentButton.titleLabel?.font = AppFont.body
        appointmentsButton.titleLabel?.font = AppFont.body

        bookAppointmentButton.backgroundColor = AppColor.primary
        bookAppointmentButton.setTitleColor(.white, for: .normal)

        appointmentsButton.backgroundColor = AppColor.primary.withAlphaComponent(0.1)
        appointmentsButton.setTitleColor(.white, for: .normal)

        bookAppointmentButton.layer.cornerRadius = 10
        appointmentsButton.layer.cornerRadius = 10

        bookAppointmentButton.addTarget(
            self,
            action: #selector(bookAppointmentTapped),
            for: .touchUpInside
        )

        appointmentsButton.addTarget(
            self,
            action: #selector(appointmentsTapped),
            for: .touchUpInside
        )
    }
}
