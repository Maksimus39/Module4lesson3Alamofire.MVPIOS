import Foundation

protocol MainViewPresenterProtocol: AnyObject {
    func getTextData()
    var text: StoicQuoteResponse? { get }
}

class MainViewPresenter: MainViewPresenterProtocol {
    weak var view: ViewControllerProtocol?
    var text: StoicQuoteResponse?
    private let networkManager: NetworkManagerProtocol
    
    init(view: ViewControllerProtocol? = nil,
         text: StoicQuoteResponse? = nil,
         networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.view = view
        self.text = text
        self.networkManager = networkManager
    }
    
    func getTextData() {
        view?.showLoading()
        
        networkManager.request { [weak self] (result: Result<StoicQuoteResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let quoteResponse):
                    self?.text = quoteResponse
                    self?.view?.updateText()
                    
                case .failure(let error):
                    self?.view?.showError("Не удалось загрузить цитату: \(error.localizedDescription)")
                }
            }
        }
    }
}
