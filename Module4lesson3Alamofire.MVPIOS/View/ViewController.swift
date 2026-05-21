import UIKit

protocol ViewControllerProtocol: AnyObject {
    func updateText()
    func showLoading()
    func showError(_ message: String)
}

class ViewController: UIViewController, ViewControllerProtocol {
    var presenter: MainViewPresenterProtocol!
    
    private let quoteLabel: UILabel = {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        $0.textColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let authorLabel: UILabel = {
        $0.textAlignment = .right
        $0.font = UIFont.systemFont(ofSize: 16, weight: .light)
        $0.textColor = .gray
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let activityIndicator: UIActivityIndicatorView = {
        $0.hidesWhenStopped = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIActivityIndicatorView())
    
    private let refreshButton: UIButton = {
        $0.setTitle("Новая цитата", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.backgroundColor = .systemBlue
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 12
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        presenter.getTextData()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(quoteLabel)
        view.addSubview(authorLabel)
        view.addSubview(activityIndicator)
        view.addSubview(refreshButton)
        
        NSLayoutConstraint.activate([
            quoteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quoteLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            quoteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            quoteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            authorLabel.topAnchor.constraint(equalTo: quoteLabel.bottomAnchor, constant: 20),
            authorLabel.trailingAnchor.constraint(equalTo: quoteLabel.trailingAnchor),
            authorLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            
            refreshButton.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 40),
            refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            refreshButton.widthAnchor.constraint(equalToConstant: 200),
            refreshButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupActions() {
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
    }
    
    @objc private func refreshButtonTapped() {
        presenter.getTextData()
    }
    
    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
            self?.quoteLabel.text = "Загрузка цитаты..."
            self?.authorLabel.text = ""
            self?.refreshButton.isEnabled = false
            self?.refreshButton.alpha = 0.5
        }
    }
    
    func updateText() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.activityIndicator.stopAnimating()
            self.refreshButton.isEnabled = true
            self.refreshButton.alpha = 1.0
            
            let quoteText = self.presenter.text?.data.quote ?? "Цитата не загружена"
            let authorText = self.presenter.text?.data.author ?? ""
            
            self.animateTextChange(newQuote: quoteText, newAuthor: authorText)
        }
    }
    
    func showError(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.refreshButton.isEnabled = true
            self?.refreshButton.alpha = 1.0
            self?.quoteLabel.text = "Ошибка"
            self?.authorLabel.text = message
            
            let alert = UIAlertController(title: "Ошибка",
                                         message: message,
                                         preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Попробовать снова",
                                         style: .default) { _ in
                self?.presenter.getTextData()
            })
            self?.present(alert, animated: true)
        }
    }
    
    private func animateTextChange(newQuote: String, newAuthor: String) {
        UIView.transition(with: quoteLabel, duration: 0.3,
                         options: .transitionCrossDissolve,
                         animations: {
            self.quoteLabel.text = newQuote
        }, completion: nil)
        
        UIView.transition(with: authorLabel, duration: 0.3,
                         options: .transitionCrossDissolve,
                         animations: {
            self.authorLabel.text = newAuthor.isEmpty ? "" : "— \(newAuthor)"
        }, completion: nil)
    }
}
