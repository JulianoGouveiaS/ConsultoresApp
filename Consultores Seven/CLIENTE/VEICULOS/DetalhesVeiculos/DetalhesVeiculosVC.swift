//
//  DetalhesVeiculosVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 01/11/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import CFAlertViewController
import KRProgressHUD
import Static

class DetalhesVeiculosVC: UIViewController {
    
    var id: Int!
    var tp_seguro: Int!
    var tipo_veiculo: Int!
    var id_cor: Int!
    var id_status: String!
    var id_combustivel: Int!
    var dt_vencimento: String!
    var dt_contrato: String!
    var vl_adesao: String!
    var vl_mensal: String!
    var marca: String!
    var modelo: String!
    var ano_fb: String!
    var ano_modelo: String!
    var cod_fipe: String!
    var valor: String!
    var chassi: String!
    var renavam: String!
    var placa: String!
    var dt_vistoria: String!
    var id_tipo: Int!
    
       @IBOutlet weak var tableView: UITableView!
    
    var dataSource = DataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.tableView = tableView
        
        // Note:
        // Required to be set pre iOS11, to support autosizing
        tableView.estimatedSectionHeaderHeight = 13.5
        tableView.estimatedSectionFooterHeight = 13.5
        
        dataSource.sections = [
             Section(header: "Status", rows: [
                Row(text: "\(self.id_status!)", detailText: ""),
                ]),
             Section(header: "Placa", rows: [
                Row(text: "\(self.placa!)", detailText: ""),
                ]),
             Section(header: "Valor Mensal", rows: [
                Row(text: "\(self.vl_mensal!)", detailText: ""),
                ]),
             Section(header: "Chassi", rows: [
                Row(text: "\(self.chassi!)", detailText: ""),
                ]),
             Section(header: "Tabela", rows: [
                Row(text: "\(self.id_tipo!)", detailText: ""),
                ]),
             Section(header: "Tipo do Veículo", rows: [
                Row(text: "\(self.tipo_veiculo!)", detailText: ""),
                ]),
             Section(header: "Marca", rows: [
                Row(text: "\(self.marca!)", detailText: ""),
                ]),
             Section(header: "Modelo", rows: [
                Row(text: "\(self.modelo!)", detailText: ""),
                ]),
             Section(header: "Renavam", rows: [
                Row(text: "\(self.renavam!)", detailText: ""),
                ]),
             Section(header: "Ano de Modelo", rows: [
                Row(text: "\(self.ano_modelo!)", detailText: ""),
                ]),
             Section(header: "Ano de Fabricação", rows: [
                Row(text: "\(self.ano_fb!)", detailText: ""),
                ]),
             Section(header: "Data da Vistoria", rows: [
                Row(text: "\(self.dt_vistoria!)", detailText: ""),
                ]),
             Section(header: "Data do Contrato", rows: [
                Row(text: "\(self.dt_contrato!)", detailText: ""),
                ]),
             Section(header: "Data do Vencimento", rows: [
                Row(text: "\(self.dt_vencimento!)", detailText: ""),
                ])
            
        ]
        // Do any additional setup after loading the view.
    }
    

  
}
