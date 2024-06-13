//
//  BottomSheetView.swift
//  FlashAlert
//
//  Created by Coding Brains on 17/04/24.
//  Copyright © 2024 Martin Kainzbauer. All rights reserved.
//

import UIKit
import MessageUI

class BottomSheetView: UIView {
    let emailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Email", for: .normal)
        button.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let copyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Copy to Clipboard", for: .normal)
        button.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
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
        addSubview(emailButton)
        addSubview(copyButton)
        addSubview(cancelButton)
    }
    
    @objc func emailButtonTapped() {
    }
    
    @objc func copyButtonTapped() {
    }
    
    @objc func cancelButtonTapped() {
    }
}
