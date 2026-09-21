import UIKit

final class AppRouter {
    let navigationController: UINavigationController
    
    init() {
        self.navigationController = UINavigationController()
    }

    func Start() {
        let viewController = LaunchViewController()
        navigationController.setViewControllers([viewController], animated: false)
    }
}
