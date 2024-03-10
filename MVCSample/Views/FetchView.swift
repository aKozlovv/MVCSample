import UIKit

final class FetchView: UIView, ViewProtocol {
    
    var viewState: ViewData = .initial { didSet { setNeedsLayout() } }
    
    private lazy var jokeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemFill
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Get Joke", for: .normal)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .systemCyan
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    
    weak var controller: FetchControllerProtocol?
    
    init(controller: FetchControllerProtocol?) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.controller = controller
        setupUI()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch viewState {
        case .initial:
            manageLoadingIndicator(stop: true, isHidden: true)
            updateView(with: nil, isEnabled: true)
            
        case .loading:
            manageLoadingIndicator(stop: false, isHidden: false)
            updateView(with: nil, isEnabled: false)
            
        case .success(let joke):
            manageLoadingIndicator(stop: true, isHidden: true)
            updateView(with: joke, isEnabled: true)
            
        case .failure:
            manageLoadingIndicator(stop: true, isHidden: true)
            updateView(with: nil, isEnabled: true)
            showFailureResponse()
        }
    }
    
    @objc private func startButtonTapped() {
        controller?.startFetch()
    }
    
    private func manageLoadingIndicator(stop: Bool, isHidden: Bool) {
        loadingIndicator.isHidden = isHidden
        stop ? loadingIndicator.stopAnimating() : loadingIndicator.startAnimating()
    }
    
    private func updateView(with data: ViewData.Joke?, isEnabled: Bool) {
        jokeLabel.text = data?.value
        startButton.isEnabled = isEnabled
    }
    
    private func showFailureResponse() {
        controller?.showFailureController()
    }
}

// MARK: - UIConfiguratorProtocol
extension FetchView: UIConfiguratorProtocol {
    func setupUI() {
        addSubview(loadingIndicator)
        addSubview(jokeLabel)
        addSubview(startButton)
    }
    
    func layoutUI() {
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            jokeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            jokeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            jokeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            jokeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            startButton.topAnchor.constraint(equalTo: jokeLabel.bottomAnchor, constant: 15),
            startButton.leadingAnchor.constraint(equalTo: jokeLabel.leadingAnchor),
            startButton.trailingAnchor.constraint(equalTo: jokeLabel.trailingAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
