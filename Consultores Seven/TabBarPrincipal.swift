//
//  ViewController.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 05/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import CFAlertViewController

class TabBarPrincipal: UITabBarController, UITabBarControllerDelegate {
    
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
    @objc func pushToNextVC() {
        let newVC = UIViewController()
        newVC.view.backgroundColor = UIColor.red
        self.navigationController?.pushViewController(newVC, animated:
            true)
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
        
        let bttnPerfil: UIButton = UIButton(type: UIButtonType.custom)
        bttnPerfil.setImage(UIImage(named: "user (1)"), for: .normal)
        bttnPerfil.addTarget(self, action: "irPerfil", for: UIControlEvents.touchUpInside)
        bttnPerfil.frame = self.CGRectMake(0, 0, 53, 31)
        let barButtonperfil = UIBarButtonItem(customView: bttnPerfil)
        
        let bttnGrafico: UIButton = UIButton(type: UIButtonType.custom)
        bttnGrafico.setImage(UIImage(named: "chart"), for: .normal)
        bttnGrafico.addTarget(self, action: "showGraficos", for: UIControlEvents.touchUpInside)
        bttnGrafico.frame = self.CGRectMake(0, 0, 53, 31)
        let barButtongrafico = UIBarButtonItem(customView: bttnGrafico)
        
        //self.navigationItem.rightBarButtonItems = [barButtonperfil, barButtongrafico]
        self.navigationItem.rightBarButtonItems = [barButtonperfil]
    }
    
    func MakeButtonsNav(){
        
        let buttonOff: UIButton = UIButton(type: UIButtonType.custom) as! UIButton
        buttonOff.setImage(UIImage(named: "off"), for: UIControlState.normal)
        buttonOff.addTarget(self, action: "logoff", for: UIControlEvents.touchUpInside)
        buttonOff.frame = self.CGRectMake(0, 0, 53, 31)
        let barButtonOff = UIBarButtonItem(customView: buttonOff)
        
        let bttnPerfil: UIButton = UIButton(type: UIButtonType.custom)
        bttnPerfil.setImage(UIImage(named: "user (1)"), for: .normal)
        bttnPerfil.addTarget(self, action: "irPerfil", for: UIControlEvents.touchUpInside)
        bttnPerfil.frame = self.CGRectMake(0, 0, 53, 31)
        let barButtonperfil = UIBarButtonItem(customView: bttnPerfil)
        
        let bttnGrafico: UIButton = UIButton(type: UIButtonType.custom)
        bttnGrafico.setImage(UIImage(named: "chart"), for: .normal)
        bttnGrafico.addTarget(self, action: "showGraficos", for: UIControlEvents.touchUpInside)
        bttnGrafico.frame = self.CGRectMake(0, 0, 53, 31)
        let barButtongrafico = UIBarButtonItem(customView: bttnGrafico)
        
        
        //assign button to navigationbar
       // self.navigationItem.rightBarButtonItems = [barButtonperfil, barButtongrafico]
         self.navigationItem.rightBarButtonItems = [barButtonperfil]
        self.navigationItem.leftBarButtonItem = barButtonOff
        
    }
    
    @objc func irPerfil(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PerfilViewController") as? PerfilViewController
        self.navigationController!.pushViewController(vc!, animated: true)
    }
    
    @objc func showGraficos(){
        let vc = UIStoryboard(name: "Graficos", bundle: nil).instantiateViewController(withIdentifier: "BarChartAndTableVC") as? BarChartAndTableVC
        self.navigationController!.pushViewController(vc!, animated: true)
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
