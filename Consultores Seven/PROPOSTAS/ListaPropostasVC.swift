//
//  EditarPropostaVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 05/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import KRProgressHUD
import FirebaseFirestore
import CFAlertViewController
import SwiftyPickerPopover

class ListaPropostasVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let cpf_user = KeychainWrapper.standard.string(forKey: "CPF")
    let id_user = KeychainWrapper.standard.integer(forKey: "ID")
    let nome_user = KeychainWrapper.standard.string(forKey: "NOME")
    

    let db = Firestore.firestore()
    
    var listaPropostas = [Proposta]()
    
    @IBOutlet weak var tableView: UITableView!
    var searchedList = [Proposta]()
    var searching = false
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPropostas()
        searchBar.delegate = self
        tableView.keyboardDismissMode = .interactive
        // Do any additional setup after loading the view.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedList.count
        } else {
            return listaPropostas.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celulareuso",
                                                 for: indexPath as IndexPath) as! PropostaCell
        
        //
        
        var proposta = Proposta()
        if searching {
            proposta = self.searchedList[indexPath.row]
          
            if proposta.situacao == "1"{
                cell.img.image = UIImage(named: "salvar")
                cell.barra.backgroundColor = UIColor.lightGray
            }else if proposta.situacao == "2"{
                if proposta.antigaEnviada == true{
                    cell.img.image = UIImage(named: "done")
                    cell.barra.backgroundColor = UIColor(red: 55, green: 200, blue: 78)
                }else{
                    cell.img.image = UIImage(named: "salvar")
                    cell.barra.backgroundColor = UIColor.lightGray
                }
            }else if proposta.situacao == "3"{
                cell.img.image = UIImage(named: "done")
                cell.barra.backgroundColor = UIColor(red: 55, green: 200, blue: 78)
            }else if proposta.situacao == "4"{
                //pgto efetuado
                cell.img.image = UIImage(named: "dollar")
                cell.barra.backgroundColor = UIColor(red: 27, green: 141, blue: 44)
            }else if proposta.situacao == "5"{
                cell.img.image = UIImage(named: "rastreador")
                cell.barra.backgroundColor = UIColor(red: 52, green: 49, blue: 108)
            }
            
            if proposta.tpveiculo == ""{
                cell.tipoLabel.text = "Tipo: Tipo não especificado."
            }else{
                if proposta.tpveiculo! == "1"{
                    cell.tipoLabel.text = "Tipo: Carro"
                }else if proposta.tpveiculo! == "2"{
                    cell.tipoLabel.text = "Tipo: Moto"
                }
                
            }
            if proposta.cpfcnpj! == ""{
                cell.cpfLabel.text = "CPF/CNPJ: CPF/CNPJ não especificado."
            }else{
                cell.cpfLabel.text = "CPF/CNPJ: \(proposta.cpfcnpj!)"
            }
            
            cell.nomeLabel.text = "\(proposta.nome!)"
            cell.placaLabel.text = "Placa: \(proposta.placa!)"
            cell.dt_modificacaoLabel.text = "Criado em: \(proposta.created_at!)"
            
            self.tableView.rowHeight = 127
            
            return cell
        }else{
            proposta = self.listaPropostas[indexPath.row]
            
            if proposta.situacao == "1"{
                cell.img.image = UIImage(named: "salvar")
                cell.barra.backgroundColor = UIColor.lightGray
            }else if proposta.situacao == "2"{
                if proposta.antigaEnviada == true{
                    cell.img.image = UIImage(named: "done")
                    cell.barra.backgroundColor = UIColor(red: 55, green: 200, blue: 78)
                }else{
                    cell.img.image = UIImage(named: "salvar")
                    cell.barra.backgroundColor = UIColor.lightGray
                }
            }else if proposta.situacao == "3"{
                cell.img.image = UIImage(named: "done")
                cell.barra.backgroundColor = UIColor(red: 55, green: 200, blue: 78)
            }else if proposta.situacao == "4"{
                //pgto efetuado
                cell.img.image = UIImage(named: "dollar")
                cell.barra.backgroundColor = UIColor(red: 27, green: 141, blue: 44)
            }else if proposta.situacao == "5"{
                cell.img.image = UIImage(named: "rastreador")
                cell.barra.backgroundColor = UIColor(red: 52, green: 49, blue: 108)
            }
            
            if proposta.tpveiculo == ""{
                cell.tipoLabel.text = "Tipo: Tipo não especificado."
            }else{
                if proposta.tpveiculo! == "1"{
                    cell.tipoLabel.text = "Tipo: Carro"
                }else if proposta.tpveiculo! == "2"{
                    cell.tipoLabel.text = "Tipo: Moto"
                }
                
            }
            if proposta.cpfcnpj! == ""{
                cell.cpfLabel.text = "CPF/CNPJ: CPF/CNPJ não especificado."
            }else{
                cell.cpfLabel.text = "CPF/CNPJ: \(proposta.cpfcnpj!)"
            }
            
            cell.nomeLabel.text = "\(proposta.nome!)"
            cell.placaLabel.text = "Placa: \(proposta.placa!)"
            
            cell.dt_modificacaoLabel.text = "\(self.id_user!).\(proposta.id!.prefix(13))"
            
            self.tableView.rowHeight = 115
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var proposta = Proposta()
        proposta = self.listaPropostas[indexPath.row]
        
        if proposta.situacao == "5" {
           
            let alertController = CFAlertViewController(title: "RASTREADOR",
                                                        message: "Como deseja prosseguir?",
                                                        textAlignment: .center,
                                                        preferredStyle: .alert,
                                                        didDismissAlertHandler: nil)
            
            // Create Upgrade Action
            let Rastreador = CFAlertAction(title: "Editar Rastreador",
                                     style: .Default,
                                     alignment: .center,
                                     backgroundColor: UIColor(displayP3Red: 0/255, green: 14/255, blue: 87/255, alpha: 1),
                                     textColor: UIColor.white,
                                     handler: { (action) in
                                        
                                        
                                        let vc = UIStoryboard(name: "Rastreador", bundle: nil).instantiateViewController(withIdentifier: "CamposRastreadorVC") as! CamposRastreadorVC
                                        vc.propostaEscolhida = proposta
                                        self.navigationController?.pushViewController(vc, animated: true)
            })
            
            // Create Upgrade Action
            let Proposta = CFAlertAction(title: "Editar Proposta",
                                         style: .Destructive,
                                         alignment: .center,
                                         backgroundColor: UIColor(displayP3Red: 0/255, green: 14/255, blue: 87/255, alpha: 1),
                                         textColor: UIColor.white,
                                         handler: { (action) in
                                            
                                            let tabViewController = UIStoryboard(name: "Proposta", bundle: nil).instantiateViewController(withIdentifier: "EditarPropostaTabBar") as! EditarPropostaTabBar
                                            
                                            tabViewController.propostaEscolhida = proposta
                                            self.navigationController?.pushViewController(tabViewController, animated: true)
                                            
            })
            
            // Add Action Button Into Alert
            alertController.addAction(Rastreador)
            alertController.addAction(Proposta)
            
            // Present Alert View Controller
            present(alertController, animated: true, completion: nil)
            
        }else{
            let tabViewController = UIStoryboard(name: "Proposta", bundle: nil).instantiateViewController(withIdentifier: "EditarPropostaTabBar") as! EditarPropostaTabBar
            
            tabViewController.propostaEscolhida = proposta
            self.navigationController?.pushViewController(tabViewController, animated: true)
        }
        
    }
    
    
    func loadPropostas(){
        KRProgressHUD.show()
        
        db.collection("ConsultorSeven").document("MinhasPropostas").collection("\(self.id_user!)").order(by: "data", descending: true).addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.listaPropostas = []
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let dictionary = document.data()
                    let proposta = Proposta()
                    proposta.avarias = dictionary["avarias"] as? Bool ?? false
                    proposta.carres15 = dictionary["carres15"] as? Bool ?? false
                    proposta.carres30 = dictionary["carres30"] as? Bool ?? false
                    proposta.cartaopremio = dictionary["cartaopremio"] as? Bool ?? false
                    proposta.coparticipacaored = dictionary["coparticipacaored"] as? Bool ?? false
                    proposta.danosterceiros = dictionary["danosterceiros"] as? Bool ?? false
                    proposta.km1000 = dictionary["km1000"] as? Bool ?? false
                    proposta.km500 = dictionary["km500"] as? Bool ?? false
                    proposta.km700 = dictionary["km700"] as? Bool ?? false
                    proposta.pctpremio15 = dictionary["pctpremio15"] as? Bool ?? false
                    proposta.pctpremio30 = dictionary["pctpremio30"] as? Bool ?? false
                    proposta.protvidro = dictionary["protvidro"] as? Bool ?? false
                    proposta.rastreadorparceirosv = dictionary["rastreadorparceirosv"] as? Bool ?? false
                    proposta.uber = dictionary["uber"] as? Bool ?? false
                    
                    proposta.bairro = dictionary["bairro"] as? String ?? ""
                    proposta.cep = dictionary["cep"] as? String ?? ""
                    proposta.cidade = dictionary["cidade"] as? String ?? ""
                    proposta.combustivel = dictionary["combustivel"] as? String ?? ""
                    proposta.complemento = dictionary["complemento"] as? String ?? ""
                    proposta.cor = dictionary["cor"] as? String ?? ""
                    proposta.cpfcnpj = dictionary["cpfcnpj"] as? String ?? ""
                    proposta.created_at = dictionary["created_at"] as? String ?? ""
                    proposta.data = dictionary["data"] as? Int64 ?? 1538765436820 as Int64
                    proposta.id = dictionary["id"] as? String ?? ""
                    proposta.idconsultor = dictionary["idconsultor"] as? String ?? ""
                    proposta.local_origem = dictionary["local_origem"] as? String ?? ""
                    proposta.logradouro = dictionary["logradouro"] as? String ?? ""
                    proposta.nome = dictionary["nome"] as? String ?? ""
                    proposta.num_residencia = dictionary["num_residencia"] as? String ?? ""
                    proposta.pessoa = dictionary["pessoa"] as? String ?? ""
                    proposta.placa = dictionary["placa"] as? String ?? ""
                    proposta.seguro = dictionary["seguro"] as? String ?? ""
                    proposta.sexo = dictionary["sexo"] as? String ?? ""
                    proposta.situacao = dictionary["situacao"] as? String ?? ""
                    proposta.status_permissao = dictionary["status_permissao"] as? String ?? ""
                    proposta.tpveiculo = dictionary["tpveiculo"] as? String ?? ""
                    proposta.uf = dictionary["uf"] as? String ?? ""
                    proposta.zerokm = dictionary["zerokm"] as? String ?? ""
                    proposta.mae = dictionary["mae"] as? String ?? ""
                    proposta.rg = dictionary["rg"] as? String ?? ""
                    proposta.cnh = dictionary["cnh"] as? String ?? ""
                    proposta.celular = dictionary["celular"] as? String ?? ""
                    proposta.dtnasc = dictionary["dtnasc"] as? String ?? ""
                    proposta.telefone = dictionary["telefone"] as? String ?? ""
                    proposta.email = dictionary["email"] as? String ?? ""
                    if dictionary["estaEnviado"] as? String ?? "" == "0" || dictionary["estaEnviado"] as? String ?? "" == "1"{
                        proposta.antigaEnviada = true
                    }else{
                        proposta.antigaEnviada = false
                    }
                    proposta.id = document.documentID
                    
                    self.listaPropostas.append(proposta)
                    
                }
                
                
                KRProgressHUD.dismiss()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            KRProgressHUD.dismiss()
        }
    }
    
}
extension ListaPropostasVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedList = listaPropostas.filter({$0.nome!.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.placa!.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.cpfcnpj!.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.tpveiculo!.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.created_at!.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
    
}
