//
//  NewsReleaseVC.swift
//  FlashAlert
//
//  Created by Coding Brains on 10/04/24.
//  Copyright © 2024 Martin Kainzbauer. All rights reserved.
//

import UIKit
import WebKit

class NewsReleaseVC: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var myButton: UIBarButtonItem!
    let bottomSheetView = BottomSheetView()
    var bottomSheetHeight: CGFloat = 200
    var selectedURL: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        webView?.navigationDelegate = self
                setWebView()

       
            myButton?.target = self
            myButton?.action = #selector(buttonClicked)
        myButton?.tintColor =   #colorLiteral(red: 0.1864822458, green: 0.635185874, blue: 1, alpha: 1)
            }
    @objc func buttonClicked() {
        shareButtonTapped()
    }
    @objc func shareButtonTapped() {
        let shareText = "Check out this news!"
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [
            .addToReadingList,
            .assignToContact,
            .markupAsPDF,
            .print
        ]
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }
        func setWebView() {
            guard let urlString = selectedURL, let url = URL(string: urlString) else {
                return
            }
        
                webView?.load(URLRequest(url: url))
                webView?.allowsBackForwardNavigationGestures = true
            }

        }
