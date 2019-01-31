//
//  TabelVeiculosVC.swift
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

class TableVeiculosVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
   
    let db = Firestore.firestore()
    
    var listaVeiculos = [Veiculo]()
    let calendar = Calendar.current
    @IBOutlet weak var tableView: UITableView!
    
    let cpf_cliente = KeychainWrapper.standard.string(forKey: "CPF-C")
    let id_cliente = KeychainWrapper.standard.integer(forKey: "ID-C")
    let nome_cliente = KeychainWrapper.standard.string(forKey: "NOME-C")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Meus Veículos"
        loadVeículos(id: id_cliente!)
        // Do any additional setup after loading the view.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listaVeiculos.count
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celulaReuso",
                                                 for: indexPath as IndexPath) as! CellVeiculos
      
            var veiculo = Veiculo()
            veiculo = self.listaVeiculos[indexPath.row]
        
            cell.placaLabel.text = "\(veiculo.placa!)"
            cell.statusLabel.text = "\(veiculo.id_status!)"
            cell.fipeLabel.text = "\(veiculo.cod_fipe!)"
            
            self.tableView.rowHeight = 85
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var v = Veiculo()
        v = self.listaVeiculos[indexPath.row]
        let vc = UIStoryboard(name: "DetalhesVeiculos", bundle: nil).instantiateViewController(withIdentifier: "DetalhesVeiculosVC") as! DetalhesVeiculosVC
        
        
        vc.tp_seguro = v.tp_seguro
        vc.tipo_veiculo = v.tipo_veiculo
        vc.id_cor = v.id_cor
        vc.id_combustivel = v.id_combustivel
        vc.dt_vencimento = v.dt_vencimento
        vc.dt_contrato = v.dt_contrato
        vc.vl_adesao = v.vl_adesao
        vc.vl_mensal = v.vl_mensal
        vc.marca = v.marca
        vc.modelo = v.modelo
        vc.ano_fb = v.ano_fb
        vc.ano_modelo = v.ano_modelo
        vc.cod_fipe = v.cod_fipe
        vc.valor = v.valor
        vc.chassi = v.chassi
        vc.renavam = v.renavam
        vc.placa = v.placa
        vc.dt_vistoria = v.dt_vistoria
        vc.id_status = v.id_status
        vc.id_tipo = v.id_tipo
        

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func loadVeículos(id: Int){
        KRProgressHUD.show()
        
        let parameters = ["id_user": "\(id)"] as [String : Any]
        
        self.listaVeiculos = []
        let url = "https://www.sevenprotecaoveicular.com.br/Api/VeiculosList"
        Alamofire.request(url, method:.post, parameters:parameters,encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
             
                for i in 0 ... json["user_data"].count - 1{
                    let v = Veiculo()
                        v.dt_vencimento = json["user_data"][i]["dt_vencimento"].stringValue
                        v.dt_contrato = json["user_data"][i]["dt_contrato"].stringValue
                        v.vl_adesao = json["user_data"][i]["vl_adesao"].stringValue
                        v.vl_mensal = json["user_data"][i]["vl_mensal"].stringValue
                        v.txtobs = json["user_data"][i]["txtobs"].stringValue
                        v.marca = json["user_data"][i]["marca"].stringValue
                        v.modelo = json["user_data"][i]["modelo"].stringValue
                        v.ano_fb = json["user_data"][i]["ano_fb"].stringValue
                        v.ano_modelo = json["user_data"][i]["ano_modelo"].stringValue
                        v.cod_fipe = json["user_data"][i]["cod_fipe"].stringValue
                        v.valor = json["user_data"][i]["valor"].stringValue
                        v.chassi = json["user_data"][i]["chassi"].stringValue
                        v.renavam = json["user_data"][i]["renavam"].stringValue
                        v.placa = json["user_data"][i]["placa"].stringValue
                        v.id_status = json["user_data"][i]["id_status"].stringValue
                        v.nosso_numero = json["user_data"]["nosso_numero"].stringValue
                        v.token = json["user_data"][i]["token"].stringValue
                        v.created_at = json["user_data"][i]["created_at"].stringValue
                        v.updated_at = json["user_data"][i]["updated_at"].stringValue
                        v.dt_vistoria = json["user_data"][i]["dt_vistoria"].stringValue
                        v.id = json["user_data"][i]["id"].int
                        v.id_voluntario = json["user_data"][i]["id_voluntario"].int
                        v.id_coperativa = json["user_data"][i]["id_coperativa"].int
                        v.tp_seguro = json["user_data"][i]["tp_seguro"].int
                        v.id_classificacao = json["user_data"][i]["id_classificacao"].int
                        v.id_cota = json["user_data"][i]["id_cota"].int
                        v.tipo_veiculo = json["user_data"][i]["tipo_veiculo"].int
                        v.id_cor = json["user_data"][i]["id_cor"].int
                        v.id_combustivel = json["user_data"][i]["id_combustivel"].int
                        v.tp_cobranca = json["user_data"][i]["tp_cobranca"].int
                        v.id_tipo = json["user_data"][i]["id_tipo"].int
                        v.id_cliente = json["user_data"][i]["id_cliente"].int
                        v.p_premio = json["user_data"][i]["p_premio"].int
                        v.km5001 = json["user_data"][i]["km5001"].int
                        v.boleto_interno = json["user_data"][i]["boleto_interno"].int
                        v.km5002 = json["user_data"][i]["km5002"].int
                        v.km700 = json["user_data"][i]["km700"].int
                        v.km1000 = json["user_data"][i]["km1000"].int
                        v.chkdanos = json["user_data"][i]["chkdanos"].int
                        v.copr1 = json["user_data"][i]["copr1"].int
                        v.providros = json["user_data"][i]["providros"].int
                        v.copr2 = json["user_data"][i]["copr2"].int
                        v.uber = json["user_data"][i]["uber"].int
                        v.chkdanos1 = json["user_data"][i]["chkdanos1"].int
                        v.rastreadorchk = json["user_data"][i]["rastreadorchk"].int
                        v.carres = json["user_data"][i]["carres"].int
                        v.id_situacao = json["user_data"][i]["id_situacao"].int
                        v.id_vistoriador = json["user_data"][i]["id_vistoriador"].int
                     self.listaVeiculos.append(v)
                }
                
                KRProgressHUD.dismiss()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                KRProgressHUD.dismiss()
                
                print(error)
                
                self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Erro ao Efetuar login!", acaoAlerta: "Ok", erroRecebido: "\(error)")
            }
            
        }
    }
    
}
