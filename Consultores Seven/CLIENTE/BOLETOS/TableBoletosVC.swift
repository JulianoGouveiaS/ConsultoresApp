//
//  TableBoletosVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 01/11/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import KRProgressHUD
import FirebaseFirestore
import Alamofire
import CFAlertViewController
import SwiftyJSON


class TableBoletosVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    let cpf_cliente = KeychainWrapper.standard.string(forKey: "CPF-C")
    let id_cliente = KeychainWrapper.standard.integer(forKey: "ID-C")
    let nome_cliente = KeychainWrapper.standard.string(forKey: "NOME-C")
    
    var listaBoletos = [Boleto]()
    let calendar = Calendar.current
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Meus Boletos"
        loadBoletos(id: id_cliente!)
        // Do any additional setup after loading the view.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listaBoletos.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celulaReuso",
                                                 for: indexPath as IndexPath) as! CellBoletos
        
        var b = Boleto()
        b = self.listaBoletos[indexPath.row]
        
        
        if b.data_pagamento! == ""{
             cell.pagoLabel.text = "Aguardando pagamento."
        }else{
             cell.pagoLabel.text = "Pago em: \(b.data_pagamento!)"
        }
       
        cell.valorLabel.text = "Valor: \(b.valor!)"
        cell.vencimentoLabel.text = "Vencimento: \(b.data_vencimento!)"
        if b.situacao_boleto! == "BAIXADO"{
            cell.imgCodeBar.image = UIImage(named:"002-bar-code")
        }else  if b.situacao_boleto! == "ABERTO"{
            cell.imgCodeBar.image = UIImage(named:"003-bar-code")
        }else{
            cell.imgCodeBar.image = UIImage(named:"001-bar-code")
        }
        cell.statusLabel.text = "\(b.situacao_boleto!)"
        
        self.tableView.rowHeight = 110
        return cell
    }

    func reloadTable(){
        loadBoletos(id: self.id_cliente!)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var b = Boleto()
        b = self.listaBoletos[indexPath.row]
        
        
        let vc = UIStoryboard(name: "Boletos", bundle: nil).instantiateViewController(withIdentifier: "DetalhesBoletosVC") as! DetalhesBoletosVC
        
        
        vc.nosso_numero = b.nosso_numero
        vc.valor = b.valor
        vc.tipo_boleto = b.tipo_boleto
        vc.data_vencimento = b.data_vencimento
        vc.data_pagamento = b.data_pagamento
        vc.mes_referente = b.mes_referente
        vc.nome_associado = b.nome_associado
        vc.situacao_associado = b.situacao_associado
        vc.situacao_boleto = b.situacao_boleto
        vc.placas_veiculos_boleto = b.placas_veiculos_boleto
        vc.chassi_veiculos_boleto = b.chassi_veiculos_boleto
        vc.situacao_veiculos_boleto = b.situacao_veiculos_boleto
        vc.url_boleto = b.url_boleto
        
        
        self.navigationController?.pushViewController(vc, animated: true)
 
    }
    
    func loadBoletos(id: Int){
        KRProgressHUD.show()
        print("id",id)
        let parameters = ["id_user": "\(id)"] as [String : Any]
        
        self.listaBoletos = []
        let url = "https://www.sevenprotecaoveicular.com.br/Api/BoletosListAndorid"
        Alamofire.request(url, method:.post, parameters:parameters,encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                if json["user_data"]["success"].stringValue != "false"{
                    for i in 0 ... json["user_data"].count - 1{
                        let b = Boleto()
                        
                        b.nosso_numero = json["user_data"][i]["nosso_numero"].stringValue
                        b.valor = json["user_data"][i]["valor"].stringValue
                        b.tipo_boleto = json["user_data"][i]["tipo_boleto"].stringValue
                        b.data_vencimento = json["user_data"][i]["data_vencimento"].stringValue
                        b.data_pagamento = json["user_data"][i]["data_pagamento"].stringValue
                        b.mes_referente = json["user_data"][i]["mes_referente"].stringValue
                        b.nome_associado = json["user_data"][i]["nome_associado"].stringValue
                        b.situacao_associado = json["user_data"][i]["situacao_associado"].stringValue
                        b.situacao_boleto = json["user_data"][i]["situacao_boleto"].stringValue
                        b.placas_veiculos_boleto = json["user_data"][i]["placas_veiculos_boleto"].stringValue
                        b.chassi_veiculos_boleto = json["user_data"][i]["chassi_veiculos_boleto"].stringValue
                        b.situacao_veiculos_boleto = json["user_data"][i]["situacao_veiculos_boleto"].stringValue
                        b.url_boleto = json["user_data"][i]["url_boleto"].stringValue
                        self.listaBoletos.append(b)
                    }
                }else{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: json["user_data"]["msg"].stringValue, acaoAlerta: "OK")
                }
               
                KRProgressHUD.dismiss()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                KRProgressHUD.dismiss()
                
                print(error)
                
                self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Erro ao captar boletos!", acaoAlerta: "Ok", erroRecebido: "\(error)")
            }
            
        }
    }
    
}
