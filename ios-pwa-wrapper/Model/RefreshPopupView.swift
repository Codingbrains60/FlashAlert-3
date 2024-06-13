//
//  RefreshPopupView.swift
//  
//
//  Created by Coding Brains on 17/04/24.
//

import UIKit

class RefreshPopupView: UIView {
    
    let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Refresh", for: .normal)
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(refreshButton)
    }
}

//class RefreshPopupView: UIView {
//    let refreshButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Refresh", for: .normal)
//        button.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
//        return button
//    }()
//    
//    // Other UI elements
//    
//    @objc func handleRefresh() {
//        // Implement the refresh action here
//        // For example, you can call your refresh method from the view controller
//    }
//}
