//
//  DadosEnderecoVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 31/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit

class DadosEnderecoVC: UIViewController {

    var contatoEm: String!
    var nacionalidade: String!
    var cor_raca: String!
    var sexo: String!
    var dt_nasc: String!
    var rg: String!
    var dt_expedicao: String!
    var orgaoEmissor: String!
    var ufEmissor: String!
    var tituloEleitor: String!
    var dt_venc_cnh: String!
    var numCarteiraTrab: String!
    var numCTPS: String!
    var ufCTPS: String!
    var PIS: String!
    var nomeMae: String!
    var nomePai: String!
    var time: String!
    var religiao: String!
    var numFIlhos: String!
    
    
     @IBOutlet weak var cep: UITextField!
     @IBOutlet weak var estado: UITextField!
     @IBOutlet weak var cidade: UITextField!
     @IBOutlet weak var bairro: UITextField!
     @IBOutlet weak var logradouro: UITextField!
     @IBOutlet weak var numero: UITextField!
     @IBOutlet weak var numeroCel: UITextField!
 
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        let vc = UIStoryboard(name: "AtualizarDados", bundle: nil).instantiateViewController(withIdentifier: "ConclusaoVC") as! ConclusaoVC
        
        vc.contatoEm = self.contatoEm
        vc.nacionalidade = self.nacionalidade
        vc.cor_raca = self.cor_raca
        vc.sexo = self.sexo
        vc.dt_nasc = self.dt_nasc
        vc.rg = self.rg
        vc.dt_expedicao = self.dt_expedicao
        vc.orgaoEmissor = self.orgaoEmissor
        vc.ufEmissor = self.ufEmissor
        vc.tituloEleitor = self.tituloEleitor
        vc.dt_venc_cnh = self.dt_venc_cnh
        vc.numCarteiraTrab = self.numCarteiraTrab
        vc.numCTPS = self.numCTPS
        vc.ufCTPS = self.ufCTPS
        vc.PIS = self.PIS
        vc.nomeMae = self.nomeMae
        vc.nomePai = self.nomePai
        vc.time = self.time
        vc.religiao = self.religiao
        vc.numFIlhos = self.numFIlhos
        
        vc.cep = self.cep.text!
        vc.estado = self.estado.text!
        vc.cidade = self.cidade.text!
        vc.bairro = self.bairro.text!
        vc.logradouro = self.logradouro.text!
        vc.numero = self.numero.text!
        vc.numeroCel = self.numeroCel.text!
        
        
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    
    
}
