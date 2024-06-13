//
//  RegisterVC.swift
//  FlashAlert
//
//  Created by Coding Brains on 20/03/24.
//  Copyright © 2024 Martin Kainzbauer. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
   
    
    @IBOutlet weak var registerBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerBtn?.layer.cornerRadius = 10

        
    }
    
    @available(iOS 13.0, *)
    @IBAction func registerTappedBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    

}
