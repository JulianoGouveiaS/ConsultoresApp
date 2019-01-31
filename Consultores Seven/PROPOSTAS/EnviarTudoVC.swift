//
//  EnviarTudoVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 22/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import KRProgressHUD
import FirebaseFirestore
import Alamofire
import SwiftyJSON
import SwiftyPickerPopover

class EnviarTudoVC: UIViewController {
    var alamoFireManager : SessionManager?
    @IBOutlet weak var okAssociado: UILabel!
    @IBOutlet weak var okVeiculo: UILabel!
    @IBOutlet weak var okImagens: UILabel!
    
    @IBOutlet weak var prosseguirBttn: UIButton!
    @IBOutlet weak var reloadBttn: UIButton!
    
    var rastreador = false
    
    var propostaEscolhida: Proposta!
  
    
    let cpf_user = KeychainWrapper.standard.string(forKey: "CPF")
    let id_user = KeychainWrapper.standard.integer(forKey: "ID")
    let nome_user = KeychainWrapper.standard.string(forKey: "NOME")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            self.okAssociado.isHidden = true
            self.okVeiculo.isHidden = true
            self.okImagens.isHidden = true
        
            self.reloadBttn.isHidden = true
            self.prosseguirBttn.isEnabled = false
        EnviaVoluntario()
    }
    
    
    func EnviaVoluntario() {
        
        KRProgressHUD.show()
        let db = Firestore.firestore()
        
        db.collection("ConsultorSeven").document("MinhasPropostas").collection("\(self.id_user!)").document("\(self.propostaEscolhida.id!)").getDocument { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                let dictionary = querySnapshot!.data()
                
                
                let parameters = [
                    "id_voluntario": "\(self.id_user!)",
                    "nome": dictionary!["nome"] as! String,
                    "documento": dictionary!["cpfcnpj"] as! String,
                    "rg": dictionary!["rg"] as! String,
                    "dt_nascimento": dictionary!["dtnasc"] as! String,
                    "email": dictionary!["email"] as! String,
                    "num_cell": dictionary!["celular"] as! String,
                    "num_telefone": dictionary!["telefone"] as! String,
                    "cnh": dictionary!["cnh"] as! String,
                    "nome_mae": dictionary!["mae"] as! String,
                    "dt_contrato": dictionary!["dtproposta"] as! String,
                    "cep": dictionary!["cep"] as! String,
                    "uf": dictionary!["uf"] as! String,
                    "cidade": dictionary!["cidade"] as! String,
                    "bairro": dictionary!["bairro"] as! String,
                    "logradouro": dictionary!["logradouro"] as! String,
                    "numero": dictionary!["num_residencia"] as! String,
                    "complemento": dictionary!["complemento"] as! String,
                    "id_proposta": "",
                    "id_classificacao": "1",
                    "sexo": dictionary!["sexo"] as! String
                    ] as [String : Any]
                
                let configuration = URLSessionConfiguration.default
                configuration.timeoutIntervalForRequest = 90000
                configuration.timeoutIntervalForResource = 90000 // seconds
                var alamofireManager : Alamofire.SessionManager?
                alamofireManager = Alamofire.SessionManager(configuration: configuration)
                
                let url = "https://www.sevenprotecaoveicular.com.br/Api/CadastroAssociado"
                Alamofire.request(url, method:.post, parameters:parameters,encoding: JSONEncoding.default).responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        print("parametros cad ass: \(parameters)")
                        if json["user_data"]["id"].int == 0{
                            self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Usuário não encontrado!", acaoAlerta: "Ok", erroRecebido: "json[user_data][id].int retornou 0")
                            
                            KRProgressHUD.dismiss()
                        }else{
                            self.okAssociado.isHidden = false
                            print("enviou voluntario, id: \(json["user_data"]["id"].int!)")
                            self.enviaVeiculo(idCliente: json["user_data"]["id"].int!, dictionary: dictionary!)
                        }
                        
                    case .failure(let error):
                        KRProgressHUD.dismiss()
                        print(error)
                        
                        self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Erro ao enviar associado!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                    }
                }
            }
        }
    }
    func enviaVeiculo(idCliente: Int, dictionary: [String:Any]){
        var danosTerc: String!
        if dictionary["danosterceiros"] as? Bool == true{
            if (dictionary["ddltabelaa"] as? Int) == 3{
                danosTerc = "3"
            }else{ danosTerc = "1" }
            
        }else{ danosTerc = "2" }
        
        var coPartic: String!
        if dictionary["coparticipacaored"] as? Bool == true{
            if (dictionary["ddltabelaa"] as? Int) == 3{
                coPartic = "3"
            }else{ coPartic = "1" }
        }else{ coPartic = "2" }
        
        var Providros: String!
        if dictionary["protvidro"] as? Bool == true{
            Providros = "1"
        }else{ Providros = "2" }
        
        var carroReserva15: String!
        if (dictionary["ddltabelaa"] as? Int) != 3{
            if (dictionary["carres15"] as? Bool) == true{
                carroReserva15 = "1"
            }else{ carroReserva15 = "2" }
        }
        
        var carroReserva30: String!
        if (dictionary["ddltabelaa"] as? Int) != 3{
            if (dictionary["carres30"] as? Bool) == true{
                carroReserva30 = "1"
            }else{ carroReserva30 = "2" }
        }
        
        var IsUber: String!
         if (dictionary["uber"] as? Bool) == true{
            IsUber = "1"
        }else{ IsUber = "2" }
        
        var pctPrem15: String!
        if (dictionary["pctpremio15"] as? Bool) == true{
           if (dictionary["ddltabelaa"] as? Int) == 3 || (dictionary["ddltabelaa"] as? Int) == 2 || (dictionary["ddltabelaa"] as? Int) == 4 {
                pctPrem15 = "3"
            }else if (dictionary["ddltabelaa"] as? Int) == 5 || (dictionary["ddltabelaa"] as? Int) == 6 {
                pctPrem15 = "1"
            }else{
                pctPrem15 = "4"
            }
        }else{pctPrem15 = "2"}
        
        var pctPrem30: String!
       if (dictionary["pctpremio30"] as? Bool) == true{
            if (dictionary["ddltabelaa"] as? Int) == 3{
                pctPrem30 = "3"
            }else{
                pctPrem30 = "1"
            }
            
        }else{pctPrem30 = "2"}
        
        
        var kms: String!
        if (dictionary["km500"] as? Bool) == true{
            if (dictionary["ddltabelaa"] as? Int) == 3{
                kms = "5"
            }else{ kms = "2" }
            
        }else if (dictionary["km700"] as? Bool) == true{
            kms = "3"
        }else if (dictionary["km1000"] as? Bool) == true{
            kms = "1"
        }else{ kms = "2" }
        
        var rastreador = "0"
        self.rastreador = ((dictionary["rastreadorparceirosv"] as? Bool)!)
        if (dictionary["rastreadorparceirosv"] as? Bool) == true{
            rastreador = "1"
            
        }else{
            rastreador = "0"
        }
        
        let parameters = [
            
            "id_voluntario": "\(String(describing: self.id_user!))",
            "id_cliente": "\(String(describing: idCliente))",
            "cod_fipe": (dictionary["fipe"] as! String),
            "ano_fb": (dictionary["anofabricacao"] as! String),
            "ano_modelo": (dictionary["anomodelo"] as! String),
            "id_combustivel": (dictionary["combustivel"] as! String),
            "placa": (dictionary["placa"] as! String),
            "renavam": (dictionary["renavam"] as! String),
            "chassi": (dictionary["chassi"] as! String),
            "id_cor": (dictionary["cor"] as! String),
            "id_vistoria": "1",
            "dt_vistoria": (dictionary["dtvistoria"] as! String),
            "vl_adesao": (dictionary["valoradesao"] as! String),
            "tabela": (dictionary["dlltabelaa"] as! String),
            "id_cota": "1",
            "valor": (dictionary["valorveiculo"] as! String),
            "vl_mensal": (dictionary["valormensal"] as! String),
            "id_classificacao_v": "1",
            "chkdanos": "\(danosTerc!)",
            "copr1": "\(coPartic!)",
            "providros": "\(Providros!)",
            "rastreadorchk": rastreador,
            "carres": "\(carroReserva15!)",
            "carres30": "\(carroReserva30!)",
            "p_premio": "\(pctPrem15!)",
            "p_premio2": "\(pctPrem30!)",
            "kms": "\(kms!)",
            "txtobs": dictionary["obs"] as! String,
            "tp_seguro": dictionary["seguro"] as! String,
            "tipo_veiculo": (dictionary["tpveiculo"] as! String),
            "token": "8888",
            "uber": "\(IsUber!)",
            "dt_contrato": (dictionary["dtproposta"] as! String),
            "id_classificacao": "1",
            "sexo": (dictionary["sexo"] as! String),
            ] as [String : Any]
        
        
        let url = "https://www.sevenprotecaoveicular.com.br/Api/CadastroVeiculo"
        Alamofire.request(url, method:.post, parameters:parameters,encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                print("parameters enviados no veiculo: \(parameters)")
                if json["user_data"]["id"].stringValue == "0"{
                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Veículo não encontrado!", acaoAlerta: "Ok", erroRecebido: "id do veiculo retornou 0")
                    
                    KRProgressHUD.dismiss()
                }else{
                    self.okVeiculo.isHidden = false
                    print("enviou veiculo")
                    
                    
                    let idVeiculo = json["user_data"]["id"].int
                    print("idVeiculo: \(String(describing: idVeiculo))")
                    
                    self.enviaFotos(idVeiculo: idVeiculo!, idVoluntario: self.id_user!)
                    
                    
                }
                
            case .failure(let error):
                KRProgressHUD.dismiss()
               
                print(error)
    
                self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Erro ao enviar veículo!", acaoAlerta: "Ok", erroRecebido: "\(error)")
            }
        }
    }
    
  
    func enviaFotos(idVeiculo: Int, idVoluntario: Int){
        
        let db = Firestore.firestore()
        let docRef = db.collection("ConsultorSeven").document("FotosPropostas").collection("\(self.id_user!)").document("\(self.propostaEscolhida.id!)").getDocument { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                        let dictionary = querySnapshot!.data()
                        KRProgressHUD.show()
                        print("query recebida fotos =>", dictionary)
                        
                        var parameters: [String : Any]!
                
                  parameters = [
                       "id_voluntario":            "\(idVoluntario)",
                       "id_veiculo":               "\(idVeiculo)",
                       "vistoria":                  self.getNomeFotoPelaUrl(urlFirebase: dictionary?["vistoria_str"] as? String ?? ""),
                       "proposta":                  self.getNomeFotoPelaUrl(urlFirebase: dictionary!["proposta_st"] as? String ?? ""),
                       "doc1":                      self.getNomeFotoPelaUrl(urlFirebase: dictionary!["doc1_st"] as? String ?? ""),
                       "doc2":                      self.getNomeFotoPelaUrl(urlFirebase: dictionary!["doc2_st"] as? String ?? ""),
                       "doc3":                      self.getNomeFotoPelaUrl(urlFirebase: dictionary!["doc3_st"] as? String ?? ""),
                       "doc4":                      self.getNomeFotoPelaUrl(urlFirebase: dictionary!["doc4_st"] as? String ?? ""),
                       "dut":                       self.getNomeFotoPelaUrl(urlFirebase: dictionary!["dut_st"] as? String ?? ""),
                       "rastreador":                self.getNomeFotoPelaUrl(urlFirebase: dictionary!["rasteador_st"] as? String ?? ""),
                       "frontal1":                  self.getNomeFotoPelaUrl(urlFirebase: dictionary!["fronta1_st"] as? String ?? ""),
                       "frontal2":                  self.getNomeFotoPelaUrl(urlFirebase: dictionary!["fronta2_st"] as? String ?? ""),
                       "lat1":                      self.getNomeFotoPelaUrl(urlFirebase: dictionary!["lat1_st"] as? String ?? ""),
                       "lat2":                      self.getNomeFotoPelaUrl(urlFirebase: dictionary!["lat2_st"] as? String ?? ""),
                       "lat3":                      self.getNomeFotoPelaUrl(urlFirebase: dictionary!["lat3_st"] as? String ?? ""),
                       "lat4":                      self.getNomeFotoPelaUrl(urlFirebase: dictionary!["lat4_st"] as? String ?? ""),
                       "traseira":                  self.getNomeFotoPelaUrl(urlFirebase: dictionary!["traseira_st"] as? String ?? ""),
                       "portamalas":                self.getNomeFotoPelaUrl(urlFirebase: dictionary!["p_malas_st"] as? String ?? ""),
                       "teto":                      self.getNomeFotoPelaUrl(urlFirebase: dictionary!["teto_st"] as? String ?? ""),
                       "motor":                     self.getNomeFotoPelaUrl(urlFirebase: dictionary!["motor_st"] as? String ?? ""),
                       "chassift":                  self.getNomeFotoPelaUrl(urlFirebase: dictionary!["chassi_st"] as? String ?? ""),
                       "veloc":                     self.getNomeFotoPelaUrl(urlFirebase: dictionary!["veloc_st"] as? String ?? ""),
                       "esto1":                     self.getNomeFotoPelaUrl(urlFirebase: dictionary!["esto1_st"] as? String ?? ""),
                       "esto2":                     self.getNomeFotoPelaUrl(urlFirebase: dictionary!["esto2_st"] as? String ?? ""),
                       "esto3":                     self.getNomeFotoPelaUrl(urlFirebase: dictionary!["esto3_st"] as? String ?? ""),
                       "esto4":                     self.getNomeFotoPelaUrl(urlFirebase: dictionary!["esto4_st"] as? String ?? ""),
                       "lanterna1":                 self.getNomeFotoPelaUrl(urlFirebase: dictionary!["lanterna1_st"] as? String ?? ""),
                       "lanterna2":                 self.getNomeFotoPelaUrl(urlFirebase: dictionary!["lanterna2_st"] as? String ?? ""),
                       "farois1":                   self.getNomeFotoPelaUrl(urlFirebase: dictionary!["farol1_st"] as? String ?? ""),
                       "farois2":                   self.getNomeFotoPelaUrl(urlFirebase: dictionary!["farol2_st"] as? String ?? ""),
                       "pneus1":                    self.getNomeFotoPelaUrl(urlFirebase: dictionary!["pneu1_st"] as? String ?? ""),
                       "pneus2":                    self.getNomeFotoPelaUrl(urlFirebase: dictionary!["pneu2_st"] as? String ?? ""),
                       "pneus3":                    self.getNomeFotoPelaUrl(urlFirebase: dictionary!["pneu3_st"] as? String ?? ""),
                       "pneus4":                    self.getNomeFotoPelaUrl(urlFirebase: dictionary!["pneu4_st"] as? String ?? ""),
                       "pneus5":                    self.getNomeFotoPelaUrl(urlFirebase: dictionary!["pneu5_st"] as? String ?? ""),
                       "pneus6":                    self.getNomeFotoPelaUrl(urlFirebase: dictionary!["pneu6_st"] as? String ?? ""),
                       "vidros1":                   self.getNomeFotoPelaUrl(urlFirebase: dictionary!["vidro1_st"] as? String ?? ""),
                       "vidros2":                   self.getNomeFotoPelaUrl(urlFirebase: dictionary!["vidro2_st"] as? String ?? ""),
                       "vidros3":                   self.getNomeFotoPelaUrl(urlFirebase: dictionary!["vidro3_st"] as? String ?? ""),
                       "vidros4":                   self.getNomeFotoPelaUrl(urlFirebase: dictionary!["vidro4_st"] as? String ?? ""),
                       "vidros5":                   self.getNomeFotoPelaUrl(urlFirebase: dictionary!["vidro5_st"] as? String ?? ""),
                       "vidros6":                   self.getNomeFotoPelaUrl(urlFirebase: dictionary!["vidro6_st"] as? String ?? ""),
                       "vidros7":                   self.getNomeFotoPelaUrl(urlFirebase: dictionary!["vidro7_st"] as? String ?? ""),
                       "vidros8":                   self.getNomeFotoPelaUrl(urlFirebase: dictionary!["vidro8_st"] as? String ?? ""),
                       "vidros9":                   self.getNomeFotoPelaUrl(urlFirebase: dictionary!["vidro9_st"] as? String ?? ""),
                       "vidros10":                  self.getNomeFotoPelaUrl(urlFirebase: dictionary!["vidro10_st"] as? String ?? ""),
                       "vidros11":                  self.getNomeFotoPelaUrl(urlFirebase: dictionary!["vidro11_st"] as? String ?? ""),
                       "vidros12":                  self.getNomeFotoPelaUrl(urlFirebase: dictionary!["vidro12_st"] as? String ?? ""),
                       "avarias1":                  self.getNomeFotoPelaUrl(urlFirebase: dictionary!["avaria1_st"] as? String ?? ""),
                       "avarias2":                  self.getNomeFotoPelaUrl(urlFirebase: dictionary!["avaria2_st"] as? String ?? ""),
                       "avarias3":                  self.getNomeFotoPelaUrl(urlFirebase: dictionary!["avaria3_st"] as? String ?? ""),
                       "avarias4":                  self.getNomeFotoPelaUrl(urlFirebase: dictionary!["avaria4_st"] as? String ?? ""),
                       "avarias5":                  self.getNomeFotoPelaUrl(urlFirebase: dictionary!["avaria5_st"] as? String ?? ""),
                       "avarias6":                  self.getNomeFotoPelaUrl(urlFirebase: dictionary!["avaria6_st"] as? String ?? ""),
                       "avarias7":                  self.getNomeFotoPelaUrl(urlFirebase: dictionary!["avaria7_st"] as? String ?? ""),
                       "avarias8":                  self.getNomeFotoPelaUrl(urlFirebase: dictionary!["avaria8_st"] as? String ?? ""),
                       "avarias9":                  self.getNomeFotoPelaUrl(urlFirebase: dictionary!["avaria9_st"] as? String ?? ""),
                       "avarias10":                 self.getNomeFotoPelaUrl(urlFirebase: dictionary!["avaria10_st"] as? String ?? "")
                      ] as [String : Any]
                                    
                
                        KRProgressHUD.show()
                let configuration = URLSessionConfiguration.default
                configuration.timeoutIntervalForRequest = 90000
                configuration.timeoutIntervalForResource = 90000
                self.alamoFireManager = Alamofire.SessionManager(configuration: configuration)
              
                        let url = "https://www.sevenprotecaoveicular.com.br/Api/CadastroFotos"
                let req = self.alamoFireManager!.request(url, method:.post, parameters:parameters,encoding: JSONEncoding.default)
                       
                        req.responseJSON { response in
                            
                            switch response.result {
                            case .success(let value):
                                
                                let json = JSON(value)
                                print("JSON: \(json)")
                                
                                if json["user_data"]["id"].stringValue == "0"{
                                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Veículo não encontrado!", acaoAlerta: "Ok", erroRecebido: "json[user_data][id].stringValue retornou 0")
                                    
                                    KRProgressHUD.dismiss()
                                }else{
                                    if self.rastreador == true{
                                         self.mudaSituacaoProposta(status: "5", motivo: "", popostaEscolhida: self.propostaEscolhida, id_user: self.id_user!)
                                        
                                    }else{
                                         self.mudaSituacaoProposta(status: "3", motivo: "", popostaEscolhida: self.propostaEscolhida, id_user: self.id_user!)
                                    }
                                   
                                    print("parameters: \(parameters)")
                                    print("enviou fotos")
                                    self.okImagens.isHidden = false
                                    self.prosseguirBttn.isEnabled = true
                                    
                                    KRProgressHUD.dismiss()
                                  
                                }
                               
                                
                            case .failure(let error):
                                KRProgressHUD.dismiss()
                                self.reloadBttn.isHidden = false
                                print(error)
                            self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Para completar o envio das fotos restantes, clique no botão de reenvio. Erros podem ocorrer caso a internet não envie todas as fotos no tempo estabelecido.", acaoAlerta: "Ok", erroRecebido: "\(error)")
                                
                    }
                }
                
            }
        }
    }
    
    @IBAction func continuarClick(sender: Any?){
       
            if let tabViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarPrincipal") as? TabBarPrincipal {
                tabViewController.selectedIndex = 2
                
                navigationController?.pushViewController(tabViewController, animated: true)
            }
        
        
    }
    
    @IBAction func reloadClick(sender: Any?){
        
        self.okAssociado.isHidden = true
        self.okVeiculo.isHidden = true
        self.okImagens.isHidden = true
        self.reloadBttn.isHidden = true
        
        self.prosseguirBttn.isEnabled = false
        self.EnviaVoluntario()
    }
}
