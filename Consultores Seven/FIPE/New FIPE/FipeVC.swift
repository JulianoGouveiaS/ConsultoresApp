//
//  FipeVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 19/12/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import KRProgressHUD


class FipeVC: UIViewController {

    @IBOutlet weak var marcaDropDown : DropDown!
    @IBOutlet weak var codigoDropDown : DropDown!
    @IBOutlet weak var modeloDropDown : DropDown!
    
    @IBOutlet weak var TipoSegmented : UISegmentedControl!
    
    var tipoEscolhido = ""
    var arrAnos: [String]!
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.marcaDropDown.optionArray = []
        self.marcaDropDown.text = ""
        self.tipoEscolhido = ""
        self.codigoDropDown.optionArray = []
        self.codigoDropDown.text = ""
        self.modeloDropDown.optionArray = []
        self.modeloDropDown.text = ""
        self.arrAnos = []
        self.TipoSegmented.selectedSegmentIndex = UISegmentedControlNoSegment
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.marcaDropDown.optionArray = []
        
        marcaDropDown.didSelect(completion: { (selected, index, id)  in
            
            self.codigoDropDown.optionArray = []
            self.codigoDropDown.text = ""
            self.modeloDropDown.optionArray = []
            self.modeloDropDown.text = ""
            
            let array = selected.components(separatedBy: " ")
            let idEscolhido = array[0]
            print(idEscolhido)
            self.getCodigo(tipo: self.tipoEscolhido, id: idEscolhido)
            self.marcaDropDown.text = selected
        })
        
        self.codigoDropDown.optionArray = []
        
        codigoDropDown.didSelect(completion: { (selected, index, id)  in
            
            self.modeloDropDown.optionArray = []
            self.modeloDropDown.text = ""
            let array = self.marcaDropDown.text!.components(separatedBy: " ")
            let idEscolhido = array[0]
            let arrayModelo = selected.components(separatedBy: " ")
            let modeloEscolhido = arrayModelo[0]
            self.getModelo(tipo: self.tipoEscolhido, id: idEscolhido, modelo: modeloEscolhido)
            
            self.codigoDropDown.text = selected
        })
        
        self.modeloDropDown.optionArray = []
        
