//
//  DetalhesSinistroVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 05/11/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import KRProgressHUD
import Alamofire
import CFAlertViewController
import SwiftyJSON
import Static

class DetalhesSinistroVC: UIViewController {

    var sinistroRecebido: Sinistro!
    
    
    let calendar = Calendar.current
    @IBOutlet weak var tableView: UITableView!
        var dataSource = DataSource()
    let cpf_cliente = KeychainWrapper.standard.string(forKey: "CPF-C")
    let id_cliente = KeychainWrapper.standard.integer(forKey: "ID-C")
    let nome_cliente = KeychainWrapper.standard.string(forKey: "NOME-C")
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.tableView = tableView
        
        // Note:
        // Required to be set pre iOS11, to support autosizing
        tableView.estimatedSectionHeaderHeight = 13.5
        tableView.estimatedSectionFooterHeight = 13.5
        loadDetalhes(id: sinistroRecebido.id!)
       
        // Do any additional setup after loading the view.
    }
    
    func loadDetalhes(id: Int){
        
        KRProgressHUD.show()
        
        let parameters = ["id": "\(id)"] as [String : Any]
        
        let url = "https://www.sevenprotecaoveicular.com.br/Api/ExibirSinistroApp"
        Alamofire.request(url, method:.post, parameters:parameters,encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                self.dataSource.sections = [
                    Section(header: "ASSOCIADO", rows: [
                        Row(text: "Nome", detailText: json["user_data"]["nome_associado"].stringValue, cellClass: SubtitleCell.self),
                         Row(text: "Data de Nascimento", detailText: json["user_data"]["dt_nascimento"].stringValue, cellClass: SubtitleCell.self),
                         Row(text: "Sexo", detailText: json["user_data"]["sexo"].stringValue, cellClass: SubtitleCell.self),
                         Row(text: "CPF ou CNPJ", detailText: json["user_data"]["cpf_cpnj"].stringValue, cellClass: SubtitleCell.self),
                         Row(text: "RG", detailText: json["user_data"]["rg"].stringValue, cellClass: SubtitleCell.self),
                         Row(text: "CNH", detailText: json["user_data"]["cnh"].stringValue, cellClass: SubtitleCell.self),
                         Row(text: "Categoria da CNH", detailText: json["user_data"]["categoria_cnh"].stringValue, cellClass: SubtitleCell.self),
                         Row(text: "CEP", detailText: json["user_data"]["cep"].stringValue, cellClass: SubtitleCell.self),
                         Row(text: "Estado", detailText: json["user_data"]["estado"].stringValue, cellClass: SubtitleCell.self),
                         Row(text: "Cidade", detailText: json["user_data"]["cidade"].stringValue, cellClass: SubtitleCell.self),
                         Row(text: "Rua", detailText: json["user_data"]["rua"].stringValue, cellClass: SubtitleCell.self),
                         Row(text: "Número", detailText: json["user_data"]["numero"].stringValue, cellClass: SubtitleCell.self),
                         Row(text: "Bairro", detailText: json["user_data"]["bairro"].stringValue, cellClass: SubtitleCell.self),
                         Row(text: "Complemento", detailText: json["user_data"]["complemento"].stringValue, cellClass: SubtitleCell.self),
                         Row(text: "Telefone", detailText: json["user_data"]["num_telefone"].stringValue, cellClass: SubtitleCell.self),
                         Row(text: "Celular", detailText: json["user_data"]["num_cell"].stringValue, cellClass: SubtitleCell.self),
                         Row(text: "Celular (alternativo)", detailText: json["user_data"]["num_cell_alt"].stringValue, cellClass: SubtitleCell.self),
                         Row(text: "Data do Contrato", detailText: json["user_data"]["dt_contrato"].stringValue, cellClass: SubtitleCell.self),
                         Row(text: "Email", detailText: json["user_data"]["email"].stringValue, cellClass: SubtitleCell.self),
                        ]),
                    Section(header: "VEÍCULO", rows: [
                        Row(text: "Placa", detailText: json["user_data"]["placa_veiculo"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Marca", detailText: json["user_data"]["marca"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Modelo", detailText: json["user_data"]["modelo"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Ano de Fabricação", detailText: json["user_data"]["ano_fb"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Ano do Modelo", detailText: json["user_data"]["ano_modelo"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Renavam", detailText: json["user_data"]["renavam"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Chassi", detailText: json["user_data"]["chassi"].stringValue, cellClass: SubtitleCell.self),
                        ]),
                    Section(header: "LOCAL DO SINISTRO", rows: [
                        Row(text: "Rua", detailText: json["user_data"]["rua_sinistro"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Bairro", detailText: json["user_data"]["bairro_sinistro"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Cidade", detailText: json["user_data"]["cidade_sinistro"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Estado", detailText: json["user_data"]["estado_sinistro"].stringValue, cellClass: SubtitleCell.self),
                        ]),
                    Section(header: "TESTEMUNHAS", rows: [
                        Row(text: "Nome (Testemuna 1)", detailText: json["user_data"]["nome_testesmunha1"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Telefone (Testemunha 1)", detailText: json["user_data"]["telefone_testesmunha1"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Nome (Testemuna 2)", detailText: json["user_data"]["nome_testesmunha2"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Telefone (Testemunha 2)", detailText: json["user_data"]["telefone_testesmunha2"].stringValue, cellClass: SubtitleCell.self),
                        ]),
                    Section(header: "CONDUTOR", rows: [
                        Row(text: "Nome", detailText: json["user_data"]["nome_condutor"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Data de Nascimento", detailText: json["user_data"]["dt_nasc_condutor"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Sexo", detailText: json["user_data"]["sexo_condutor"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "CPF ou CNPJ", detailText: json["user_data"]["cpf_cnpj_condutor"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "RG", detailText: json["user_data"]["rg_condutor"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "CNH", detailText: json["user_data"]["cnh_condutor"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Categoria da CNH", detailText: json["user_data"]["categoria_cnh_condutor"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "CEP", detailText: json["user_data"]["cep_condutor"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Estado", detailText: json["user_data"]["estado_condutor"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Cidade", detailText: json["user_data"]["cidade_condutor"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Rua", detailText: json["user_data"]["rua_condutor"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Número", detailText: json["user_data"]["numero_condutor"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Bairro", detailText: json["user_data"]["bairro_condutor"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Complemento", detailText: json["user_data"]["complemento_condutor"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Telefone", detailText: json["user_data"]["num_telefone_condutor"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Celular", detailText: json["user_data"]["num_cell_condutor"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Email", detailText: json["user_data"]["email_condutor"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Condutor Dono", detailText: json["user_data"]["condutor_dono"].stringValue, cellClass: SubtitleCell.self),
                        ]),
                    Section(header: "INFORMAÇÕES GERAIS DO SINISTRO", rows: [
                        Row(text: "Narrativa", detailText: json["user_data"]["narrativa"].stringValue, selection: { [unowned self] in
                            
                            self.CriarAlertaSemErro(tituloAlerta: "Narrativa", mensagemAlerta: json["user_data"]["narrativa"].stringValue, acaoAlerta: "Pronto")
                            
                            
                            }, cellClass: SubtitleCell.self),
                        Row(text: "Data de Criação", detailText: json["user_data"]["created_at"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Data de Atualização", detailText: json["user_data"]["updated_at"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Valor Participação", detailText: json["user_data"]["vl_participacao"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Carro Reserva", detailText: json["user_data"]["tem_carro_res"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Quantidade de Dias", detailText: json["user_data"]["qt_dias"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Dias Usados", detailText: json["user_data"]["qt_dias_usou"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Data de Liberação", detailText: json["user_data"]["dt_liberacao"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Data Franquia", detailText: json["user_data"]["dt_franquia"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Data de Conclusão", detailText: json["user_data"]["dt_conclusao"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Numero do BO", detailText: json["user_data"]["num_bo"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Status", detailText: json["user_data"][""].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "nm_status", detailText: json["user_data"][""].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Data do Evento", detailText: json["user_data"]["dt_evento"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Hora do Evento", detailText: json["user_data"]["hr_evento"].stringValue, cellClass: SubtitleCell.self),
                        Row(text: "Tipo do Sinistro", detailText: json["user_data"]["tipo_sinistro"].stringValue, cellClass: SubtitleCell.self),
                        ]),
                ]
            
            
                KRProgressHUD.dismiss()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                KRProgressHUD.dismiss()
                
                print(error)
                
                self.CriarAlerta(tituloAlerta: "Oops!", mensagemAlerta: "Erro ao Efetuar login!", acaoAlerta: "Ok", erroRecebido: "\(error)")
            }
            
        }
    }

}
