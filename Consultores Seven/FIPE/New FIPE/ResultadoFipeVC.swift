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

    var names: Array<String> = ["Danos Mat a Terceiros", "Carro Reserva (15 dias)", "Carro Reserva (30 dias)", "Coparticipação Reduzida", "Especiais", "Proteção de Vidros 80%", "Pct Premium (15 dias)", "Pct Premium (30 dias)", "Assist 24H 500KM", "Assist 24H 700KM", "Assist 24H 1000KM", "Uber, Bacify, 99Pop, etc..."]
  
    
    
    @IBOutlet weak var tabelaLbl: UILabel!
    @IBOutlet weak var franquiaLbl: UILabel!
    @IBOutlet weak var codigo_fipeLbl: UILabel!
    @IBOutlet weak var marcaLbl: UILabel!
    @IBOutlet weak var modeloLbl: UILabel!
    @IBOutlet weak var updated_atLbl: UILabel!
    @IBOutlet weak var anoLbl: UILabel!
    @IBOutlet weak var valorLbl: UILabel!
    @IBOutlet weak var valor_mesLbl: UILabel!
 
    @IBOutlet weak var tokenView: KSTokenView!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MakeButtonsNav()
        if self.id_tabela == 3{
            self.names = ["Danos Mat a Terceiros", "Coparticipação Reduzida", "Rastreador", "Pct Premium (15 dias)", "Pct Premium (30 dias)", "Assist 24H 500KM", "Assist 24H 700KM", "Assist 24H 1000KM"]
       }
        
        tokenView.delegate = self
        tokenView.promptText = "ADICIONAIS: "
        tokenView.placeholder = "Clique para Pesquisar"
        tokenView.descriptionText = "Adicionais"
        tokenView.maxTokenLimit = -1
        tokenView.searchResultHeight = 100
        tokenView.minimumCharactersToSearch = 0 // Show all results without without typing anything 20/417/1994
        tokenView.style = .squared
        tokenView.returnKeyType(type: .done)
        tokenView.layer.borderWidth = 1
        tokenView.layer.borderColor = UIColor.black.cgColor
        
        if self.tabela == "Não fazemos esse modelo"{
            self.franquiaLbl.text = "Não fazemos esse modelo"
            self.valor_mesLbl.text = "Não fazemos esse modelo"
            self.tokenView.isUserInteractionEnabled = false
            tokenView.promptText = ""
            tokenView.placeholder = "Adicionais indisponíveis para esta FIPE"
        }else{
            self.franquiaLbl.text = self.franquia
            self.valor_mesLbl.text = "\(Double(self.valor_mes.replace(target: ",", withString: "."))!)"
            self.tokenView.isUserInteractionEnabled = true
        }
        self.tabelaLbl.text = self.tabela
        self.codigo_fipeLbl.text = self.codigo_fipe
        self.marcaLbl.text = self.marca
        self.modeloLbl.text = self.modelo
        self.valorLbl.text = self.valor
        self.anoLbl.text = "\(self.ano!) \(self.combustivel!)"
       // self.updated_atLbl.text = self.updated_at
    }
    
    func tokenView(_ tokenView: KSTokenView, didAddToken token: KSToken) {
        if self.id_tabela != 0{
            switch token.title {
                
            case "Danos Mat a Terceiros":
                AdicionaValor(valor: 15.00)
                
            case "Coparticipação Reduzida":
                if self.id_tabela != 5 && self.id_tabela != 6{
                    AdicionaValor(valor: 15.00)
                }else{
                    AdicionaValor(valor: 30.00)
                }
                
            case "Proteção de Vidros 80%":
                if self.id_tabela != 3{
                    AdicionaValor(valor: 15.00)
                }
                
            case "Especiais":
                AdicionaValor(valor: 50.00)
                
            case "Carro Reserva (15 dias)":
                if self.id_tabela != 3{
                    AdicionaValor(valor: 15.00)
                }
                
            case "Carro Reserva (30 dias)":
                if self.id_tabela != 3{
                    AdicionaValor(valor: 30.00)
                }
                
            case "Pct Premium (15 dias)":
                if self.id_tabela != 3 && self.id_tabela != 5 && self.id_tabela != 6{
                    AdicionaValor(valor: 39.00)
                }
                
            case "Pct Premium (30 dias)":
                if self.id_tabela != 3 {
                    AdicionaValor(valor: 69.00)
                }
                
            case "Uber, Bacify, 99Pop, etc...":
                AdicionaValor(valor: 50.00)
                
            case "Assist 24H 500KM":
                AdicionaValor(valor: 15.00)
                
            case "Assist 24H 700KM":
                AdicionaValor(valor: 25.00)
                
            case "Assist 24H 1000KM":
                AdicionaValor(valor: 35.00)
            default:
                print("asdadasdada")
            }
        }
    }
    
    func AdicionaValor(valor: Double){
        self.valor_mesLbl.text = String((Double(self.valor_mesLbl.text!)! + valor).rounded(toPlaces: 2))
    }
    
    func SubtraiValor(valor: Double){
        self.valor_mesLbl.text = String((Double(self.valor_mesLbl.text!)! - valor).rounded(toPlaces: 2))
    }
    
    func tokenView(_ tokenView: KSTokenView, didDeleteToken token: KSToken) {
        if self.id_tabela != 0{
            switch token.title {
                
            case "Danos Mat a Terceiros":
                SubtraiValor(valor: 15.00)
                
            case "Coparticipação Reduzida":
                if self.id_tabela != 5 && self.id_tabela != 6{
                    SubtraiValor(valor: 15.00)
                }else{
                    SubtraiValor(valor: 30.00)
                }
                
            case "Proteção de Vidros 80%":
                if self.id_tabela != 3{
                    SubtraiValor(valor: 15.00)
                }
                
            case "Especiais":
                SubtraiValor(valor: 50.00)
                
            case "Carro Reserva (15 dias)":
                if self.id_tabela != 3{
                    SubtraiValor(valor: 15.00)
                }
                
            case "Carro Reserva (30 dias)":
                if self.id_tabela != 3{
                    SubtraiValor(valor: 30.00)
                }
                
            case "Pct Premium (15 dias)":
                if self.id_tabela != 3 && self.id_tabela != 5 && self.id_tabela != 6{
                    SubtraiValor(valor: 39.00)
                }
                
            case "Pct Premium (30 dias)":
                if self.id_tabela != 3 {
                    SubtraiValor(valor: 69.00)
                }
                
            case "Uber, Bacify, 99Pop, etc...":
                SubtraiValor(valor: 50.00)
                
            case "Assist 24H 500KM":
                SubtraiValor(valor: 15.00)
                
            case "Assist 24H 700KM":
                SubtraiValor(valor: 25.00)
                
            case "Assist 24H 1000KM":
                SubtraiValor(valor: 35.00)
            default:
                print("asdadasdada")
            }
        }
    }
    
    func tokenView(_ tokenView: KSTokenView, didSelectToken token: KSToken) {
        print("selecionou:" ,token)
    }
    func tokenView(_ tokenView: KSTokenView, performSearchWithString string: String, completion: ((_ results: Array<AnyObject>) -> Void)?) {
     
        var data: Array<String> = names
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
    
    func tokenView(_ tokenView: KSTokenView, shouldChangeAppearanceForToken token: KSToken) -> KSToken? {
       
        token.tokenBackgroundColor = UIColor.red
        token.tokenTextColor = UIColor.black
    
        return token
    }
    
    func MakeButtonsNav(){
        
        let bttnScreenshot: UIButton = UIButton(type: UIButtonType.custom)
        bttnScreenshot.setImage(UIImage(named: "folder"), for: .normal)
        bttnScreenshot.addTarget(self, action: "saveTabela", for: UIControlEvents.touchUpInside)
        bttnScreenshot.frame = self.CGRectMake(0, 0, 53, 31)
        let barButtonSC = UIBarButtonItem(customView: bttnScreenshot)
        
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItems = [barButtonSC]
    }
    
    func saveTabela(){
        let image = view.asImage()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        KRProgressHUD.showMessage("Fipe enviada para o rolo da camera!")
    }
    
}

