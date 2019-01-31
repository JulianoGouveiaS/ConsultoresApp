//
//  ResultadoFipeVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 21/12/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import FirebaseFirestore
import KRProgressHUD
import KSTokenView

class ResultadoFipeVC: UIViewController, KSTokenViewDelegate {

    var names: Array<String> = ["Danos Mat a Terceiros", "Coparticipação Reduzida", "Proteção de Vidros 80%", "Rastreador", "Carro Reserva (15 dias)", "Carro Reserva (30 dias)", "Uber", "Pct Premium (15 dias)", "Pct Premium (30 dias)", "Assist 24H 500KM", "Assist 24H 700KM", "Assist 24H 1000KM"]
  
    
    @IBOutlet weak var tabelaLbl: UILabel!
    @IBOutlet weak var franquiaLbl: UILabel!
    @IBOutlet weak var codigo_fipeLbl: UILabel!
    @IBOutlet weak var marcaLbl: UILabel!
    @IBOutlet weak var modeloLbl: UILabel!
    @IBOutlet weak var updated_atLbl: UILabel!
    @IBOutlet weak var anoLbl: UILabel!
    @IBOutlet weak var valorLbl: UILabel!
    @IBOutlet weak var valor_mesLbl: UILabel!
    
    var tabela: String!
    var franquia: String!
    var codigo_fipe: String!
    var marca: String!
    var modelo: String!
    var valor: String!
    var ano: String!
    var updated_at: String!
    var valor_mes: String!
    var combustivel: String!
    var id_tabela: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.id_tabela == 3{
            self.names = ["Danos Mat a Terceiros", "Coparticipação Reduzida", "Rastreador", "Pct Premium (15 dias)", "Pct Premium (30 dias)", "Assist 24H 500KM", "Assist 24H 700KM", "Assist 24H 1000KM"]
        }
        
        
        let tokenView = KSTokenView(frame: CGRect(x: 10, y: 20, width: 300, height: 40))
        
        tokenView.delegate = self
        tokenView.promptText = "ADICIONAIS: "
        tokenView.placeholder = "Clique para adicionar"
        tokenView.descriptionText = "Adicionais"
        tokenView.style = .squared
        tokenView.shouldAddTokenFromTextInput = false
        tokenView.minimumCharactersToSearch = 0
        tokenView.direction = .vertical
        tokenView.layer.borderWidth = 1
        tokenView.layer.borderColor = UIColor.black.cgColor
        
        self.view.addSubview(tokenView)
        if self.tabela == "Não fazemos esse modelo"{
            self.franquiaLbl.text = "Não fazemos esse modelo"
        }else{
            self.franquiaLbl.text = self.franquia
        }
        self.tabelaLbl.text = self.tabela
        self.codigo_fipeLbl.text = self.codigo_fipe
        self.marcaLbl.text = self.marca
        self.modeloLbl.text = self.modelo
        self.valorLbl.text = self.valor
        self.anoLbl.text = "\(self.ano!) \(self.combustivel!)"
        self.updated_atLbl.text = self.updated_at
        self.valor_mesLbl.text = "\(Double(self.valor_mes.replace(target: ",", withString: "."))!)"
        
    }
    
    func tokenView(_ tokenView: KSTokenView, performSearchWithString string: String, completion: ((_ results: Array<AnyObject>) -> Void)?) {
        
        if (string.characters.isEmpty){
            completion!(names as Array<AnyObject>);
            return
        };
        
        var data: Array<String> = []
        for value: String in names {
            if value.lowercased().range(of: string.lowercased()) != nil {
                data.append(value)
            }
        }
        completion!(data as Array<AnyObject>)
    }
    
    func tokenView(_ tokenView: KSTokenView, displayTitleForObject object: AnyObject) -> String {
        return object as! String
    }
    
    func tokenView(_ tokenView: KSTokenView, didAddToken token: KSToken) {
        if self.id_tabela != 0{
            switch token.title {
                
            case "Danos Mat a Terceiros":
                    self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue + 15.00)
                
            case "Coparticipação Reduzida":
                if self.id_tabela != 5 && self.id_tabela != 6{
                    self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue + 15.00)
                }else{
                    self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue + 30.00)
                }
                
            case "Proteção de Vidros 80%":
                if self.id_tabela != 3{
                    self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue + 15.00)
                }
                
            case "Rastreador":
                self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue + 50.00)
                
            case "Carro Reserva (15 dias)":
                if self.id_tabela != 3{
                    self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue + 15.00)
                }
                
            case "Carro Reserva (30 dias)":
                if self.id_tabela != 3{
                    self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue + 30.00)
                }
                
            case "Pct Premium (15 dias)":
                if self.id_tabela != 3 && self.id_tabela != 5 && self.id_tabela != 6{
                    self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue + 39.00)
                }
                
            case "Pct Premium (30 dias)":
                if self.id_tabela != 3 {
                    self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue + 69.00)
                }
                
            case "Uber":
                self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue + 50.00)
                
            case "Assist 24H 500KM":
                self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue + 15.00)
                
            case "Assist 24H 700KM":
                self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue + 25.00)
                
            case "Assist 24H 1000KM":
                self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue + 35.00)
                
            default:
                print("asdadasdada")
                
            }
        }
    }
    
    func tokenView(_ tokenView: KSTokenView, didDeleteToken token: KSToken) {
        if self.id_tabela != 0{
            switch token.title {
                
            case "Danos Mat a Terceiros":
                self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue - 15.00)
                
            case "Coparticipação Reduzida":
                if self.id_tabela != 5 && self.id_tabela != 6{
                    self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue - 15.00)
                }else{
                    self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue - 30.00)
                }
                
            case "Proteção de Vidros 80%":
                if self.id_tabela != 3{
                    self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue - 15.00)
                }
                
            case "Rastreador":
                self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue - 50.00)
                
            case "Carro Reserva (15 dias)":
                if self.id_tabela != 3{
                    self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue - 15.00)
                }
                
            case "Carro Reserva (30 dias)":
                if self.id_tabela != 3{
                    self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue - 30.00)
                }
                
            case "Pct Premium (15 dias)":
                if self.id_tabela != 3 && self.id_tabela != 5 && self.id_tabela != 6{
                    self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue - 39.00)
                }
                
            case "Pct Premium (30 dias)":
                if self.id_tabela != 3 {
                    self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue - 69.00)
                }
                
            case "Uber":
                self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue - 50.00)
                
            case "Assist 24H 500KM":
                self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue - 15.00)
                
            case "Assist 24H 700KM":
                self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue - 25.00)
                
            case "Assist 24H 1000KM":
                self.valor_mesLbl.text = String(self.valor_mesLbl.text!.doubleValue - 35.00)
                
            default:
                print("asdadasdada")
            }
        }
    }
    
    func tokenView(_ tokenView: KSTokenView, didSelectToken token: KSToken) {
        print("selecionou:" ,token)
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
    
}

