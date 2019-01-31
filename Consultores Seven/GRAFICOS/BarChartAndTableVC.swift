//
//  BarChart&TableVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 13/12/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import FirebaseFirestore
import KRProgressHUD
import KSTokenView

class BarChartAndTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cpf_user = KeychainWrapper.standard.string(forKey: "CPF")
    let id_user = KeychainWrapper.standard.integer(forKey: "ID")
    let nome_user = KeychainWrapper.standard.string(forKey: "NOME")
    
     let names: Array<String> = ["Danos Mat a Terceiros", "Coparticipação Reduzida", "Proteção de Vidros 80%", "Rastreador", "Carro Reserva (15 dias)", "Carro Reserva (30 dias)", "Uber", "Pct Premium (15 dias)", "Pct Premium (30 dias)"]
    
    public var chartColumn: AAChartType?
    public var stepColumn: Bool?
    private var aaChartModelColumn: AAChartModel?
    private var aaChartViewColumn: AAChartView?
    
    var viewcolumn = UIView()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.allowsSelection = false
        return tv
    }()
    
    let bandCellId = "bandCellId"
    
    var arrCaptacoes = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let tokenView = KSTokenView(frame: CGRect(x: 10, y: 100, width: 400, height: 40))
        tokenView.delegate = self
        tokenView.promptText = "Selecionados: "
        tokenView.placeholder = "Clique para adicionar"
        tokenView.descriptionText = "Adicionais"
        tokenView.style = .squared
        tokenView.shouldAddTokenFromTextInput = false
        
        tokenView.minimumCharactersToSearch = 0 // Show all results without typing anything
        tokenView.direction = .vertical
        
        view.addSubview(tokenView)
        
      /*  viewcolumn.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 260)
        viewcolumn.backgroundColor = UIColor.clear
        self.view.addSubview(viewcolumn)
        setupTableView()
        populaArrayCaptacoes()
    
        configureAAChartColumn()
        
        
 */
        // Do any additional setup after loading the view.
    }
    
    func populaArrayCaptacoes(){
        for _ in 0 ... 11{
            self.arrCaptacoes.append(Int.random(in: 0 ... 100))
        }
        self.tableView.reloadData()
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(BandCell.self, forCellReuseIdentifier: bandCellId)
        
        view.addSubview(tableView)
        tableView.setAnchor(top: viewcolumn.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: bandCellId, for: indexPath) as! BandCell
        
        if indexPath.row == 0{
            cell.Label.text = "Número de Captações: \(self.arrCaptacoes[indexPath.row])"
            cell.colorView.backgroundColor = UIColor.hexStr(hexStr: "ff0066", alpha: 1)
            
        }else if indexPath.row == 1{
            cell.Label.text = "Número de Visitas: \(self.arrCaptacoes[indexPath.row])"
            cell.colorView.backgroundColor = UIColor.hexStr(hexStr: "22324c", alpha: 1)
            
        }else{
            cell.Label.text = "Número de Propostas: \(self.arrCaptacoes[indexPath.row])"
            cell.colorView.backgroundColor = UIColor.hexStr(hexStr: "ff9933", alpha: 1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Janeiro"
        }else if section == 1{
            return "Fevereiro"
        }else if section == 2{
            return "Março"
        }else if section == 3{
            return "Abril"
        }else if section == 4{
            return "Maio"
        }else if section == 5{
            return "Junho"
        }else if section == 6{
            return "Julho"
        }else if section == 7{
            return "Agosto"
        }else if section == 8{
            return "Setembro"
        }else if section == 9{
            return "Outubro"
        }else if section == 10{
            return "Novembro"
        }
        return "Dezembro"
    }
    
    class BandCell: UITableViewCell{
        let cellView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.white
            view.setCellShadow()
            return view
        }()
        
        let colorView: UIView = {
            let cv = UIView()
            cv.contentMode = .scaleAspectFit
            cv.backgroundColor = UIColor.darkGray
            return cv
        }()
        
        let Label: UILabel = {
            let label = UILabel()
            label.text = ""
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.textColor = UIColor.darkGray
            return label
        }()
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setup()
        }
        
        func setup(){
            addSubview(cellView)
            cellView.addSubview(colorView)
            cellView.addSubview(Label)
            
            cellView.setAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 8)
            
            colorView.setAnchor(top: nil, left: cellView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 12.5, height: 12.5)
            colorView.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
            
            Label.setAnchor(top: nil, left: colorView.leftAnchor, bottom: nil, right: cellView.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: colorView.frame.width - 25, height: 20)
            Label.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    func configureAAChartColumn() {
        aaChartViewColumn = AAChartView()
        aaChartViewColumn?.scrollEnabled = false
        let chartViewWidth = viewcolumn.frame.size.width
        let chartViewHeight = viewcolumn.frame.size.height
        aaChartViewColumn?.frame = CGRect(x: 0,
                                          y: 0,
                                          width: chartViewWidth,
                                          height: chartViewHeight)
        
        aaChartViewColumn?.contentHeight = chartViewHeight - 20
        viewcolumn.addSubview(aaChartViewColumn!)
        aaChartViewColumn?.isClearBackgroundColor = true
        
        aaChartModelColumn = AAChartModel()
            .chartType(.column)
            .categories(["Jan", "Fev", "Mar", "Abr", "Mai", "Jun","Jul", "Ago", "Set", "Out", "Nov", "Dez"])
            .legendEnabled(true)
            .colorsTheme(["#ff0066","#22324c","#ff9933"])
            .axisColor("#000000")
            .title("Minha Análise Gráfica")
            .subtitle("Seven 2019")
            .dataLabelEnabled(false)
            .tooltipValueSuffix("")
            .animationType(.bounce)
            .backgroundColor("#ffffff")
            //aaChartView?.isClearBackgroundColor = true
            .series([
                AASeriesElement()
                    .name("Captações")
                    //cada posicao no array deve conter o numero por mes
                    .data([Int.random(in: 0 ... 100),Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100)])
                    .toDic()!,
                AASeriesElement()
                    .name("Visitas")
                    .data([Int.random(in: 0 ... 100),Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100)])
                    .toDic()!,
                AASeriesElement()
                    .name("Propostas")
                    .data([Int.random(in: 0 ... 100),Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100), Int.random(in: 0 ... 100)])
                    .toDic()!
                ])
        
        aaChartViewColumn?.aa_drawChartWithChartModel(aaChartModelColumn!)
    }
    
    func kRGBColorFromHex(rgbValue: Int) -> (UIColor) {
        return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,
                       alpha: 1.0)
    }
    
}

extension BarChartAndTableVC: KSTokenViewDelegate {
    func tokenView(_ tokenView: KSTokenView, performSearchWithString string: String, completion: ((_ results: Array<AnyObject>) -> Void)?) {
        if (string.characters.isEmpty){
            completion!(names as Array<AnyObject>)
            return
        }
        
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
        print("adicionou:" ,token)
    }
    
    func tokenView(_ tokenView: KSTokenView, didDeleteToken token: KSToken) {
        print("removeu:" ,token)
    }
    
    func tokenView(_ tokenView: KSTokenView, didSelectToken token: KSToken) {
        print("selecionou:" ,token)
    }
}
