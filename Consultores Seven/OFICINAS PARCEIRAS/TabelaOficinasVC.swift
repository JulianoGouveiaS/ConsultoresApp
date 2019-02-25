//
//  TabelaOficinasVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 19/02/2019.
//  Copyright © 2019 Juliano Gouveia. All rights reserved.
//

import UIKit
import KRProgressHUD
import CFAlertViewController
import StoreKit
import SwiftyJSON
import MapKit
import CoreLocation
import Alamofire

class TabelaOficinasVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    let cpf_user = KeychainWrapper.standard.string(forKey: "CPF")
    let id_user = KeychainWrapper.standard.integer(forKey: "ID")
    let nome_user = KeychainWrapper.standard.string(forKey: "NOME")
    
    var estadoSelecionado: Int!
    
    var alamofireManager: Alamofire.SessionManager?
    
    var listaOficinas = [Oficina]()
    
    var searchedList = [Oficina]()
    var searching = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadOficinas(num: estadoSelecionado)
        // Do any additional setup after loading the view.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchedList.count
        } else {
            return listaOficinas.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celulareuso",
                                                 for: indexPath as IndexPath) as! CelulaOficinas
        
        if searching {
            
            var oficina = self.searchedList[indexPath.row]
            
            cell.cidadeLbl.text = "\(oficina.cidade!)"
            cell.nomeLbl.text = "\(oficina.nm_fantasia!)"
            cell.numLbl.text = "\(oficina.telefone!)"
            
            self.tableView.rowHeight = 119
            return cell
        } else {
            var oficina = self.listaOficinas[indexPath.row]
            
            cell.cidadeLbl.text = "\(oficina.cidade!)"
            cell.nomeLbl.text = "\(oficina.nm_fantasia!)"
            cell.numLbl.text = "\(oficina.telefone!)"
            
            self.tableView.rowHeight = 119
            return cell
        }
    }
    
    func loadOficinas(num: Int){
        
        let parameters = [
            "num": num
        ]
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 12
        config.timeoutIntervalForResource = 12
        self.alamofireManager = Alamofire.SessionManager(configuration: config)
        var url = "https://www.sevenprotecaoveicular.com.br/Api/ExibeOficinas"
        
        KRProgressHUD.show()
        Alamofire.request(url, method:.post, parameters:parameters,encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                let resultado = response.result
                if let dict = resultado.value as? Dictionary<String,AnyObject>{
                    if let infoOficina = dict["user_data"]{
                        if let array: [Dictionary<String,Any>] = infoOficina as? [Dictionary<String,Any>]{
                            self.listaOficinas = array.map{
                                Oficina(dictionary: $0)
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
                KRProgressHUD.dismiss()
            case .failure(let error):
                KRProgressHUD.showError()
                if error._code == NSURLErrorTimedOut{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Sua conexão está instável", acaoAlerta: "OK")
                }else{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Erro ao captar oficinas", acaoAlerta: "OK")
                }
            }
        }
    }
   
}

extension TabelaOficinasVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedList = listaOficinas.filter({$0.cidade!.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.nm_fantasia!.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.telefone!.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
    
}
