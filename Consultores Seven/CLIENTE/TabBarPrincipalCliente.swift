//
//  TabBarPrincipalCliente.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 01/11/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import CFAlertViewController

class TabBarPrincipalCliente: UITabBarController, UITabBarControllerDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MakeButtonsNav()
        self.delegate = self
        // MARK: - Actions
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item", item.tag )
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected view controller", viewController)
        print("index", tabBarController.selectedIndex )
        let button: UIButton = UIButton(type: UIButtonType.custom) as! UIButton
        
        //set image for button
        if tabBarController.selectedIndex == 3{
            self.navigationController?.isNavigationBarHidden = true
        }else{
            self.navigationController?.isNavigationBarHidden = false
        }
        
        if tabBarController.selectedIndex == 1{
            let bttnReload: UIButton = UIButton(type: UIButtonType.custom)
            bttnReload.setImage(UIImage(named: "reload"), for: .normal)
            bttnReload.addTarget(self, action: "reloadBoleto", for: UIControlEvents.touchUpInside)
            bttnReload.frame = self.CGRectMake(0, 0, 53, 31)
            let barButtonreload = UIBarButtonItem(customView: bttnReload)
            
            
            //assign button to navigationbar
            self.navigationItem.rightBarButtonItems = [barButtonreload]
        }else if tabBarController.selectedIndex == 2{
            let bttnReload: UIButton = UIButton(type: UIButtonType.custom)
            bttnReload.setImage(UIImage(named: "reload"), for: .normal)
            bttnReload.addTarget(self, action: "reloadSinistro", for: UIControlEvents.touchUpInside)
            bttnReload.frame = self.CGRectMake(0, 0, 53, 31)
            let barButtonreload = UIBarButtonItem(customView: bttnReload)
            
            
            //assign button to navigationbar
            self.navigationItem.rightBarButtonItems = [barButtonreload]
        }else{
           self.navigationItem.rightBarButtonItems = nil
        }
        
       
    }
    @objc func reloadSinistro() {
           let vc = UIStoryboard(name: "MainCliente", bundle: nil).instantiateViewController(withIdentifier: "TableSinistrosVC") as? TableSinistrosVC
       vc?.reloadTable()
    }
    
    @objc func reloadBoleto() {
        let vc = UIStoryboard(name: "MainCliente", bundle: nil).instantiateViewController(withIdentifier: "TableBoletosVC") as? TableBoletosVC
        vc?.reloadTable()
    }
    func MakeButtonsNav(){
        
        let buttonOff: UIButton = UIButton(type: UIButtonType.custom) as! UIButton
        buttonOff.setImage(UIImage(named: "off"), for: UIControlState.normal)
        buttonOff.addTarget(self, action: "logoff", for: UIControlEvents.touchUpInside)
        buttonOff.frame = self.CGRectMake(0, 0, 53, 31)
        let barButtonOff = UIBarButtonItem(customView: buttonOff)
        
        
        
        
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButtonOff
        
    }
    
    @objc func logoff(){
        // Create Alet View Controller
        let alertController = CFAlertViewController(title: "LOGOUT",
                                                    message: "Tem certeza que deseja sair do aplicativo?",
                                                    textAlignment: .center,
                                                    preferredStyle: .alert,
                                                    didDismissAlertHandler: nil)
        
        // Create Upgrade Action
        let Sair = CFAlertAction(title: "Sair",
                                 style: .Default,
                                 alignment: .center,
                                 backgroundColor: UIColor.red,
                                 textColor: UIColor.black,
                                 handler: { (action) in
                                    
                                    KeychainWrapper.standard.removeAllKeys()
                                    
                                    let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                                    
                                    self.navigationController!.pushViewController(vc!, animated: true)
        })
        
        // Create Upgrade Action
        let Cancelar = CFAlertAction(title: "Cancelar",
                                     style: .Destructive,
                                     alignment: .center,
                                     backgroundColor: UIColor(displayP3Red: 0/255, green: 14/255, blue: 87/255, alpha: 1),
                                     textColor: UIColor.white,
                                     handler: { (action) in
                                        
        })
        // Add Action Button Into Alert
        alertController.addAction(Sair)
        alertController.addAction(Cancelar)
        
        // Present Alert View Controller
        present(alertController, animated: true, completion: nil)
    }
    
}

