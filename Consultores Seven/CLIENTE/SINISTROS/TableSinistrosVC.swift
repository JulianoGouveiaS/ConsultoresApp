//
//  TableSinistrosVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 05/11/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import KRProgressHUD
import FirebaseFirestore
import Alamofire
import CFAlertViewController
import SwiftyJSON

class TableSinistrosVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    let cpf_cliente = KeychainWrapper.standard.string(forKey: "CPF-C")
    let id_cliente = KeychainWrapper.standard.integer(forKey: "ID-C")
    let nome_cliente = KeychainWrapper.standard.string(forKey: "NOME-C")
    
    var listaSinistros = [Sinistro]()
    let calendar = Calendar.current
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sinistros"
        loadSinistros(cpf: cpf_cliente!)
        // Do any additional setup after loading the view.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listaSinistros.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celulaReuso",
                                                 for: indexPath as IndexPath) as! CellSinistro
        
        var s = Sinistro()
        s = self.listaSinistros[indexPath.row]
       
        cell.placaLabel.text = s.placa_veiculo
        cell.modeloLabel.text = "Modelo: \(s.modelo!)"
        cell.marcaLabel.text = "Marca: \(s.marca!)"
        cell.horarioLabel.text = "Horário: \(s.created_at!)"
        cell.statusLabel.text = "\(s.nm_status!)"
        
        self.tableView.rowHeight = 172
        return cell
    }
    
    func reloadTable(){
        loadSinistros(cpf: self.cpf_cliente!)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var s = Sinistro()
        s = self.listaSinistros[indexPath.row]
        let vc = UIStoryboard(name: "Sinistro", bundle: nil).instantiateViewController(withIdentifier: "DetalhesSinistroVC") as! DetalhesSinistroVC
    
        vc.sinistroRecebido = s
        
        self.navigationController?.pushViewController(vc, animated: true)
 
    }
    
    func loadSinistros(cpf: String){
        KRProgressHUD.show()
        print("cpf",cpf)
        let parameters = ["cpf": "\(cpf)"] as [String : Any]
        
        self.listaSinistros = []
        let url = "https://www.sevenprotecaoveicular.com.br/Api/ExibirSinistro"
        Alamofire.request(url, method:.post, parameters:parameters,encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                if json["user_data"].count >= 1{
                    for i in 0 ... json["user_data"].count - 1{
                        let s = Sinistro()
                        s.id = json["user_data"][i]["id"].int
                        s.nome_associado = json["user_data"][i]["nome_associado"].stringValue
                        s.placa_veiculo = json["user_data"][i]["placa_veiculo"].stringValue
                        s.marca = json["user_data"][i]["marca"].stringValue
                        s.modelo = json["user_data"][i]["modelo"].stringValue
                        s.tipo_sinistro = json["user_data"][i]["tipo_sinistro"].stringValue
                        s.created_at = json["user_data"][i]["created_at"].stringValue
                        s.nm_status = json["user_data"][i]["nm_status"].stringValue
                        self.listaSinistros.append(s)
                    }
                }
                
                
                
                KRProgressHUD.dismiss()
               
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                KRProgressHUD.dismiss()
                
                print(error)
                
                self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Erro ao captar sinistros!", acaoAlerta: "Ok", erroRecebido: "\(error)")
            }
            
        }
    }
    
}
