import UIKit

final class FetchController: UIViewController {
    
    // MARK: Private properties
    private lazy var fetchView = FetchView(controller: self)

    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        layoutUI()
    }
}

// MARK: - FetchControllerProtocol
extension FetchController: FetchControllerProtocol {
    
    func startFetch() {
        try? NetworkManager.shared.fetchData(completion: { [weak self] data, error in
            
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async {
            
                guard error == nil else {
                    self.fetchView.viewState = .failure
                    return }
                
                switch data {
                case .initial:
                    self.fetchView.viewState = .initial
                    
                case .loading:
                    self.fetchView.viewState = .loading
                    
                case .success(let success):
                    self.fetchView.viewState = .success(success)
                    
                case .failure, .none:
                    self.fetchView.viewState = .failure
                }
            }
        })
    }
    
    
    func showFailureController() {
        let alert = UIAlertController(title: "Что-то пошло не так", message: "Мы уже работаем над этим", preferredStyle: .alert)
        alert.addAction(.init(title: "Закрыть", style: .cancel))
        present(alert, animated: true)
    }
}
                                             

// MARK: - UIConfiguratorProtocol
extension FetchController: UIConfiguratorProtocol {
    func setupUI() {
        view.addSubview(fetchView)
    }
    
    
    func layoutUI() {
        NSLayoutConstraint.setSafeAreaLayout(fetchView, self)
    }
}

