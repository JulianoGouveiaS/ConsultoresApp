//
//  DetalhesBoletosVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 01/11/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import CFAlertViewController
import KRProgressHUD
import Static

class DetalhesBoletosVC: UIViewController {
    
    var nosso_numero: String!
    var valor: String!
    var tipo_boleto: String!
    var data_vencimento: String!
    var data_pagamento: String!
    var mes_referente: String!
    var nome_associado: String!
    var situacao_associado: String!
    var situacao_boleto: String!
    var placas_veiculos_boleto: String!
    var chassi_veiculos_boleto: String!
    var situacao_veiculos_boleto: String!
    var url_boleto: String!
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource = DataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MakeButtonsNav()
        dataSource.tableView = tableView
        
        // Note:
        // Required to be set pre iOS11, to support autosizing
        tableView.estimatedSectionHeaderHeight = 13.5
        tableView.estimatedSectionFooterHeight = 13.5
        // Do any additional setup after loading the view.
        dataSource.sections = [
            Section(header: "Valor", rows: [
                Row(text: "\(self.valor!)", detailText: ""),
                ]),
            Section(header: "Tipo do Boleto", rows: [
                Row(text: "\(self.tipo_boleto!)", detailText: ""),
                ]),
            Section(header: "Data de Vencimento", rows: [
                Row(text: "\(self.data_vencimento!)", detailText: ""),
                ]),
            Section(header: "Data de Pagamento", rows: [
                Row(text: "\(self.data_pagamento!)", detailText: ""),
                ]),
            Section(header: "Mês Referente", rows: [
                Row(text: "\(self.mes_referente!)", detailText: ""),
                ]),
            Section(header: "Nome do Associado", rows: [
                Row(text: "\(self.nome_associado!)", detailText: ""),
                ]),
            Section(header: "Situação do Associado", rows: [
                Row(text: "\(self.situacao_associado!)", detailText: ""),
                ]),
            Section(header: "Situação do Boleto", rows: [
                Row(text: "\(self.situacao_boleto!)", detailText: ""),
                ]),
            Section(header: "Placa Veículo", rows: [
                Row(text: "\(self.placas_veiculos_boleto!)", detailText: ""),
                ]),
            Section(header: "Chassi Veículo", rows: [
                Row(text: "\(self.chassi_veiculos_boleto!)", detailText: ""),
                ]),
            Section(header: "Situação do Boleto", rows: [
                Row(text: "\(self.situacao_veiculos_boleto!)", detailText: ""),
                ]),
            Section(header: "URL", rows: [
                Row(text: "\(self.url_boleto!)", detailText: ""),
                ])
        ]
        // Do any additional setup after loading the view.
    }
    
    func MakeButtonsNav(){
        
        let bttnVisualizar: UIButton = UIButton(type: UIButtonType.custom)
        bttnVisualizar.setTitle("Visualizar", for: .normal)
        bttnVisualizar.setTitleColor(UIColor.black, for: .normal)
        bttnVisualizar.addTarget(self, action: "ver", for: UIControlEvents.touchUpInside)
        bttnVisualizar.frame = self.CGRectMake(0, 0, 53, 31)
        let barButtonVisualizar = UIBarButtonItem(customView: bttnVisualizar)
        
        
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItems = [barButtonVisualizar]
        
    }
    
    @objc func ver(){
        if self.data_vencimento != nil {
            let dateWithTime = Date()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let todayDateStr = dateFormatter.string(from: dateWithTime)
            let dayDate = dateFormatter.date(from: todayDateStr)
            let dayDateRecebido = dateFormatter.date(from: self.data_vencimento)
            
            if dayDate! > dayDateRecebido!.adding(days: 10){
                self.CriarAlertaSemErro(tituloAlerta: "Opa!", mensagemAlerta: "Boleto Vencido", acaoAlerta: "OK")
            }else{
                if let url = URL(string: self.url_boleto!) {
                    UIApplication.shared.open(url, options: [:])
            }
        }
    }
    }
    
    
}
