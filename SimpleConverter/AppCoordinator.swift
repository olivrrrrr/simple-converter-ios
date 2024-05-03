import UIKit

// MARK - Coordinator
protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    var navigationController: UINavigationController { get }
    func start()
}

final class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
         
    func start() {
        let initialViewController = DependencyProvider.converterViewController
        initialViewController.viewModel.coordinator = self
        navigationController.pushViewController(initialViewController, animated: false)
    }
    
    func presentSearchViewController(_ selectFlag: SelectFlagDelegate) {
        let searchViewController = DependencyProvider.searchViewController
        searchViewController.viewModel.delegate = selectFlag
        searchViewController.viewModel.coordinator = self
        searchViewController.modalPresentationStyle = .pageSheet
        searchViewController.sheetPresentationController?.detents = [.medium()]
        navigationController.present(searchViewController, animated: true)
    }
    
    func dismissSearchViewController() {
        navigationController.presentedViewController?.dismiss(animated: true)
    }
    
    func presentHistoryViewController() {
        let historyViewController = DependencyProvider.historyViewController
        navigationController.pushViewController(historyViewController, animated: true)
    }
}
