//
//  SobreVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 25/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit

class SobreVC: UIViewController {

    @IBOutlet weak var lblVersao: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false

        let version = Bundle.main.releaseVersionNumber
        let build = Bundle.main.buildVersionNumber
        
        lblVersao.text = "Build \(build!).0 - Versão \(version!)"
        // Do any additional setup after loading the view.
    }
    

   

}
