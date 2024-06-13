import UIKit

@available(iOS 13.0, *)
class CustomLoaderView: UIView {
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .large)
        indicator.color = .black
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading Alerts"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Image view for the loader image
    let loaderImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "loader_image"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white.withAlphaComponent(0.8)
        layer.cornerRadius = 10
        
        addSubview(messageLabel)
        addSubview(loaderImageView)
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10), // Adjusted top anchor
            
            loaderImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loaderImageView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            loaderImageView.widthAnchor.constraint(equalToConstant: 100), // Adjusted width
            loaderImageView.heightAnchor.constraint(equalToConstant: 20), // Adjusted height
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: loaderImageView.bottomAnchor, constant: -1),
            activityIndicator.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: 10) // Adjusted bottom anchor
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
