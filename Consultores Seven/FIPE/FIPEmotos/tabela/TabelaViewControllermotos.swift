//
//  TabelaViewController.swift
//  SevenPV
//
//  Created by Juliano Gouveia on 23/02/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD
import AIFlatSwitch

class TabelaViewControllermotos: UIViewController {
     @IBOutlet weak var scrollView: UIScrollView!
    var alamofireManager : Alamofire.SessionManager?
   
    var id_tabela:Int!
    @IBOutlet weak var Danos_terceirosSwitch: AIFlatSwitch!
    
    @IBOutlet weak var COparticipacaoSwitch: AIFlatSwitch!
    @IBOutlet weak var prot_vidrosSwitch: AIFlatSwitch!
    @IBOutlet weak var carroReserva15Switch: AIFlatSwitch!
    @IBOutlet weak var carroReserva30Switch: AIFlatSwitch!
    @IBOutlet weak var uberSwitch: AIFlatSwitch!
    @IBOutlet weak var pacote_premio15Switch: AIFlatSwitch!
    @IBOutlet weak var pacote_premio30Switch: AIFlatSwitch!
    @IBOutlet weak var cartao_premioSwitch: AIFlatSwitch!
    @IBOutlet weak var km_500Switch: AIFlatSwitch!
    @IBOutlet weak var km_700Switch: AIFlatSwitch!
    @IBOutlet weak var km_1000Switch: AIFlatSwitch!

    var id: Int!
    var modelo: Int!
    var codigo: Int!
    
    var id_ano: Int?
    var codigo_modelo: Int?
    var codigo_fipe: String?
    var ano: String?
    var combustivel: String?
    var valor: String?
    var marca: String?
    var franquia: String?
    var valor_mes: String?
    var tabela: String?
    
