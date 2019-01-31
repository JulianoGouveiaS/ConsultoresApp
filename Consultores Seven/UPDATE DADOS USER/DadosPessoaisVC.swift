//
//  AtualizarDadosVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 31/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit

class AtualizarDadosVC: UIViewController {

     @IBOutlet weak var contatoEmergencia: UITextField!
     @IBOutlet weak var nacionalidadeTxtField: UITextField!
     @IBOutlet weak var cor_racaTxtField: UITextField!
     @IBOutlet weak var sexoTxtField: UITextField!
     @IBOutlet weak var dt_nascTxtField: UITextField!
     @IBOutlet weak var rgTxtField: UITextField!
     @IBOutlet weak var dt_expedicaoTxtField: UITextField!
     @IBOutlet weak var orgaoEmissorTxtField: UITextField!
     @IBOutlet weak var ufEmissorTxtField: UITextField!
     @IBOutlet weak var tituloEleitorTxtField: UITextField!
     @IBOutlet weak var dt_venc_cnhTxtField: UITextField!
     @IBOutlet weak var numCarteiraTrabTxtField: UITextField!
     @IBOutlet weak var numCTPSTxtField: UITextField!
     @IBOutlet weak var ufCTPSTxtField: UITextField!
     @IBOutlet weak var PISTxtField: UITextField!
     @IBOutlet weak var nomeMaeTxtField: UITextField!
     @IBOutlet weak var nomePaiTxtField: UITextField!
     @IBOutlet weak var timeTxtField: UITextField!
     @IBOutlet weak var religiaoTxtField: UITextField!
     @IBOutlet weak var numFIlhosTxtField: UITextField!
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true);
        // Do any additional setup after loading the view.
    }
    
    @IBAction func prosseguir(sender:Any){
        let allTextField = getTextfield(view: self.view)
        for txtField in allTextField
        {
            if txtField.text == "" {
                self.setBottomBorder(textField: txtField)
                CriarAlertaSemErro(tituloAlerta: "Atenção", mensagemAlerta: "Você precisa preencher TODOS os campos para continuar", acaoAlerta: "OK")
            }else{
                self.hideBottomBorder(textField: txtField)
            }
        }
        let vc = UIStoryboard(name: "AtualizarDados", bundle: nil).instantiateViewController(withIdentifier: "DadosEnderecoVC") as! DadosEnderecoVC
        
        
        vc.contatoEm = self.contatoEmergencia.text!
        vc.nacionalidade = self.nacionalidadeTxtField.text!
        vc.cor_raca = self.cor_racaTxtField.text!
        vc.sexo = self.sexoTxtField.text!
        vc.dt_nasc = self.dt_nascTxtField.text!
        vc.rg = self.rgTxtField.text!
        vc.dt_expedicao = self.dt_expedicaoTxtField.text!
        vc.orgaoEmissor = self.orgaoEmissorTxtField.text!
        vc.ufEmissor = self.ufEmissorTxtField.text!
        vc.tituloEleitor = self.tituloEleitorTxtField.text!
        vc.dt_venc_cnh = self.dt_venc_cnhTxtField.text!
        vc.numCarteiraTrab = self.numCarteiraTrabTxtField.text!
        vc.numCTPS = self.numCTPSTxtField.text!
        vc.ufCTPS = self.ufCTPSTxtField.text!
        vc.PIS = self.PISTxtField.text!
        vc.nomeMae = self.nomeMaeTxtField.text!
        vc.nomePai = self.nomePaiTxtField.text!
        vc.time = self.timeTxtField.text!
        vc.religiao = self.religiaoTxtField.text!
        vc.numFIlhos = self.numFIlhosTxtField.text!
        
        self.navigationController!.pushViewController(vc, animated: true)
    }

}
