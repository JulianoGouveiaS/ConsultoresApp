//
//  PropostasEnviadasVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 05/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD


class PropostasEnviadasVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dataInfosCliente = [String]()
    var alamofireManager: Alamofire.SessionManager?
    let verdeStatus = UIColor(red: 51, green: 153, blue: 51)
    var cpf: String! = KeychainWrapper.standard.string(forKey: "CPF")
    var id: Int! = KeychainWrapper.standard.integer(forKey: "ID")!
    var statusAUX: String!
    
    var propostasArray = [PropostaInfo]()
    var urlARR = [String]()
    let swipeRightRec = UISwipeGestureRecognizer()
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchedList = [PropostaInfo]()
    var searching = false
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            self?.PropostasLista(id_user: (self?.id!)!)

            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        //declarando swipe voltar
        searchBar.delegate = self
        tableView.keyboardDismissMode = .interactive
        KRProgressHUD.show(withMessage: "Carregando Propostas...", completion: nil)
        
        PropostasLista(id_user: id!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        
    }
    
    deinit {
        tableView.dg_removePullToRefresh()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchedList.count
        } else {
            return propostasArray.count
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula_reuso", for: indexPath) as! CelulaInfoPropostas
        
        if searching {
            let dadoCelula = searchedList[indexPath.row]
            
            
            celula.nomeLabel.text = String(describing: dadoCelula.nome!)
            celula.cpfLabel.text = "CPF: \(dadoCelula.cpf!)"
            celula.infosLabel.text = "id: \(dadoCelula.id!) / placa: \(dadoCelula.placa!) / Criado em:\(dadoCelula.created_at!)"
            tableView.rowHeight = 102
            return celula
        }else{
            let dadoCelula = propostasArray[indexPath.row]
            
            
            celula.nomeLabel.text = String(describing: dadoCelula.nome!)
            celula.cpfLabel.text = "CPF: \(dadoCelula.cpf!)"
            celula.infosLabel.text = "Id: \(dadoCelula.id!) / Tipo: \(getSEGURObyID(id_tp_SEGURO: dadoCelula.tp_seguro ?? 0)) / Criado em:\(dadoCelula.created_at!)"
            tableView.rowHeight = 102
            return celula
        }
       
        
    }
    
    
    
    func PropostasLista(id_user: Int) {
        
        let parameters =  [
            "id_user": id_user
        ]
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 15
        self.alamofireManager = Alamofire.SessionManager(configuration: configuration)
        
        //comeca a acao de carregamento
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            
            //Fazendo o resquest no servidor
            self.alamofireManager!.request(URL(string: "https://sevenprotecaoveicular.com.br/Api/RecuperaEnviadosIos")!, method: .post, parameters: parameters, encoding: URLEncoding.default ).responseJSON { (response) in
                
                
                //Validando o resultado obtido
                switch response.result {
                //Caso tenha recebido uma resposta
                case .success(let value):
                    
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    let resultado = response.result
                    print("resultado: \(resultado)")
                    if let dict = resultado.value as? Dictionary<String,AnyObject>{
                        
                        if let infoPropostas = dict["user_data"]{
                            
                            if let array: [Dictionary<String,Any>] = infoPropostas as?  [Dictionary<String,Any>]{
                                print("array\(array)")
                                
                                self.propostasArray = array.map {
                                    PropostaInfo (dictionary: $0)
                                }
                                self.tableView.reloadData()
                                
                            }
                        }
                    }
                    
                    
                    //  KRProgressHUD.dismiss()
                    KRProgressHUD.showSuccess(withMessage: "Sucesso!")
                    //  }
                    
                case .failure(let error):
                    KRProgressHUD.dismiss()
                    KRProgressHUD.showError()
                    KRProgressHUD.showMessage("Erro!")
                    
                    if error._code == NSURLErrorTimedOut {
                        
                        self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Sua conexão caiu ou está instável!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                        print("erro 1")
                        
                    }else{
                        
                        self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Erro em captar propostas! Serviço indisponivel temporiariamente.", acaoAlerta: "OK", erroRecebido: "\(error)")
                        print("erro: \(error)")
                        
                    }
                    
                } //SWITCH
                
            } //RESPONSE JSON
        } //acao de carregamento
    } //FUNC
    
    
    func getSTATUSbyID(idStatus: Int) -> String{
        var statusString: String = ""
        print("idstatus:")
        if idStatus == 1{
            statusString = "APROVADO"
        } else if idStatus == 2{
            statusString = "REENVIADO"
        } else if idStatus == 3{
            statusString = "PENDENTE"
        } else if idStatus == 4{
            statusString = "ENVIAR FOTOS"
        } else if idStatus == 5{
            statusString = "ENVIADO"
        } else if idStatus == 6{
            statusString = "AGUARDANDO"
        } else if idStatus == 7{
            statusString = "INATIVO"
        } else if idStatus == 8{
            statusString = "INADIMPLENTE"
        } else if idStatus == 9{
            statusString = "NEGADO"
        } else if idStatus == 10{
            statusString = "MIGRANDO"
        } else if idStatus == 11{
            statusString = "ENVIADA PARA VISTORIA"
        } else if idStatus == 12{
            statusString = "ENVIADA PARA VISTORIADOR"
        } else if idStatus == 13{
            statusString = "VISTORIA PENDENTE"
        } else if idStatus == 14{
            statusString = "VISTORIA REALIZADA"
        } else if idStatus == 15{
            statusString = "VISTORIA APROVADA"
        } else if idStatus == 16{
            statusString = "VISTORIA REPROVADA"
        } else if idStatus == 0{
            statusString = "Selecione o Status"
        }
        return statusString
    }
    
    func getCORbyID(idCor: Int) -> String{
        var corString: String = ""
        if idCor == 1{
            corString = "PRETO"
        } else if idCor == 2{
            corString = "BRANCO"
        } else if idCor == 3{
            corString = "AZUL"
        } else if idCor == 4{
            corString = "VERMELHO"
        } else if idCor == 5{
            corString = "VERDE"
        } else if idCor == 6{
            corString = "CINZA"
        } else if idCor == 7{
            corString = "BEGE"
        } else if idCor == 8{
            corString = "AMARELO"
        } else if idCor == 9{
            corString = "PRATA"
        } else if idCor == 10{
            corString = "NÃO ESPECIFICADO"
        } else if idCor == 11{
            corString = "DOURADO"
        } else if idCor == 12{
            corString = "LARANJA"
        } else if idCor == 13{
            corString = "MARROM"
        } else if idCor == 14{
            corString = "FANTASIA"
        } else if idCor == 15{
            corString = "ROXO"
        } else if idCor == 16{
            corString = "ROSA"
        } else if idCor == 17{
            corString = "OUTRO"
        } else if idCor == 0{
            corString = "INFORME A COR"
        }
        return corString
    }
    
    func getCOMBUSTIVELbyID(idComb: Int) -> String{
        
        var combString: String = ""
        
        if idComb == 1{
            combString = "FLEX"
        } else if idComb == 2{
            combString = "GASOLINA"
        } else if idComb == 3{
            combString = "ETANOL"
        } else if idComb == 4{
            combString = "DIESEL"
        } else if idComb == 5{
            combString = "BIO-GÁS"
        } else if idComb == 6{
            combString = "TETRA-FUEL"
        } else if idComb == 7{
            combString = "NÃO INFORMADO"
        } else if idComb == 0{
            combString = "Selecione o tipo do combustível"
        }
        
        return combString
    }
    
    func getTABELAbyID(idTabela: Int) -> String{
        
        var idTabelaString: String = ""
        print("idTabela: \(idTabela)")
        if idTabela == 1{
            idTabelaString = "AUTOMÓVEL LEVE/PICK UP"
        } else if idTabela == 2{
            idTabelaString = "CAMINHONETE"
        } else if idTabela == 3{
            idTabelaString = "Vans / Meio Pesado"
        } else if idTabela == 4{
            idTabelaString = "Motocicletas"
        } else if idTabela == 5{
            idTabelaString = "TODOS OS TIPOS ESPECIASI"
        } else if idTabela == 6{
            idTabelaString = "TABELA ESPECIAL 5"
        } else if idTabela == 7{
            idTabelaString = "TABELA ESPECIAL 6"
        } else if idTabela == 0{
            idTabelaString = "Selecione"
        }
        
        return idTabelaString
    }
    
    
    
    func getSEGURObyID(id_tp_SEGURO: Int) -> String{
        var tp_seguroString: String = ""
        
        if id_tp_SEGURO == 3{
            tp_seguroString = "Reativação"
        } else  if id_tp_SEGURO == 2{
            tp_seguroString = "Substituição"
        } else{
            tp_seguroString = "Adesão"
            
        }
        return tp_seguroString
        
    }
    
    func getVEICULObyID(id_tp_VEIC: Int) -> String{
        var tp_veicString: String = ""
        
        if id_tp_VEIC == 3{
            tp_veicString = "Caminhão"
        } else if id_tp_VEIC == 2{
            tp_veicString = "Moto"
        } else if id_tp_VEIC == 1{
            tp_veicString = "Carro"
        }else{
            tp_veicString = "Selecione"
            
        }
        return tp_veicString
    }
    
  
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dadoCelula = propostasArray[indexPath.row]
        KRProgressHUD.show()
        self.DadosLista(cpf: dadoCelula.cpf!, selectedRow: indexPath.row, dadoCelula: dadoCelula)
        
    }
    
    func DadosLista(cpf: String, selectedRow: Int, dadoCelula: PropostaInfo ) {
        //Parametros a serem passados via PHP
        let parameters =  [
            "cpf": cpf
        ]
        
        let configuracao = URLSessionConfiguration.default
        //6 - configurando o tempo de chamada
        configuracao.timeoutIntervalForRequest = 13 //em segundos
        //7 - tempo de resposta
        configuracao.timeoutIntervalForResource = 13 // em segundos
        
        self.alamofireManager = Alamofire.SessionManager(configuration: configuracao)
        
        //comeca a acao de carregamento
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            
            //Fazendo o resquest no servidor
            self.alamofireManager!.request(URL(string: "https://www.sevenprotecaoveicular.com.br/Api/ExibeClientes")!, method: .post, parameters: parameters, encoding: URLEncoding.default ).responseJSON { (response) in
                //Validando o resultado obtido
                switch response.result {
                //Caso tenha recebido uma resposta
                case .success(let value):
                    
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CollapsibleViewController") as! CollapsibleViewController
                    
                    
                    let userNome = json["user_data"][0]["nome"].stringValue
                    let userRg = json["user_data"][0]["rg"].stringValue
                    let userNasc = json["user_data"][0]["dt_nascimento"].stringValue
                    let userCpf = json["user_data"][0]["documento"].stringValue
                    let userCnh = json["user_data"][0]["cnh"].stringValue
                    let userCep = json["user_data"][0]["cep"].stringValue
                    let userRegional = json["user_data"][0]["uf"].stringValue
                    let userCidade = json["user_data"][0]["cidade"].stringValue
                    let userBairro = json["user_data"][0]["bairro"].stringValue
                    let userRua = json["user_data"][0]["logradouro"].stringValue
                    let userNumero = json["user_data"][0]["numero"].stringValue
                    let userComplemento = json["user_data"][0]["complemento"].stringValue
                    let userMae = json["user_data"][0]["nome_mae"].stringValue
                    let userTel = json["user_data"][0]["num_telefone"].stringValue
                    let userCel = json["user_data"][0]["num_cell"].stringValue
                    
                    
                    vc.dataProposta.append("Oculto")
                    vc.dataProposta.append(userRg)
                    vc.dataProposta.append(userNasc)
                    vc.dataProposta.append(userCpf)
                    vc.dataProposta.append(userCnh)
                    vc.dataProposta.append(userCep)
                    vc.dataProposta.append(userRegional)
                    vc.dataProposta.append(userCidade)
                    vc.dataProposta.append(userBairro)
                    vc.dataProposta.append(userRua)
                    vc.dataProposta.append(userNumero)
                    vc.dataProposta.append(userComplemento)
                    vc.dataProposta.append(userMae)
                    vc.dataProposta.append("Oculto")
                    vc.dataProposta.append("Oculto")
                    
                    let tipoSeguro: String = self.getSEGURObyID(id_tp_SEGURO: dadoCelula.tp_seguro!)
                    vc.dataProposta.append(tipoSeguro)
                    let statusStr: String = self.getSTATUSbyID(idStatus: dadoCelula.situacao!)
                    vc.dataProposta.append(statusStr)
                    vc.dataProposta.append(dadoCelula.dt_vistoria!)
                    vc.dataProposta.append("Oculto")
                    vc.placaEscolhida = dadoCelula.placa!
                    let tabelaStr: String = self.getTABELAbyID(idTabela: dadoCelula.tp_veic!)
                    vc.dataProposta.append(tabelaStr)
                    let tipo_veic: String = self.getVEICULObyID(id_tp_VEIC: dadoCelula.tp_veic!)
                    vc.dataProposta.append(tipo_veic)
                    vc.dataProposta.append(dadoCelula.marca!)
                    vc.dataProposta.append(dadoCelula.modelo!)
                    vc.dataProposta.append(dadoCelula.ano_fab!)
                    vc.dataProposta.append(dadoCelula.ano_modelo!)
                    vc.dataProposta.append(dadoCelula.cod_fipe!)
                    vc.dataProposta.append(dadoCelula.valor_veic!)
                    vc.dataProposta.append(dadoCelula.renavam!)
                    vc.dataProposta.append(dadoCelula.dt_contrato!)
                    vc.dataProposta.append(dadoCelula.chassi!)
                    let corString: String = self.getCORbyID(idCor: dadoCelula.cor!)
                    vc.dataProposta.append(corString)
                    let combString: String = self.getCOMBUSTIVELbyID(idComb: dadoCelula.combustivel!)
                    vc.dataProposta.append(combString)
                    vc.dataProposta.append(dadoCelula.obs!)
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    KRProgressHUD.dismiss()
                    
                case .failure(let error):
                    KRProgressHUD.showMessage("Erro!")
                    
                    print(error)
                    
                    if error._code == NSURLErrorTimedOut {
                        
                        self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Sua conexão caiu ou está instável!", acaoAlerta: "Okay", erroRecebido: "\(error)")
                    }else{
                        
                        self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Erro em captar as informações do usuario!", acaoAlerta: "Okay", erroRecebido: "\(error)")
                    }//else
                    
                    
                } //SWITCH
            } //RESPONSE JSON
        }//acao carregamento
        
    } //FUNC LOGIN
    
}//main

extension PropostasEnviadasVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedList = propostasArray.filter({$0.nome!.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.placa!.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.cpf!.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.created_at!.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
    
}
