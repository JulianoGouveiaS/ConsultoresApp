//
//  EditarPropostaTabBar.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 05/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import KRProgressHUD
import FirebaseFirestore

class EditarPropostaTabBar: UITabBarController, UITabBarControllerDelegate {

    var situacao = "1"
   var propostaEscolhida: Proposta!
    
    let db = Firestore.firestore()
    
    let cpf_user = KeychainWrapper.standard.string(forKey: "CPF")
    let id_user = KeychainWrapper.standard.integer(forKey: "ID")
    let nome_user = KeychainWrapper.standard.string(forKey: "NOME")
    
    override func viewWillAppear(_ animated: Bool) {
        let vc0 = self.viewControllers![0] as! AssociadoVC
        let vc1 = self.viewControllers![1] as! VeiculoVC
        let vc2 = self.viewControllers![2] as! AdesaoVC
        let vc3 = self.viewControllers![3] as! FotosVC
        let vc4 = self.viewControllers![4] as! PagarVC
        
        vc0.propostaEscolhida = propostaEscolhida
        vc1.propostaEscolhida = propostaEscolhida
        vc2.propostaEscolhida = propostaEscolhida
        vc3.propostaEscolhida = propostaEscolhida
        vc4.propostaEscolhida = propostaEscolhida
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MakeButtonsNav()
        getSituacao()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func MakeButtonsNav(){
        
        let Closebutton: UIButton = UIButton(type: UIButtonType.custom) as! UIButton
        Closebutton.setImage(UIImage(named: "fechar"), for: UIControlState.normal)
        Closebutton.addTarget(self, action: "dismissTabBar", for: UIControlEvents.touchUpInside)
        Closebutton.frame = self.CGRectMake(0, 0, 53, 31)
        let barButtonClose = UIBarButtonItem(customView: Closebutton)
        
        let Savebutton: UIButton = UIButton(type: UIButtonType.custom) as! UIButton
        Savebutton.setImage(UIImage(named: "salvar"), for: UIControlState.normal)
        Savebutton.addTarget(self, action: "save", for: UIControlEvents.touchUpInside)
        Savebutton.frame = self.CGRectMake(0, 0, 53, 31)
        let barButtonSave = UIBarButtonItem(customView: Savebutton)
        
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButtonSave
        
        self.navigationItem.leftBarButtonItem = barButtonClose
        
    }
    
    @objc func dismissTabBar(){
        if let tabViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarPrincipal") as? TabBarPrincipal {
            tabViewController.selectedIndex = 2
            
            navigationController?.pushViewController(tabViewController, animated: true)
        }
    }

    @objc func save(){
    
        if self.selectedIndex == 0{
            let vc = self.viewControllers![0] as! AssociadoVC
            vc.salvarCampos()
        }else if self.selectedIndex == 1{
            let vc = self.viewControllers![1] as! VeiculoVC
            vc.salvarCampos()
        }else if self.selectedIndex == 2{
            let vc = self.viewControllers![2] as! AdesaoVC
            vc.salvarCampos()
        }else {
            
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item", item.tag )
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected view controller", viewController)
        print("index", tabBarController.selectedIndex )
        
        if tabBarController.selectedIndex == 4{
            if self.situacao == "4"{
                let salvarComprovante: UIButton = UIButton(type: UIButtonType.custom) as! UIButton
                salvarComprovante.setTitle("Salvar Comprovante", for: .normal)
                salvarComprovante.setTitleColor(UIColor.blue, for: .normal)
                salvarComprovante.addTarget(self, action: "salvarComprovante", for: UIControlEvents.touchUpInside)
                salvarComprovante.frame = self.CGRectMake(0, 0, 53, 31)
                let barButtonSave = UIBarButtonItem(customView: salvarComprovante)
                
                //assign button to navigationbar
                self.navigationItem.rightBarButtonItem = barButtonSave
            }else{
                let Enviarbutton: UIButton = UIButton(type: UIButtonType.custom) as! UIButton
                Enviarbutton.setTitle("Pagar", for: .normal)
                Enviarbutton.setTitleColor(UIColor.blue, for: .normal)
                Enviarbutton.addTarget(self, action: "pagarProposta", for: UIControlEvents.touchUpInside)
                Enviarbutton.frame = self.CGRectMake(0, 0, 53, 31)
                let barButtonEnviar = UIBarButtonItem(customView: Enviarbutton)
                
                //assign button to navigationbar
                self.navigationItem.rightBarButtonItem = barButtonEnviar
            }
            
        }else if tabBarController.selectedIndex == 3{
            
            let Enviarbutton: UIButton = UIButton(type: UIButtonType.custom) as! UIButton
            Enviarbutton.setImage(UIImage(named: "enviado"), for: UIControlState.normal)
            Enviarbutton.addTarget(self, action: "enviarProposta", for: UIControlEvents.touchUpInside)
            Enviarbutton.frame = self.CGRectMake(0, 0, 53, 31)
            let barButtonEnviar = UIBarButtonItem(customView: Enviarbutton)
            
            //assign button to navigationbar
            self.navigationItem.rightBarButtonItem = barButtonEnviar
           
        }else{
            let Savebutton: UIButton = UIButton(type: UIButtonType.custom) as! UIButton
            Savebutton.setImage(UIImage(named: "salvar"), for: UIControlState.normal)
            Savebutton.addTarget(self, action: "save", for: UIControlEvents.touchUpInside)
            Savebutton.frame = self.CGRectMake(0, 0, 53, 31)
            let barButtonSave = UIBarButtonItem(customView: Savebutton)
            
            //assign button to navigationbar
            self.navigationItem.rightBarButtonItem = barButtonSave
        }
        
       
    }
    
    @objc func salvarComprovante(){
        let vc = self.viewControllers![4] as! PagarVC
        vc.salvarComprovante()
    }
    
    @objc func enviarProposta(){
        if self.selectedIndex == 3{
            let vc = self.viewControllers![3] as! FotosVC
            vc.enviarProposta()
        }
    }
    
    @objc func pagarProposta(){
        if self.selectedIndex == 4{
            let vc = self.viewControllers![4] as! PagarVC
            vc.pagar()
        }
    }
    
    func getSituacao(){
        
        db.collection("ConsultorSeven").document("MinhasPropostas").collection("\(self.id_user!)").document("\(self.propostaEscolhida.id!)").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                let dictionary = querySnapshot!.data()
                
                if dictionary?["situacao"] as? String == "4"{
                  self.situacao = "4"
                }
                
            }
        }
    }
    
}
