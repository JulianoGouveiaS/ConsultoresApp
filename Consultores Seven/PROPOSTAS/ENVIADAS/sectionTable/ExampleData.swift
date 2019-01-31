//
//  ExampleData.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 8/1/17.
//  Copyright © 2017 Yong Su. All rights reserved.
//

import Foundation

//
// MARK: - Section Data Structure
//
public struct Item {
    var name: String
    var detail: String
    
    public init(name: String, detail: String) {
        self.name = name
        self.detail = detail
    }
}

public struct Section2 {
    var name: String
    var items: [Item]
    var collapsed: Bool
    
    public init(name: String, items: [Item], collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}

public var sectionsData: [Section2] = [
    Section2(name: "Informações do cliente", items: [
        Item(name: "Nome", detail: ""),
        Item(name: "RG", detail: ""),
        Item(name: "Data de Nascimento", detail: ""),
        Item(name: "CPF/CNPJ", detail: ""),
        Item(name: "CNH", detail: ""),
        Item(name: "CEP", detail: ""),
        Item(name: "UF", detail: ""),
        Item(name: "Cidade", detail: ""),
        Item(name: "Bairro", detail: ""),
        Item(name: "Rua", detail: ""),
        Item(name: "Número", detail: ""),
        Item(name: "Complemento", detail: ""),
        Item(name: "Nome da Mãe", detail: ""),
        Item(name: "Telefone Fixo", detail: ""),
        Item(name: "Telefone Fixo", detail: "")
    ]),
    Section2(name: "Informações do Veículo", items: [
        Item(name: "Tipo do Seguro", detail: ""),
        Item(name: "Status", detail: ""),
        Item(name: "Data da Vistoria", detail: ""),
        Item(name: "Placa", detail: ""),
        Item(name: "Tabela", detail: ""),
        Item(name: "Tipo do Veículo", detail: ""),
        Item(name: "Marca", detail: ""),
        Item(name: "Modelo", detail: ""),
        Item(name: "Ano de Fabricação", detail: ""),
        Item(name: "Ano do Modelo", detail: ""),
        Item(name: "Código FIPE", detail: ""),
        Item(name: "Valor do Veículo", detail: ""),
        Item(name: "RENAVAM", detail: ""),
        Item(name: "Data do Contrato", detail: ""),
        Item(name: "CHASSI", detail: ""),
        Item(name: "Cor", detail: ""),
        Item(name: "Combustível", detail: "")
    ])
   
]
