import UIKit

@available(iOS 13.0, *)
class LoaderView: UIView {
    private var activityIndicator: UIActivityIndicatorView!
    private var loadingLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        self.addSubview(activityIndicator)
        
        loadingLabel = UILabel()
        loadingLabel.text = "Loading..."
        loadingLabel.textColor = .black
        loadingLabel.font = UIFont.systemFont(ofSize: 16)
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(loadingLabel)
        
        setupConstraints()
    }

    private func setupConstraints() {
        // Center the activity indicator in the view
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 10),
            loadingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    func show(in view: UIView, withMessage message: String? = nil) {
        self.frame = view.bounds
        loadingLabel.text = message
        view.addSubview(self)
    }

    func hide() {
        self.removeFromSuperview()
    }
}
