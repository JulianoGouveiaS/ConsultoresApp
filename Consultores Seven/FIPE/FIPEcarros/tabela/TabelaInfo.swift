//
//  ClienteInfo.swift
//  SevenPV
//
//  Created by Juliano Gouveia on 06/09/17.
//  Copyright © 2017 Juliano Gouveia. All rights reserved.
//


import Foundation
import UIKit

class TabelaInfo{
    
    var id_ano: Int?
    var codigo_modelo: Int?
    var codigo_fipe: String?
    var ano: String?
    var combustivel: String?
    var valor: String?
    var modelo: String?
    var marca: String?
    var franquia: String?
    var valor_mes: String?
    var tabela: String?
    
    
    init (dictionary: [String: Any]){
        
        self.id_ano = dictionary["id_ano"] as! Int?
        self.codigo_modelo = dictionary["codigo_modelo"] as! Int?
        self.codigo_fipe = dictionary["codigo_fipe"] as! String?
        self.ano = dictionary["ano"] as! String?
        self.combustivel = dictionary["combustivel"] as! String?
        self.valor = dictionary["valor"] as! String?
        self.modelo = dictionary["modelo"] as! String?
        self.marca = dictionary["marca"] as! String?
        self.franquia = dictionary["franquia"] as! String?
        self.valor_mes = dictionary["valor_mes"] as! String?
        self.tabela = dictionary["tabela"] as! String?
    }
}


