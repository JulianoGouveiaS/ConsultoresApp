//
//  TabBarPropostas.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 05/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit

class TabBarPropostas: UITabBarController, UITabBarControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title) ?")
        return true;
    }
    
    
    @objc func pushToNextVC() {
        let newVC = UIViewController()
        newVC.view.backgroundColor = UIColor.red
        self.navigationController?.pushViewController(newVC, animated:
            true)
    }
    
    
    
}
