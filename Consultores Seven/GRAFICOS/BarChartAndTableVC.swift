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

class BarChartAndTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cpf_user = KeychainWrapper.standard.string(forKey: "CPF")
    let id_user = KeychainWrapper.standard.integer(forKey: "ID")
    let nome_user = KeychainWrapper.standard.string(forKey: "NOME")
    
    
    var arrTotalCapMensal: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0]
    var arrTotalVisMensal: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0]
    var arrTotalPropMensal: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0]
    
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
    private var pageControl = UIPageControl(frame: .zero)
    
    //setup page control
    var scrollView = UIScrollView(frame: .zero)
    //var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    var arrViewsGraficos = [UIView]();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView(frame: CGRect(x:0, y:0, width:self.view.bounds.width,height: 260))
      //  configurePageControl()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        self.view.addSubview(scrollView)
       
        
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * 2,height: self.scrollView.frame.size.height)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)
        
        
        viewcolumn.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 200)
        viewcolumn.backgroundColor = UIColor.clear
        self.setupTableView()
        getCaptacoes()
        self.scrollView .addSubview(viewcolumn)
        for index in 0..<2 {
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
        }
    }
    

    func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    
    func getCaptacoes(){
        KRProgressHUD.show()
        let db = Firestore.firestore()
        db.collection("ConsultorSeven").document("Captacoes").collection("\(self.id_user!)").order(by: "data", descending: true).addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let dictionary = document.data()
                    
                    let mes = dictionary["mes"] as? String ?? ""
                    
                    switch mes{
                    case "Janeiro":
                        self.arrTotalCapMensal[0] = self.arrTotalCapMensal[0] + 1
                    case "Fevereiro":
                        self.arrTotalCapMensal[1] = self.arrTotalCapMensal[1] + 1
                    case "Março":
                        self.arrTotalCapMensal[2] = self.arrTotalCapMensal[2] + 1
                    case "Abril":
                        self.arrTotalCapMensal[3] = self.arrTotalCapMensal[3] + 1
                    case "Maio":
                        self.arrTotalCapMensal[4] = self.arrTotalCapMensal[4] + 1
                    case "Junho":
                        self.arrTotalCapMensal[5] = self.arrTotalCapMensal[5] + 1
                    case "Julho":
                        self.arrTotalCapMensal[6] = self.arrTotalCapMensal[6] + 1
                    case "Agosto":
                        self.arrTotalCapMensal[7] = self.arrTotalCapMensal[7] + 1
                    case "Setembro":
                        self.arrTotalCapMensal[8] = self.arrTotalCapMensal[8] + 1
                    case "Outubro":
                        self.arrTotalCapMensal[9] = self.arrTotalCapMensal[9] + 1
                    case "Novembro":
                        self.arrTotalCapMensal[10] = self.arrTotalCapMensal[10] + 1
                    case "Dezembro":
                        self.arrTotalCapMensal[11] = self.arrTotalCapMensal[11] + 1
                    default:
                        print("")
                    }
                    
                }
            }
            self.getVisitas()
        }
    }
    
    func getVisitas(){
        KRProgressHUD.show()
        let db = Firestore.firestore()
        db.collection("ConsultorSeven").document("Visitas").collection("\(self.id_user!)").order(by: "data", descending: true).addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let dictionary = document.data()
                    
                    let mes = dictionary["mes"] as? String ?? ""
                    
                    switch mes{
                    case "Janeiro":
                        self.arrTotalVisMensal[0] = self.arrTotalVisMensal[0] + 1
                    case "Fevereiro":
                        self.arrTotalVisMensal[1] = self.arrTotalVisMensal[1] + 1
                    case "Março":
                        self.arrTotalVisMensal[2] = self.arrTotalCapMensal[2] + 1
                    case "Abril":
                        self.arrTotalVisMensal[3] = self.arrTotalVisMensal[3] + 1
                    case "Maio":
                        self.arrTotalVisMensal[4] = self.arrTotalVisMensal[4] + 1
                    case "Junho":
                        self.arrTotalVisMensal[5] = self.arrTotalVisMensal[5] + 1
                    case "Julho":
                        self.arrTotalVisMensal[6] = self.arrTotalVisMensal[6] + 1
                    case "Agosto":
                        self.arrTotalVisMensal[7] = self.arrTotalVisMensal[7] + 1
                    case "Setembro":
                        self.arrTotalVisMensal[8] = self.arrTotalVisMensal[8] + 1
                    case "Outubro":
                        self.arrTotalVisMensal[9] = self.arrTotalVisMensal[9] + 1
                    case "Novembro":
                        self.arrTotalVisMensal[10] = self.arrTotalVisMensal[10] + 1
                    case "Dezembro":
                        self.arrTotalVisMensal[11] = self.arrTotalVisMensal[11] + 1
                    default:
                        print("")
                    }
                    
                }
            }
            self.getPropostas()
        }
    }
    
    func getPropostas(){
        KRProgressHUD.show()
        let db = Firestore.firestore()
        db.collection("ConsultorSeven").document("MinhasPropostas").collection("\(self.id_user!)").order(by: "data", descending: true).addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let dictionary = document.data()
                    
                    let mes = dictionary["mes"] as? String ?? ""
                    
                    switch mes{
                    case "Janeiro":
                        self.arrTotalPropMensal[0] = self.arrTotalPropMensal[0] + 1
                    case "Fevereiro":
                        self.arrTotalPropMensal[1] = self.arrTotalPropMensal[1] + 1
                    case "Março":
                        self.arrTotalPropMensal[2] = self.arrTotalPropMensal[2] + 1
                    case "Abril":
                        self.arrTotalPropMensal[3] = self.arrTotalPropMensal[3] + 1
                    case "Maio":
                        self.arrTotalPropMensal[4] = self.arrTotalPropMensal[4] + 1
                    case "Junho":
                        self.arrTotalPropMensal[5] = self.arrTotalPropMensal[5] + 1
                    case "Julho":
                        self.arrTotalPropMensal[6] = self.arrTotalPropMensal[6] + 1
                    case "Agosto":
                        self.arrTotalPropMensal[7] = self.arrTotalPropMensal[7] + 1
                    case "Setembro":
                        self.arrTotalPropMensal[8] = self.arrTotalPropMensal[8] + 1
                    case "Outubro":
                        self.arrTotalPropMensal[9] = self.arrTotalPropMensal[9] + 1
                    case "Novembro":
                        self.arrTotalPropMensal[10] = self.arrTotalPropMensal[10] + 1
                    case "Dezembro":
                        self.arrTotalPropMensal[11] = self.arrTotalPropMensal[11] + 1
                    default:
                        print("")
                    }
                    
                }
                
                KRProgressHUD.dismiss()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            self.configureAAChartColumn()
            KRProgressHUD.dismiss()
        }
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BandCell.self, forCellReuseIdentifier: bandCellId)
        
        view.addSubview(tableView)
        tableView.setAnchor(top: scrollView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
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
            cell.Label.text = "Número de Captações: \(self.arrTotalCapMensal[indexPath.section])"
            cell.colorView.backgroundColor = UIColor.hexStr(hexStr: "ff0066", alpha: 1)
            
        }else if indexPath.row == 1{
            cell.Label.text = "Número de Visitas: \(self.arrTotalVisMensal[indexPath.section])"
            cell.colorView.backgroundColor = UIColor.hexStr(hexStr: "22324c", alpha: 1)
            
        }else{
            cell.Label.text = "Número de Propostas: \(self.arrTotalPropMensal[indexPath.section])"
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
                    .data(self.arrTotalCapMensal)
                    .toDic()!,
                AASeriesElement()
                    .name("Visitas")
                    .data(self.arrTotalVisMensal)
                    .toDic()!,
                AASeriesElement()
                    .name("Propostas")
                    .data(self.arrTotalPropMensal)
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
