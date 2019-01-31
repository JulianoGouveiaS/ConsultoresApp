//
//  ConclusaoVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 31/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import Alamofire
import KRProgressHUD
import SwiftyJSON

class ConclusaoVC: UIViewController {
    
    let cpf_user = KeychainWrapper.standard.string(forKey: "CPF")
    let id_user = KeychainWrapper.standard.integer(forKey: "ID")
    let nome_user = KeychainWrapper.standard.string(forKey: "NOME")
    
    //pg1
    var cep: String!
    var estado: String!
    var cidade: String!
    var bairro: String!
    var logradouro: String!
    var numero: String!
    var numeroCel: String!
    
    //pg2
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
    
     @IBOutlet weak var dt_admissaoTxtField: UITextField!
     @IBOutlet weak var jornadaTrabTxtField: UITextField!
     @IBOutlet weak var tp_registroTxtField: UITextField!
     @IBOutlet weak var cargoTxtField: UITextField!
     @IBOutlet weak var tp_contaTxtField: UITextField!
     @IBOutlet weak var num_contaTxtField: UITextField!
     @IBOutlet weak var num_agenciaTxtField: UITextField!
     @IBOutlet weak var nome_bancoTxtField: UITextField!
     @IBOutlet weak var CNPJTxtField: UITextField!
     @IBOutlet weak var responsavel_contratacaoTxtField: UITextField!
     @IBOutlet weak var responsavel_treinamentoTxtField: UITextField!
     
    
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
        self.enviaCadastro()
    }
    
    func enviaCadastro(){
    
            KRProgressHUD.show()
            
        let parameters = [
            "id_voluntario": self.id_user!,
            "dt_admissao": self.dt_admissaoTxtField.text!,
            "jornada_trabalho": jornadaTrabTxtField.text!,
            "tipo_registro": tp_registroTxtField.text!,
            "cargo": cargoTxtField.text!,
            "tipo_conta": tp_contaTxtField.text!,
            "numero_conta": self.num_contaTxtField.text!,
            "numero_agencia": self.num_agenciaTxtField.text!,
            "nome_banco": self.nome_bancoTxtField.text!,
            "cnpj": self.CNPJTxtField.text!,
            "responsavel_contrato": self.responsavel_contratacaoTxtField.text!,
            "responsavel_treinamento": self.responsavel_treinamentoTxtField.text!,
            "cep": cep!,
            "uf": ufEmissor!,
            "endereco": self.logradouro!,
            "bairro": self.bairro!,
            "cidade": self.cidade!,
            "numero": self.numero!,
            "num_cel": self.numeroCel!,
            "contato_emergencia": self.contatoEm!,
            "nacionalidade": self.nacionalidade!,
            "cor_raca": self.cor_raca!,
            "sexomf": self.sexo!,
            "dt_nascimento": self.dt_nasc!,
            "rg": self.rg!,
            "dt_expedicao": self.dt_expedicao!,
            "orgao_emissor": self.orgaoEmissor!,
            "uf_emissor": self.ufEmissor!,
            "titulo_eleitor": self.tituloEleitor!,
            "num_cnh": self.numCarteiraTrab!,
            "dt_primeira_cnh": "0",
            "dt_venc_cnh": self.dt_venc_cnh!,
            "num_cart_trabalho": self.numCarteiraTrab!,
            "num_ctps": self.numCTPS!,
            "uf_ctps":self.ufCTPS!,
            "pis": self.PIS!,
            "nome_mae": self.nomeMae!,
            "nome_pai": self.nomePai!,
            "time_torce":self.time!,
            "religiao": self.religiao!,
            "filhos": self.numFIlhos!
            ] as [String : Any]
            
            
            print("parametros => ", parameters)
            let url = "https://www.sevenprotecaoveicular.com.br/Api/Admissao"
            Alamofire.request(url, method:.post, parameters:parameters,encoding: JSONEncoding.default).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    KRProgressHUD.showSuccess()
                    
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarPrincipal") as! TabBarPrincipal
                    self.navigationController!.pushViewController(vc, animated: true)
                case .failure(let error):
                    KRProgressHUD.dismiss()
                    
                    print(error)
                    
                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Erro ao efetuar envio!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                    
                }
                
            }
        }
    
}