        modeloDropDown.didSelect(completion: { (selected, index, id)  in
            
            self.modeloDropDown.text = selected
            let array = self.marcaDropDown.text!.components(separatedBy: " ")
            let idEscolhido = array[0]
            let arrayModelo = self.modeloDropDown.text!.components(separatedBy: " ")
            let modeloEscolhido = arrayModelo[0]
            //let arrayAno = selected.components(separatedBy: " ")
            //let anoEscolhido = arrayAno[0]
            
            let anoEscolhido = self.arrAnos[index]
            self.getInfos(tipo: self.tipoEscolhido, id: idEscolhido, modelo: modeloEscolhido, ano: anoEscolhido)
        })
    }
    
    @IBAction func SegmentedChangeValue(sender: Any){
        self.marcaDropDown.optionArray = []
        self.marcaDropDown.text = ""
        self.codigoDropDown.optionArray = []
        self.codigoDropDown.text = ""
        self.modeloDropDown.optionArray = []
        self.modeloDropDown.text = ""
        if self.TipoSegmented.selectedSegmentIndex == 0{
            
            self.tipoEscolhido = "carros"
            
            self.getMarcas(tipo: "carros")
            
        }else if self.TipoSegmented.selectedSegmentIndex == 1{
            
            self.tipoEscolhido = "motos"
            
            self.getMarcas(tipo: "motos")
            
        }else if self.TipoSegmented.selectedSegmentIndex == 2{
            
            self.tipoEscolhido = "caminhoes"
            
            self.getMarcas(tipo: "caminhoes")
            
        }
    }
    
    func getMarcas(tipo: String){
        
        KRProgressHUD.show()
        let url = "https://www.sevenprotecaoveicular.com.br/Api/Recupemarca/\(tipo)"
        
        Alamofire.request(url, method:.get, parameters: nil,encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                if json.count < 1{
                    KRProgressHUD.showMessage("Nenhum resultado encontrado")
                    return
                }
                self.arrAnos = []
                for i in 0...json.count - 1{
                    self.marcaDropDown.optionArray.append("\(json[i]["id"].intValue) - \(json[i]["name"].stringValue)")
                }
                self.marcaDropDown.isEnabled = true
                
                KRProgressHUD.dismiss()
                
            case .failure(let error):
                KRProgressHUD.dismiss()
                KRProgressHUD.showMessage("Erro!")
                
                print(error)
                if error._code == NSURLErrorTimedOut {
                    
                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Sua conexão caiu ou está instável!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                    
                }else if error._code == NSURLErrorNotConnectedToInternet{
                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Conecte-se a internet!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                }else {
                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Erro ao conectar-se!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                }
                
            }
            
        }
    }
    
    func getCodigo(tipo: String, id: String){
        
        KRProgressHUD.show()
        
        let url = "https://www.sevenprotecaoveicular.com.br/Api/Recupemarca/\(tipo)/\(id)"
        
        Alamofire.request(url, method:.get, parameters: nil,encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                if json.count < 1{
                    KRProgressHUD.showMessage("Nenhum resultado encontrado")
                    return
                }
                for i in 0...json.count - 1{
                    self.codigoDropDown.optionArray.append("\(json[i]["id"].intValue) - \(json[i]["name"].stringValue)")
                }
                self.codigoDropDown.isEnabled = true
                
                KRProgressHUD.dismiss()
                
            case .failure(let error):
                KRProgressHUD.dismiss()
                KRProgressHUD.showMessage("Erro!")
                
                print(error)
                if error._code == NSURLErrorTimedOut {
                    
                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Sua conexão caiu ou está instável!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                    
                }else if error._code == NSURLErrorNotConnectedToInternet{
                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Conecte-se a internet!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                }else {
                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Erro ao conectar-se!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                }
                
            }
            
        }
    }
    
    
    func getModelo(tipo: String, id: String, modelo: String){
        
        KRProgressHUD.show()
        
        let url = "https://www.sevenprotecaoveicular.com.br/Api/Recupemarca/\(tipo)/\(id)/\(modelo)"
        
        Alamofire.request(url, method:.get, parameters: nil,encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                if json.count < 1{
                    KRProgressHUD.showMessage("Nenhum resultado encontrado")
                    return
                }
                for i in 0...json.count - 1{
                    self.modeloDropDown.optionArray.append("\(json[i]["name"].stringValue)")
                    self.arrAnos.append("\(json[i]["id"].intValue)")
                }
                self.modeloDropDown.isEnabled = true
                
                KRProgressHUD.dismiss()
                
            case .failure(let error):
                KRProgressHUD.dismiss()
                KRProgressHUD.showMessage("Erro!")
                
                print(error)
                if error._code == NSURLErrorTimedOut {
                    
                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Sua conexão caiu ou está instável!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                    
                }else if error._code == NSURLErrorNotConnectedToInternet{
                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Conecte-se a internet!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                }else {
                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Erro ao conectar-se!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                }
                
            }
            
        }
    }
    
    func getInfos(tipo: String, id: String, modelo: String, ano: String){
        
        KRProgressHUD.show()
        
        let url = "https://www.sevenprotecaoveicular.com.br/Api/Recupemarca/\(tipo)/\(id)/\(modelo)/\(ano)"
        
        Alamofire.request(URL(string: url)!, method:.get, parameters: nil,encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                KRProgressHUD.dismiss()
                
                let combustivel = json["combustivel"].stringValue
                
                let tabela = json["tabela"].stringValue
                let franquia = json["franquia"].stringValue
                let codigo_fipe = json["codigo_fipe"].stringValue
                let marca = json["marca"].stringValue
                let modelo = json["modelo"].stringValue
                let valor = json["valor"].stringValue
                let ano = json["ano"].stringValue
                let updated_at = json["updated_at"].stringValue
                let valor_mes = json["valor_mes"].stringValue
                
                let vc = UIStoryboard(name: "Fipe", bundle: nil).instantiateViewController(withIdentifier: "ResultadoFipeVC") as! ResultadoFipeVC
                    vc.tabela = tabela
                    vc.franquia = franquia
                    vc.codigo_fipe = codigo_fipe
                    vc.marca = marca
                    vc.modelo = modelo
                    vc.valor = valor
                    vc.ano = ano
                    vc.updated_at = updated_at
                    vc.valor_mes = valor_mes
                    vc.combustivel = combustivel
                self.navigationController!.pushViewController(vc, animated: true)
                
            case .failure(let error):
                KRProgressHUD.dismiss()
                
                print(error)
                if error._code == NSURLErrorTimedOut {
                    
                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Sua conexão caiu ou está instável!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                    
                }else if error._code == NSURLErrorNotConnectedToInternet{
                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Conecte-se a internet!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                }else {
                    self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Erro ao conectar-se!", acaoAlerta: "Ok", erroRecebido: "\(error)")
                }
                
            }
            
        }
    }
}