    @IBOutlet weak var tabela1: UIView!
    @IBOutlet weak var valorLabel: UILabel!
    @IBOutlet weak var valor_mesLabel: UILabel!
    @IBOutlet weak var codigo_FIPELabel: UILabel!
    @IBOutlet weak var veiculoLabel: UILabel!
    @IBOutlet weak var marcaLabel: UILabel!
     @IBOutlet weak var combustivelLabel: UILabel!
    @IBOutlet weak var anoLabel: UILabel!
    @IBOutlet weak var tabelaLabel: UILabel!
    @IBOutlet weak var franquiaLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        KRProgressHUD.show(withMessage: "Carregando Tabela...", completion: nil)
        CarregaTabela()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func CarregaTabela() {
      
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 12
        configuration.timeoutIntervalForResource = 12
        self.alamofireManager = Alamofire.SessionManager(configuration: configuration)
        
        //comeca a acao de carregamento
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            
            //Fazendo o resquest no servidor
            self.alamofireManager!.request(URL(string: "https://www.sevenprotecaoveicular.com.br/Api/Recupemarca/motos/\(self.id!)/\(self.modelo!)/\(self.codigo!)")!, method: .get, parameters: nil, encoding: URLEncoding.default ).responseJSON { (response) in
                //Validando o resultado obtido
                switch response.result {
                //Caso tenha recebido uma resposta
                case .success(let value):
                 
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    self.id_ano = json["id_ano"].int
                    
                    self.codigo_modelo = json["codigo_modelo"].int
                    
                    self.codigo_fipe = json["codigo_fipe"].stringValue
                    self.codigo_FIPELabel.text = self.codigo_fipe
                    
                    self.ano = json["ano"].stringValue
                    self.anoLabel.text = self.ano
                    
                    self.combustivel = json["combustivel"].stringValue
                    self.combustivelLabel.text = self.combustivel
                    
                    self.valor = json["valor"].stringValue
                    self.valorLabel.text = self.valor
                    
                    self.marca = json["marca"].stringValue
                    self.marcaLabel.text = self.marca
                    
                    self.franquia = json["franquia"].stringValue
                    self.franquiaLabel.text = self.franquia
                    
                    
                    
                    self.tabela = json["tabela"].stringValue
                    self.tabelaLabel.text = self.tabela
                    
                    let veiculo = json["modelo"].stringValue
                    self.veiculoLabel.text = veiculo
                    
                    self.valor_mes = json["valor_mes"].stringValue
                    self.valor_mesLabel.text = String(describing: self.valor_mes!.doubleValue)
                    
                    self.id_tabela = self.Convertetabela(tabelaApi: json["tabela"].stringValue)
                    
                    KRProgressHUD.showSuccess()
                    
                case .failure(let error):
                    KRProgressHUD.dismiss()
                    KRProgressHUD.showError()
                    KRProgressHUD.showMessage("Erro!")
                    
                    print("Erro em captar as informações do veículo!")
                    
                    if error._code == NSURLErrorTimedOut {
                        
                        self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Sua conexão caiu ou está instável!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                    }else{
                        self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Erro em captar as informações do veículo!", acaoAlerta: "OK", erroRecebido: "\(error)")
                    }
                } //SWITCH
            } //RESPONSE JSON
        }//acao carregamento
        
    } //FUNC

  
    
   
    @IBAction func clicouCadastro(_ sender: Any) {
        
    }
    
    @IBAction func DanosTercClick(_ sender: Any) {
        print("id_tabela: \(id_tabela)")
        if self.id_tabela != 0{
                if Danos_terceirosSwitch.isSelected == true{
                    self.valor_mesLabel.text = String(self.valor_mesLabel.text!.doubleValue + 15.00)
                }else{
                    self.valor_mesLabel.text = String(self.valor_mesLabel.text!.doubleValue - 15.00)
                }
            }
    }
    
    @IBAction func COparticipacaoClick(_ sender: Any) {
        if self.id_tabela != 0{
            if self.id_tabela == 6 || self.id_tabela == 7{
                if COparticipacaoSwitch.isSelected == true{
                    self.valor_mesLabel.text = String(self.valor_mesLabel.text!.doubleValue + 30.00)
                }else{
                    self.valor_mesLabel.text = String(self.valor_mesLabel.text!.doubleValue - 30.00)
                }
            }else{
                if COparticipacaoSwitch.isSelected == true{
                    self.valor_mesLabel.text = String(self.valor_mesLabel.text!.doubleValue + 15.00)
                }else{
                    self.valor_mesLabel.text = String(self.valor_mesLabel.text!.doubleValue - 15.00)
                }
            }
        }
        
    }
    
    @IBAction func vidro80Click(_ sender: Any) {
        if self.id_tabela != 0 && self.id_tabela != 3{
            if prot_vidrosSwitch.isSelected == true{
                self.valor_mesLabel.text = String(self.valor_mesLabel.text!.doubleValue + 15.00)
            }else{
                self.valor_mesLabel.text = String(self.valor_mesLabel.text!.doubleValue - 15.00)
            }}
    }
    
    @IBAction func carroReserva15Click(_ sender: Any) {
        if self.id_tabela != 0{
            if self.id_tabela != 3{
                if carroReserva15Switch.isSelected == true{
                    self.valor_mesLabel.text = String(self.valor_mesLabel.text!.doubleValue + 15.00)
                }else{
                    self.valor_mesLabel.text = String(self.valor_mesLabel.text!.doubleValue - 15.00)
                }
            }
        }}
    
    @IBAction func carroReserva30Click(_ sender: Any) {
        if self.id_tabela != 0{
            if self.id_tabela != 3{
                if carroReserva30Switch.isSelected == true{
                    self.valor_mesLabel.text = String(self.valor_mesLabel.text!.doubleValue + 30.00)
                }else{
                    self.valor_mesLabel.text = String(self.valor_mesLabel.text!.doubleValue - 30.00)
                }
            }
        }}
    
    @IBAction func uberClick(_ sender: Any) {
        if self.id_tabela != 0{
            if uberSwitch.isSelected == true{
                self.valor_mesLabel.text =  String(self.valor_mesLabel.text!.doubleValue + 50.00)
            }else{
                self.valor_mesLabel.text = String(self.valor_mesLabel.text!.doubleValue - 50.00)
            }
        }}
    
    @IBAction func pct15Click(_ sender: Any) {
        if self.id_tabela != 0{
            if self.id_tabela == 1 || self.id_tabela == 2 || self.id_tabela == 1{
                
                if pacote_premio15Switch.isSelected == true{
                    self.valor_mesLabel.text =  String(self.valor_mesLabel.text!.doubleValue + 39.90)
                }else{
                    self.valor_mesLabel.text = String(self.valor_mesLabel.text!.doubleValue - 39.90)
                }
            } else if self.id_tabela == 5 || self.id_tabela == 6 {
                
                if pacote_premio15Switch.isSelected == true{
                    self.valor_mesLabel.text =  String(self.valor_mesLabel.text!.doubleValue + 54.90)
                }else{
                    self.valor_mesLabel.text = String(self.valor_mesLabel.text!.doubleValue - 54.90)
                }
                
            }
        }
    }
    
    @IBAction func pct30Click(_ sender: Any) {
        if self.id_tabela != 0{
            if self.id_tabela != 3 {
                if pacote_premio15Switch.isSelected == true{
                    self.valor_mesLabel.text = String(self.valor_mesLabel.text!.doubleValue + 69.90)
                }else{
                    self.valor_mesLabel.text = String(self.valor_mesLabel.text!.doubleValue - 69.90)
                }
            }
        }
    }
    
    @IBAction func cartaoClick(_ sender: Any) {
        if self.id_tabela != 0{
            if cartao_premioSwitch.isSelected == true{
                self.valor_mesLabel.text =  String(self.valor_mesLabel.text!.doubleValue + 20.00)
            }else{
                self.valor_mesLabel.text = String(self.valor_mesLabel.text!.doubleValue - 20.00)
            }}
    }
    
    @IBAction func km500Click(_ sender: Any) {
        if self.id_tabela != 0{
            if self.id_tabela == 3{
                if km_500Switch.isSelected == true{
                    self.valor_mesLabel.text =  String(self.valor_mesLabel.text!.doubleValue + 25.00)
                }else{
                    self.valor_mesLabel.text = String(self.valor_mesLabel.text!.doubleValue - 25.00)
                }
            }else{
                if km_500Switch.isSelected == true{
                    self.valor_mesLabel.text =  String(self.valor_mesLabel.text!.doubleValue + 15.00)
                }else{
                    self.valor_mesLabel.text = String(self.valor_mesLabel.text!.doubleValue - 15.00)
                }
            }
        }
    }
    
    @IBAction func km700Click(_ sender: Any) {
        if self.id_tabela != 0{
            if km_700Switch.isSelected == true{
                self.valor_mesLabel.text =  String(self.valor_mesLabel.text!.doubleValue + 25.00)
            }else{
                self.valor_mesLabel.text = String(self.valor_mesLabel.text!.doubleValue - 25.00)
            }}
    }
    
    @IBAction func km1000Click(_ sender: Any) {
        if self.id_tabela != 0{
            if km_1000Switch.isSelected == true{
                self.valor_mesLabel.text =  String(self.valor_mesLabel.text!.doubleValue + 35.00)
            }else{
                self.valor_mesLabel.text = String(self.valor_mesLabel.text!.doubleValue - 35.00)
            }}
    }
    func Convertetabela(tabelaApi: String!) -> Int{
        var tabelaid = 0
        if tabelaApi! == "AUTOMÓVEL LEVE/PICK UP"{
            tabelaid = 1
        }
        if tabelaApi! == "CAMINHONETE" {
            tabelaid = 2
        }
        if tabelaApi! == "MOTO"{
            tabelaid = 3
        }
        if tabelaApi! == "TABELA ESPECIAL 4" {
            tabelaid = 4
        }
        if tabelaApi! == "TABELA ESPECIAL 5" {
            tabelaid = 5
        }
        if tabelaApi! == "TABELA ESPECIAL 6" {
            tabelaid = 6
        }
        
        return tabelaid
    }
    
    
    @IBAction func saveButt(sender: AnyObject) {
        
        tirarScreenshot(scrollView: scrollView)
        
        var alert = UIAlertView(title: "Sucesso!",
                                message: "Simulação salva na galeria de fotos",
                                delegate: nil,
                                cancelButtonTitle: "Ok")
        alert.show()
}
    
    @IBOutlet weak var rastreadorSwitch: AIFlatSwitch!
    @IBAction func rastreadorClick(_ sender: Any) {
        
        if rastreadorSwitch.isSelected == true{
            self.valor_mesLabel.text =  String(self.valor_mesLabel.text!.doubleValue + 50.00)
        }else{
            self.valor_mesLabel.text = String(self.valor_mesLabel.text!.doubleValue - 50.00)
        }
        
    }
}
