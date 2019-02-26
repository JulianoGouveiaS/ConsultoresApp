//
//  VisitasVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 05/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import KRProgressHUD
import FirebaseFirestore
import CFAlertViewController

class TableVisitasVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cpf_user = KeychainWrapper.standard.string(forKey: "CPF")
    let id_user = KeychainWrapper.standard.integer(forKey: "ID")
    let nome_user = KeychainWrapper.standard.string(forKey: "NOME")
    
    let db = Firestore.firestore()
    
    var listaVisitas = [Visita]()
    
    @IBOutlet weak var view404: UIView!
    
    var searchedList = [Visita]()
    var searching = false
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadVisitas()
        searchBar.delegate = self
        tableView.keyboardDismissMode = .interactive
        let actionButton = DTZFloatingActionButton()
        actionButton.isScrollView = true
        
        actionButton.plusColor = .white
        actionButton.shadowCircleColor = .black
        actionButton.shadowCircleOpacity = 0.4
        actionButton.shadowCircleRadius = 2
        actionButton.isAddShadow = true
        
        actionButton.handler = {
            button in
            
            let vc = UIStoryboard(name: "Visita", bundle: nil).instantiateViewController(withIdentifier: "CriarVisitaVC") as! CriarVisitaVC
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(actionButton)
        // Do any additional setup after loading the view.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedList.count
        } else {
            return listaVisitas.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celulareuso",
                                                 for: indexPath as IndexPath) as! VisitaCell
         if searching {
        var visita = Visita()
            visita = self.searchedList[indexPath.row]
        
        if visita.situacao == "0"{
            cell.img.image = UIImage(named: "salvar")
            cell.barra.backgroundColor = UIColor.lightGray
        }else if visita.situacao == "1"{
            cell.img.image = UIImage(named: "erroX")
            cell.barra.backgroundColor = UIColor(red: 178, green: 23, blue: 6)
        }else if visita.situacao == "2"{
            cell.img.image = UIImage(named: "done")
            cell.barra.backgroundColor = UIColor(red: 55, green: 200, blue: 78)
        }
        
        if visita.tpveiculo! == ""{
            cell.tipoLabel.text = "Tipo: Tipo não especificado."
        }else{
            if visita.tpveiculo! == "1"{
                cell.tipoLabel.text = "Tipo: Carro"
            }else if visita.tpveiculo! == "2"{
                 cell.tipoLabel.text = "Tipo: Moto"
            }
        }
        if visita.modelo_veiculo! == ""{
            cell.modeloLabel.text = "Modelo: Modelo não especificado."
        }else{
            cell.modeloLabel.text = "Modelo: \(visita.modelo_veiculo!)"
        }
        
        cell.nomeLabel.text = "\(visita.nome!)"
        cell.placaLabel.text = "Placa: \(visita.placa!)"
        
        self.tableView.rowHeight = 113
        return cell
         }else{
            var visita = Visita()
            visita = self.listaVisitas[indexPath.row]
            
            if visita.situacao == "0"{
                cell.img.image = UIImage(named: "salvar")
                cell.barra.backgroundColor = UIColor.lightGray
            }else if visita.situacao == "1"{
                cell.img.image = UIImage(named: "erroX")
                cell.barra.backgroundColor = UIColor(red: 178, green: 23, blue: 6)
                
            }else if visita.situacao == "2"{
                cell.img.image = UIImage(named: "done")
                cell.barra.backgroundColor = UIColor(red: 55, green: 200, blue: 78)
            }
            
            if visita.tpveiculo! == ""{
                cell.tipoLabel.text = "Tipo: Tipo não especificado."
            }else{
                if visita.tpveiculo! == "1"{
                    cell.tipoLabel.text = "Tipo: Carro"
                }else if visita.tpveiculo! == "2"{
                    cell.tipoLabel.text = "Tipo: Moto"
                }
                
            }
            if visita.modelo_veiculo! == ""{
                cell.modeloLabel.text = "Modelo: Modelo não especificado."
            }else{
                cell.modeloLabel.text = "Modelo: \(visita.modelo_veiculo!)"
            }
            
            cell.nomeLabel.text = "\(visita.nome!)"
            cell.placaLabel.text = "Placa: \(visita.placa!)"
            
            self.tableView.rowHeight = 113
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var visita = Visita()
        visita = self.listaVisitas[indexPath.row]
        
        let vc = UIStoryboard(name: "Visita", bundle: nil).instantiateViewController(withIdentifier: "EditarVisitaVC") as! EditarVisitaVC
        vc.visitaEscolhida = visita
        if visita.situacao != "1" && visita.situacao != "2"{
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let alertController = CFAlertViewController(title: "Opa!",
                                                        message: "Você não pode editar uma captação já enviada ou cancelada.",
                                                        textAlignment: .center,
                                                        preferredStyle: .alert,
                                                        didDismissAlertHandler: nil)
            
            // Present Alert View Controller
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func loadVisitas(){
        KRProgressHUD.show()
        
        db.collection("ConsultorSeven").document("Visitas").collection("\(self.id_user!)").order(by: "data", descending: true).addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.listaVisitas = []
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let dictionary = document.data()
                    let visita = Visita()
                    visita.ano_modelo = dictionary["ano_modelo"] as? String ?? ""
                    visita.bairro = dictionary["bairro"] as? String ?? ""
                    visita.captacao_enviada = dictionary["captacao_enviada"] as? String ?? ""
                    visita.cep = dictionary["cep"] as? String ?? ""
                    visita.cidade = dictionary["cidade"] as? String ?? ""
                    visita.complemento = dictionary["complemento"] as? String ?? ""
                    visita.created_at = dictionary["created_at"] as? String ?? ""
                    visita.data = dictionary["data"] as? String ?? ""
                    visita.dt_visita = dictionary["dt_visita"] as? String ?? ""
                    visita.hr_visita = dictionary["hr_visita"] as? String ?? ""
                    visita.idconsultor = dictionary["idconsultor"] as? String ?? ""
                    visita.local_origem = dictionary["local_origem"] as? String ?? ""
                    visita.logradouro = dictionary["logradouro"] as? String ?? ""
                    visita.modelo_veiculo = dictionary["modelo_veiculo"] as? String ?? ""
                    visita.nome = dictionary["nome"] as? String ?? ""
                    visita.num_residencia = dictionary["num_residencia"] as? String ?? ""
                    visita.origem = dictionary["origem"] as? String ?? ""
                    visita.placa = dictionary["placa"] as? String ?? ""
                    visita.situacao = dictionary["situacao"] as? String ?? ""
                    visita.telefone = dictionary["telefone"] as? String ?? ""
                    visita.tpveiculo = dictionary["tpveiculo"] as? String ?? ""
                    visita.uf = dictionary["uf"] as? String ?? ""
                    visita.is0KM = dictionary["zerokm"] as? Bool ?? false
                    visita.placa_isMERCOSUL = dictionary["placa_isMERCOSUL"] as? Bool ?? false
                    
                    visita.id = document.documentID
                    
                    self.listaVisitas.append(visita)
                    
                }
                
                KRProgressHUD.dismiss()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
                if self.listaVisitas.count == 0{
                    self.view404.isHidden = false
                }else{
                    self.view404.isHidden = true
                }
                
            }
            KRProgressHUD.dismiss()
        }
    } 
}
extension TableVisitasVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedList = listaVisitas.filter({$0.nome!.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.placa!.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.modelo_veiculo!.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
    
}
