//
//  ViewController.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 05/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//
/*
import UIKit

class TabBarPrincipal: UITabBarController, UITabBarControllerDelegate {
    
    
    let tabbarCont = UITabBarController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        if tabBarController.selectedIndex == 0{
            button.setImage(UIImage(named: "calendario"), for: UIControlState.normal)
            //add function for button
            button.addTarget(self, action: "plus", for: UIControlEvents.touchUpInside)
        }else if tabBarController.selectedIndex == 1{
            button.setImage(UIImage(named: "calendarioMark"), for: UIControlState.normal)
            //add function for button
            button.addTarget(self, action: "plus", for: UIControlEvents.touchUpInside)
        }else if tabBarController.selectedIndex == 2{
            button.setImage(UIImage(named: "pasta"), for: UIControlState.normal)
            //add function for button
            button.addTarget(self, action: "plus", for: UIControlEvents.touchUpInside)
            
        }else if tabBarController.selectedIndex == 3{
            button.setImage(UIImage(named: "user"), for: UIControlState.normal)
            //add function for button
            button.addTarget(self, action: "plus", for: UIControlEvents.touchUpInside)
        }
        
        //set frame
        button.frame = self.CGRectMake(0, 0, 53, 31)
        let barButton = UIBarButtonItem(customView: button)
        
        
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func MakeButtonsNav(){
        let button: UIButton = UIButton(type: UIButtonType.custom) as! UIButton
        //set image for button
        
        button.setImage(UIImage(named: "calendario"), for: UIControlState.normal)
        
        //add function for button
        button.addTarget(self, action: "plus", for: UIControlEvents.touchUpInside)
       
        
        //set frame
        button.frame = self.CGRectMake(0, 0, 53, 31)
        let barButton = UIBarButtonItem(customView: button)
        
        
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        
    }
    
    @objc func plus(){
        print("click")
    }

}
*/
