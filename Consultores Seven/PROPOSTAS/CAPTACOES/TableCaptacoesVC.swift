//
//  TableCaptacoesVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 05/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import KRProgressHUD
import FirebaseFirestore
import CFAlertViewController
import StoreKit

class TableCaptacoesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
     let cpf_user = KeychainWrapper.standard.string(forKey: "CPF")
     let id_user = KeychainWrapper.standard.integer(forKey: "ID")
     let nome_user = KeychainWrapper.standard.string(forKey: "NOME")
    
     let db = Firestore.firestore()

    var listaCaptacoes = [Captacao]()
    
    var searchedList = [Captacao]()
    var searching = false
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var viewFunil: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    let calendar = Calendar.current
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        checkVersion()
        hideKeyboardWhenTappedAround()
        loadCaptacoes()
        searchBar.delegate = self
        tableView.keyboardDismissMode = .interactive
        let actionButton = DTZFloatingActionButton()
        actionButton.isScrollView = true
        
        actionButton.plusColor = .white
        actionButton.shadowCircleColor = .black
        actionButton.shadowCircleOpacity = 0.4
        actionButton.shadowCircleRadius = 2
        actionButton.isAddShadow = true
       /*
        if #available( iOS 10.3,*){
            SKStoreReviewController.requestReview()
            apareceuRateApp()
        }*/
        
        actionButton.handler = {
            button in
           
            let vc = UIStoryboard(name: "Captacao", bundle: nil).instantiateViewController(withIdentifier: "CriarCaptacaoViewController") as! CriarCaptacaoViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.view.addSubview(actionButton)
        // Do any additional setup after loading the view.
    }
    /*
    func apareceuRateApp(){
        let db = Firestore.firestore()
        let date = Date()
            let Reference = db.collection("ConsultorSeven").document("iosVersion").collection("CheckRateApp").document("\(self.id_user!)")
            var values: [String : Any]!
            values = ["date": "\(date)"] as [String : Any]
            
            Reference.setData(values) { (error) in
                if error != nil{
                    print("erro ao acessar servidor", error)
                    self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao acessar servidor!", acaoAlerta: "OK", erroRecebido:"\(error)")
                    return
                }
        }
    }
    
    func checkDataRateApp() -> Date{
        let db = Firestore.firestore()
        var date: Date!
        db.collection("ConsultorSeven").document("iosVersion").collection("CheckRateApp").document("\(self.id_user!)").getDocument { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let dictionary = querySnapshot?.data()
                
                date = dictionary?["date"] as? Date ?? nil
                
            }
            KRProgressHUD.dismiss()
        }
        return Date()
    }*/
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchedList.count
        } else {
            return listaCaptacoes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celulareuso",
                                                 for: indexPath as IndexPath) as! CaptacaoCell
      
        if searching {
            var captacao = Captacao()
            captacao = self.searchedList[indexPath.row]
            if captacao.situacao == "0"{
                cell.imagem.image = UIImage(named: "salvar")
                cell.barra.backgroundColor = UIColor.lightGray
            }else if captacao.situacao == "1"{
                cell.imagem.image = UIImage(named: "erroX")
                cell.barra.backgroundColor = UIColor(red: 178, green: 23, blue: 6)
                
            }else if captacao.situacao == "2"{
                cell.imagem.image = UIImage(named: "done")
                cell.barra.backgroundColor = UIColor(red: 55, green: 200, blue: 78)
            }
            
            cell.anoModeloLabel.text = "Ano Modelo: \(captacao.ano_modelo!)"
            cell.ModeloLabel.text = "Modelo: \(captacao.modelo_veiculo!)"
            cell.nomeLabel.text = "\(captacao.nome!)"
            cell.placaLabel.text = "Placa: \(captacao.placa!)"
            
            self.tableView.rowHeight = 113
            return cell
        } else {
            var captacao = Captacao()
            captacao = self.listaCaptacoes[indexPath.row]
            if captacao.situacao == "0"{
                cell.imagem.image = UIImage(named: "salvar")
                cell.barra.backgroundColor = UIColor.lightGray
            }else if captacao.situacao == "1"{
                cell.imagem.image = UIImage(named: "erroX")
                cell.barra.backgroundColor = UIColor(red: 178, green: 23, blue: 6)
                
            }else if captacao.situacao == "2"{
                cell.imagem.image = UIImage(named: "done")
                cell.barra.backgroundColor = UIColor(red: 55, green: 200, blue: 78)
            }
            
            cell.anoModeloLabel.text = "Ano Modelo: \(captacao.ano_modelo!)"
            cell.ModeloLabel.text = "Modelo: \(captacao.modelo_veiculo!)"
            cell.nomeLabel.text = "\(captacao.nome!)"
            cell.placaLabel.text = "Placa: \(captacao.placa!)"
            
            self.tableView.rowHeight = 113
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var cap = Captacao()
        cap = self.listaCaptacoes[indexPath.row]
        
        let vc = UIStoryboard(name: "Captacao", bundle: nil).instantiateViewController(withIdentifier: "EditarCaptacaoViewController") as! EditarCaptacaoViewController
        vc.captaçãoEscolhida = cap
        if cap.situacao != "1" && cap.situacao != "2"{
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
    
    
    func loadCaptacoes(){
        KRProgressHUD.show()
        
        db.collection("ConsultorSeven").document("Captacoes").collection("\(self.id_user!)").order(by: "data", descending: true).addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.listaCaptacoes = []
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let dictionary = document.data()
                    let cap = Captacao()
                    cap.ano_modelo = dictionary["ano_modelo"] as? String ?? ""
                    cap.bairro = dictionary["bairro"] as? String ?? ""
                    cap.captacao_enviada = dictionary["captacao_enviada"] as? String ?? ""
                    cap.cep = dictionary["cep"] as? String ?? ""
                    cap.cidade = dictionary["cidade"] as? String ?? ""
                    cap.complemento = dictionary["complemento"] as? String ?? ""
                    cap.created_at = dictionary["created_at"] as? String ?? ""
                    cap.data = dictionary["data"] as? String ?? ""
                    cap.dt_visita = dictionary["dt_visita"] as? String ?? ""
                    cap.hr_visita = dictionary["hr_visita"] as? String ?? ""
                    cap.idconsultor = dictionary["idconsultor"] as? String ?? ""
                    cap.local_origem = dictionary["local_origem"] as? String ?? ""
                    cap.logradouro = dictionary["logradouro"] as? String ?? ""
                    cap.modelo_veiculo = dictionary["modelo_veiculo"] as? String ?? ""
                    cap.nome = dictionary["nome"] as? String ?? ""
                    cap.num_residencia = dictionary["num_residencia"] as? String ?? ""
                    cap.origem = dictionary["origem"] as? String ?? ""
                    cap.placa = dictionary["placa"] as? String ?? ""
                    cap.situacao = dictionary["situacao"] as? String ?? ""
                    cap.telefone = dictionary["telefone"] as? String ?? ""
                    cap.tpveiculo = dictionary["tpveiculo"] as? String ?? ""
                    cap.uf = dictionary["uf"] as? String ?? ""
                    cap.id = document.documentID
                    
                    self.listaCaptacoes.append(cap)
                }
                
                KRProgressHUD.dismiss()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            KRProgressHUD.dismiss()
        }
    }
    
    func checkVersion(){
        db.collection("ConsultorSeven").document("iosVersion").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                    let dictionary = querySnapshot?.data()
                    let atualizando = dictionary?["atualizando"] as? String ?? ""
                if atualizando != "sim"{
                    let idAtualizado = dictionary?["versionNovoApp"] as? String ?? ""
                    let VersaoDoAparelho = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
                    
                    if idAtualizado != VersaoDoAparelho {
                        let alert = UIAlertController(title: "Opa", message: "Você está usando a versão \(VersaoDoAparelho!), atualize para a versão atual: \(idAtualizado)", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "ATUALIZAR", style: UIAlertActionStyle.default, handler: { (alerta) in
                            if let url = URL(string: "itms-apps://itunes.apple.com/app/id1441336649"),
                                UIApplication.shared.canOpenURL(url)
                            {
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                    exit(0);

                                } else {
                                    UIApplication.shared.openURL(url)
                                    exit(0);

                                }
                            }
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

extension TableCaptacoesVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedList = listaCaptacoes.filter({$0.nome!.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.placa!.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.ano_modelo!.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.modelo_veiculo!.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
    
    
   
    
}

