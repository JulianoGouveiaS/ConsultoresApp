//
//  PropostaInfo.swift
//  SevenConsultor
//
//  Created by Juliano Gouveia on 11/04/2018.
//  Copyright © 2018 Raphael Higashi Silva. All rights reserved.
//

import Foundation
import UIKit

class PropostaInfo {
    
    
    //veiculo
    var tp_seguro: Int?
    var situacao: Int?
    var dt_vistoria: String?
    var placa: String?
    var tabela: Int?
    var tp_veic: Int?
    var marca: String?
    var modelo: String?
    var ano_fab: String?
    var ano_modelo: String?
    var cod_fipe: String?
    var valor_veic: String?
    var renavam: String?
    var dt_contrato: String?
    var chassi: String?
    var cor: Int?
    var combustivel: Int?
    var obs: String?
    var cpf: String?
    var nome: String?
    var created_at: String?
    var id: Int?
    
init (dictionary: [String: Any]){
    
    self.created_at = dictionary["created_at"] as? String
    self.nome = dictionary["id_cliente"] as? String
    self.id = dictionary["id"] as? Int
    self.tp_seguro = dictionary["tp_seguro"] as? Int
    self.situacao = dictionary["id_status"] as? Int
    self.dt_vistoria = dictionary["dt_vistoria"] as? String
    self.placa = dictionary["placa"] as? String
    self.tabela = dictionary["id_classificacao"] as? Int
    self.tp_veic = dictionary["tipo_veiculo"] as? Int
    self.marca = dictionary["marca"] as? String
    self.modelo = dictionary["modelo"] as? String
    self.ano_fab = dictionary["ano_fb"] as? String
    self.ano_modelo = dictionary["ano_fb"] as? String
    self.cod_fipe = dictionary["cod_fipe"] as? String
    self.valor_veic = dictionary["valor"] as? String
    self.renavam = dictionary["renavam"] as? String
    self.dt_contrato = dictionary["dt_contrato"] as? String
    self.chassi = dictionary["chassi"] as? String
    self.cor = dictionary["id_cor"] as? Int
    self.combustivel = dictionary["id_combustivel"] as? Int
    self.obs = dictionary["txtobs"] as! String?
    self.cpf = dictionary["cpf"] as! String?
}
}
