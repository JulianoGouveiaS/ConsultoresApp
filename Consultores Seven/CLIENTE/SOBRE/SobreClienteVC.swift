//
//  SobreClienteVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 05/11/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit

class SobreClienteVC: UIViewController {

    @IBOutlet weak var lblVersao: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        let version = Bundle.main.releaseVersionNumber
        let build = Bundle.main.buildVersionNumber
        
        lblVersao.text = "Build \(build!).0 - Versão \(version!)"
        // Do any additional setup after loading the view.
    }
    
}
