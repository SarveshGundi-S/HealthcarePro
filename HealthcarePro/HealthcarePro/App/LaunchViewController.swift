import UIKit

enum LaunchDestination: Sendable {
    case login
    case patient
}

class LaunchViewController: UIViewController {

    let viewModel: LaunchViewModel

    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = StringConstants.Launch.loading.localized
        label.font = AppFont.body
        label.textColor = AppColor.textSecondary
        return label
    }()

    init(viewModel: LaunchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(loadingLabel)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.start()
    }
}
