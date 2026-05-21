import UIKit

class Assembly {
    static func createMainViewController() -> UIViewController {
        let viewController = ViewController()
        let presenter = MainViewPresenter(view: viewController)
        viewController.presenter = presenter
        
        return viewController
    }
}
