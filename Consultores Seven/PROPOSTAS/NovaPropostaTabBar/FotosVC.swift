//
//  EscolherTipoVC.swift
//  Consultores Seven
//
//  Created by Juliano Gouveia on 15/10/2018.
//  Copyright © 2018 Juliano Gouveia. All rights reserved.
//

import UIKit
import Static
import KRProgressHUD
import FirebaseFirestore
import CFAlertViewController

class FotosVC: UIViewController,EPSignatureDelegate {
    
    let db = Firestore.firestore()
    
    let cpf_user = KeychainWrapper.standard.string(forKey: "CPF")
    let id_user = KeychainWrapper.standard.integer(forKey: "ID")
    let nome_user = KeychainWrapper.standard.string(forKey: "NOME")
    var tpSeguro: String!
    var tpVeic: String!
    var propostaEscolhida: Proposta!
    
    var alertController: CFAlertViewController!
    var checkBox = M13Checkbox(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    var bttnProsseguir = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
    
    @IBOutlet weak var viewFooter: UIView!
    
    @IBOutlet weak var assinaturaBttn: UIButton!
    @IBOutlet weak var assinaturaLbl: UILabel!
    
    @IBOutlet weak var avariaBttn: UIButton!
    @IBOutlet weak var avariaLbl: UILabel!
    
    @IBOutlet weak var vidroBttn: UIButton!
    @IBOutlet weak var vidroLbl: UILabel!
    
    @IBOutlet weak var perfilBttn: UIButton!
    @IBOutlet weak var perfilLbl: UILabel!
    
    @IBOutlet weak var documentacaoBttn: UIButton!
    @IBOutlet weak var documentacaoLbl: UILabel!
    
    @IBOutlet weak var dutBttn: UIButton!
    @IBOutlet weak var dutLbl: UILabel!
    
    @IBOutlet weak var frontalBttn: UIButton!
    @IBOutlet weak var frontalLbl: UILabel!
    
    @IBOutlet weak var lateraisBttn: UIButton!
    @IBOutlet weak var lateraisLbl: UILabel!
    
    @IBOutlet weak var traseiraBttn: UIButton!
    @IBOutlet weak var traseiraLbl: UILabel!
    
    @IBOutlet weak var portamalasBttn: UIButton!
    @IBOutlet weak var portamalasLbl: UILabel!
    
    @IBOutlet weak var tetoBttn: UIButton!
    @IBOutlet weak var tetoLbl: UILabel!
    
    @IBOutlet weak var motorBttn: UIButton!
    @IBOutlet weak var motorLbl: UILabel!
    
    @IBOutlet weak var chassiBttn: UIButton!
    @IBOutlet weak var chassiLbl: UILabel!
    
    @IBOutlet weak var velocimetroBttn: UIButton!
    @IBOutlet weak var velocimetroLbl: UILabel!
    
    @IBOutlet weak var estofadosBttn: UIButton!
    @IBOutlet weak var estofadosLbl: UILabel!
    
    @IBOutlet weak var lanternaBttn: UIButton!
    @IBOutlet weak var lanternaLbl: UILabel!
    
    @IBOutlet weak var faroisBttn: UIButton!
    @IBOutlet weak var faroisLbl: UILabel!
    
    @IBOutlet weak var pneusBttn: UIButton!
    @IBOutlet weak var pneusLbl: UILabel!
    
    @IBOutlet weak var videoBttn: UIButton!
    @IBOutlet weak var videoLbl: UILabel!
    
    @IBOutlet weak var placalacreBttn: UIButton!
    @IBOutlet weak var placalacreLbl: UILabel!
    
    @IBOutlet weak var superiormotoBttn: UIButton!
    @IBOutlet weak var superiormotoLbl: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        updateCount()
        print(propostaEscolhida.tpveiculo)
        assinaturaBttn.isHidden = false
        avariaBttn.isHidden = false
        vidroBttn.isHidden = false
        perfilBttn.isHidden = false
        documentacaoBttn.isHidden = false
        dutBttn.isHidden = false
        frontalBttn.isHidden = false
        lateraisBttn.isHidden = false
        traseiraBttn.isHidden = false
        portamalasBttn.isHidden = false
        tetoBttn.isHidden = false
        motorBttn.isHidden = false
        chassiBttn.isHidden = false
        velocimetroBttn.isHidden = false
        estofadosBttn.isHidden = false
        lanternaBttn.isHidden = false
        faroisBttn.isHidden = false
        pneusBttn.isHidden = false
        videoBttn.isHidden = false
        placalacreBttn.isHidden = false
        superiormotoBttn.isHidden = false
        
        assinaturaLbl.isHidden = false
        avariaLbl.isHidden = false
        vidroLbl.isHidden = false
        perfilLbl.isHidden = false
        documentacaoLbl.isHidden = false
        dutLbl.isHidden = false
        frontalLbl.isHidden = false
        lateraisLbl.isHidden = false
        traseiraLbl.isHidden = false
        portamalasLbl.isHidden = false
        tetoLbl.isHidden = false
        motorLbl.isHidden = false
        chassiLbl.isHidden = false
        velocimetroLbl.isHidden = false
        estofadosLbl.isHidden = false
        lanternaLbl.isHidden = false
        faroisLbl.isHidden = false
        pneusLbl.isHidden = false
        videoLbl.isHidden = false
        placalacreLbl.isHidden = false
        superiormotoLbl.isHidden = false
        
        escondeBotoes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func escondeBotoes(){
        db.collection("ConsultorSeven").document("MinhasPropostas").collection("\(self.id_user!)").document("\(self.propostaEscolhida.id!)").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                let dictionary = querySnapshot!.data()
                
                if dictionary?["avarias"] as? Bool ?? false == false{
                    self.avariaBttn.isHidden = true
                    self.avariaLbl.isHidden = true
                }
                
                if dictionary?["protvidro"] as? Bool ?? false == false && (dictionary?["pctpremio15"] as? Bool ?? false) == false && (dictionary?["pctpremio30"] as? Bool ?? false) == false{
                    self.vidroBttn.isHidden = true
                    self.vidroLbl.isHidden = true
                }
                
                if (dictionary?["seguro"] as? String ?? "0") == "1"{
                    self.tpSeguro = "1"
                    if (dictionary?["tpveiculo"] as? String ?? "0") == "1"{
                        
                        self.placalacreBttn.isHidden = true
                        self.superiormotoBttn.isHidden = true
                        self.placalacreLbl.isHidden = true
                        self.superiormotoLbl.isHidden = true
                        
                    }else if (dictionary?["tpveiculo"] as? String ?? "0") == "2"{
                        
                        self.portamalasBttn.isHidden = true
                        self.tetoBttn.isHidden = true
                        self.estofadosBttn.isHidden = true
                        self.lanternaBttn.isHidden = true
                        self.faroisBttn.isHidden = true
                    
                        self.portamalasLbl.isHidden = true
                        self.tetoLbl.isHidden = true
                        self.estofadosLbl.isHidden = true
                        self.lanternaLbl.isHidden = true
                        self.faroisLbl.isHidden = true
                        
                    }
                  
                }else if (dictionary?["seguro"] as? String ?? "0") == "3"{
                    self.tpSeguro = "3"
                    self.assinaturaBttn.isHidden = true
                    self.perfilBttn.isHidden = true
                    self.documentacaoBttn.isHidden = true
                    self.dutBttn.isHidden = true
                    self.vidroBttn.isHidden = true
                    self.avariaBttn.isHidden = true
                    self.portamalasBttn.isHidden = true
                    self.tetoBttn.isHidden = true
                    self.motorBttn.isHidden = true
                    self.velocimetroBttn.isHidden = true
                    self.estofadosBttn.isHidden = true
                    self.lanternaBttn.isHidden = true
                    self.faroisBttn.isHidden = true
                    self.pneusBttn.isHidden = true
                    self.superiormotoBttn.isHidden = true
                    
                    self.assinaturaLbl.isHidden = true
                    self.perfilLbl.isHidden = true
                    self.documentacaoLbl.isHidden = true
                    self.dutLbl.isHidden = true
                    self.vidroLbl.isHidden = true
                    self.avariaLbl.isHidden = true
                    self.portamalasLbl.isHidden = true
                    self.tetoLbl.isHidden = true
                    self.motorLbl.isHidden = true
                    self.velocimetroLbl.isHidden = true
                    self.estofadosLbl.isHidden = true
                    self.lanternaLbl.isHidden = true
                    self.faroisLbl.isHidden = true
                    self.pneusLbl.isHidden = true
                    self.superiormotoLbl.isHidden = true
                    
                }else if (dictionary?["seguro"] as? String ?? "0") == "2"{
                    self.tpSeguro = "2"
                    if (dictionary?["tpveiculo"] as? String ?? "0") == "1"{
                        self.tpVeic = "1"
                        self.placalacreBttn.isHidden = true
                        self.superiormotoBttn.isHidden = true
                        
                        self.placalacreLbl.isHidden = true
                        self.superiormotoLbl.isHidden = true
                    }else if (dictionary?["tpveiculo"] as? String ?? "0") == "2"{
                        self.tpVeic = "2"
                        self.portamalasBttn.isHidden = true
                        self.tetoBttn.isHidden = true
                        self.estofadosBttn.isHidden = true
                        self.lanternaBttn.isHidden = true
                        self.faroisBttn.isHidden = true
                        
                        self.portamalasLbl.isHidden = true
                        self.tetoLbl.isHidden = true
                        self.estofadosLbl.isHidden = true
                        self.lanternaLbl.isHidden = true
                        self.faroisLbl.isHidden = true
                    }
                    
                }
                
            }
        }
    }
    
    func updateCount(){
        db.collection("ConsultorSeven").document("FotosPropostas").collection("\(self.id_user!)").document("\(self.propostaEscolhida.id!)").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                let dictionary = querySnapshot!.data()
                var countAvarias = 0
                for i in 1...10{
                    if dictionary?["avaria\(i)_st"] as? String ?? "" != ""{
                       countAvarias = countAvarias + 1
                    }
                }
                self.avariaLbl.text = "\(countAvarias)/10"
                
                var countAssinatura = 0
                if dictionary?["vistoria_str"] as? String ?? "" != ""{
                    countAssinatura = countAssinatura + 1
                }
                self.assinaturaLbl.text = "\(countAssinatura)/1"
                
                var countPerfil = 0
                if dictionary?["proposta_st"] as? String ?? "" != ""{
                    countPerfil = countPerfil + 1
                }
                self.perfilLbl.text = "\(countPerfil)/1"
                
                var countDoc = 0
                for i in 1...4{
                    if dictionary?["doc\(i)_st"] as? String ?? "" != ""{
                        countDoc = countDoc + 1
                    }
                }
                self.documentacaoLbl.text = "\(countDoc)/4"
                
                var countDut = 0
                if dictionary?["dut_st"] as? String ?? "" != ""{
                    countDut = countDut + 1
                }
                 self.dutLbl.text = "\(countDut)/1"
                
                var countFrontal = 0
                for i in 1...2{
                    if dictionary?["fronta\(i)_st"] as? String ?? "" != ""{
                        countFrontal = countFrontal + 1
                    }
                }
                self.frontalLbl.text = "\(countFrontal)/2"
                
                var countLateral = 0
                for i in 1...4{
                    if dictionary?["lat\(i)_st"] as? String ?? "" != ""{
                        countLateral = countLateral + 1
                    }
                }
                self.lateraisLbl.text = "\(countLateral)/4"
                
                var counttraseira = 0
                if dictionary?["traseira_st"] as? String ?? "" != ""{
                    counttraseira = counttraseira + 1
                }
                self.traseiraLbl.text = "\(counttraseira)/1"
                
                var countvidros = 0
                for i in 1...12{
                    if dictionary?["vidro\(i)_st"] as? String ?? "" != ""{
                        countvidros = countvidros + 1
                    }
                }
                 self.vidroLbl.text = "\(countvidros)/12"
                
                var countPortaMalas = 0
                if dictionary?["p_malas_st"] as? String ?? "" != ""{
                    countPortaMalas = countPortaMalas + 1
                }
                self.portamalasLbl.text = "\(countPortaMalas)/1"
                
                var countTeto = 0
                if dictionary?["teto_st"] as? String ?? "" != ""{
                    countTeto = countTeto + 1
                }
                self.tetoLbl.text = "\(countTeto)/1"
                
                var countMotor = 0
                if dictionary?["motor_st"] as? String ?? "" != ""{
                    countMotor = countMotor + 1
                }
                self.motorLbl.text = "\(countMotor)/1"
                
                var countChassi = 0
                if dictionary?["chassi_st"] as? String ?? "" != ""{
                    countChassi = countChassi + 1
                }
                self.chassiLbl.text = "\(countChassi)/1"
                
                var countVelocimetro = 0
                if dictionary?["veloc_st"] as? String ?? "" != ""{
                    countVelocimetro = countVelocimetro + 1
                }
                self.velocimetroLbl.text = "\(countVelocimetro)/1"
                
                var countEstofados = 0
                for i in 1...4{
                    if dictionary?["esto\(i)_st"] as? String ?? "" != ""{
                        countEstofados = countEstofados + 1
                    }
                }
                self.estofadosLbl.text = "\(countEstofados)/4"
                
                var countLanterna = 0
                for i in 1...2{
                    if dictionary?["lanterna\(i)_st"] as? String ?? "" != ""{
                        countLanterna = countLanterna + 1
                    }
                }
                self.lanternaLbl.text = "\(countLanterna)/2"
                
                var countFarois = 0
                for i in 1...2{
                    if dictionary?["farol\(i)_st"] as? String ?? "" != ""{
                        countFarois = countFarois + 1
                    }
                }
                self.faroisLbl.text = "\(countFarois)/2"
                
                var countpneus = 0
                for i in 1...6{
                    if dictionary?["pneu\(i)_st"] as? String ?? "" != ""{
                        countpneus = countpneus + 1
                    }
                }
                self.pneusLbl.text = "\(countpneus)/6"
                
                var countPlacaLacre = 0
                if dictionary?["veloc_st"] as? String ?? "" != ""{
                    countPlacaLacre = countPlacaLacre + 1
                }
                self.placalacreLbl.text = "\(countPlacaLacre)/1"
                
                var countVideo = 0
                if dictionary?["video_vistoria"] as? String ?? "" != ""{
                    countVideo = countVideo + 1
                }
                self.videoLbl.text = "\(countVideo)/1"
                
            }
        }
    }
    
    func checkCampos(){
       
        if self.lateraisLbl.text != "4/4"{
            self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "As fotos laterais são obrigatórias!", acaoAlerta: "Ok")
            return
        }else if self.frontalLbl.text != "2/2"{
            self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "As fotos frontais são obrigatórias!", acaoAlerta: "Ok")
            return
        }else if self.traseiraLbl.text != "1/1"{
            self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "As foto traseira é obrigatória!", acaoAlerta: "Ok")
            return
        }
        if self.tpVeic == "2"{
            if self.superiormotoLbl.text != "1/1"{
                self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "A foto do superior da moto é obrigatória!", acaoAlerta: "Ok")
                return
            }
        }
        
        if self.tpSeguro == "3"{
            if self.placalacreLbl.text != "1/1"{
                self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "A foto da placa com lacre é obrigatória!", acaoAlerta: "Ok")
                return
            }
        }else if self.tpSeguro != "3"{
            if self.perfilLbl.text != "1/1"{
                self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "A foto do perfil é obrigatória!", acaoAlerta: "Ok")
                return
            }else if self.assinaturaLbl.text != "1/1"{
                self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "As foto da assinatura é obrigatória!", acaoAlerta: "Ok")
                return
            }else if self.documentacaoLbl.text != "4/4"{
                self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "As fotos da documentação são obrigatórias!", acaoAlerta: "Ok")
                return
            }else if self.dutLbl.text != "1/1"{
                self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "A foto do dut é obrigatória!", acaoAlerta: "Ok")
                return
            }else if self.motorLbl.text != "1/1"{
                self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "A foto do motor é obrigatória!", acaoAlerta: "Ok")
                return
            }else if self.chassiLbl.text != "1/1"{
                self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "A foto do chassi é obrigatória!", acaoAlerta: "Ok")
                return
            }else if self.velocimetroLbl.text != "1/1"{
                self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "A foto do velocímetro é obrigatória!", acaoAlerta: "Ok")
                return
            }else if self.pneusLbl.text != "6/6"{
                self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "As fotos dos pneus são obrigatórias!", acaoAlerta: "Ok")
                return
            }
        }
        
        
        db.collection("ConsultorSeven").document("MinhasPropostas").collection("\(self.id_user!)").document("\(self.propostaEscolhida.id!)").getDocument { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let dataDescription = querySnapshot!.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                let dictionary = querySnapshot!.data()
                
                //check se está pago
                if dictionary?["situacao"] as? String != "4" && dictionary?["situacao"] as? String != "3"{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa pagar antes de enviar a proposta!", acaoAlerta: "Ok")
                }else
                
                //check campos associado
                
                
                if dictionary?["nome"] as? String == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["mae"] as? String == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["cpfcnpj"] as? String == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["rg"] as? String == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["cnh"] as? String == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["dtnasc"] as? String == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["celular"] as? String == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["telefone"] as? String == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["email"] as? String == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["cep"] as? String == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["cidade"] as? String == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["uf"] as? String == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["bairro"] as? String == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["logradouro"] as? String == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["num_residencia"] as? String == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                    
                    
                // check campos veiculo
                    
                    
                if dictionary?["anofabricacao"] as? String == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["anomodelo"] as? String == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["fipe"] as? String == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["valorveiculo"] as? String == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["ddltabela"] as? String == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["placa"] as? String == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["renavam"] as? String == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["chassi"] as? String == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["combustivel"] as? String == "0"{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["cor"] as? String == "0"{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                    
                    
                // check campos adesao
                    
                    
                if dictionary?["valoradesao"] as? String ?? "" == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["valormensal"] as? String ?? "" == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["dtvistoria"] as? String ?? "" == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else
                if dictionary?["dtproposta"] as? String ?? "" == ""{
                    self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Você precisa preencher e salvar todos os campos!", acaoAlerta: "Ok")
                }else{
                   
                    let screenSize: CGRect = UIScreen.main.bounds
                    let footerview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
                    footerview.backgroundColor = UIColor.white
                   
                    
                    self.checkBox.backgroundColor = UIColor.clear
                    self.checkBox.tintColor = UIColor.black
                    self.checkBox.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
                    self.checkBox.widthAnchor.constraint(equalToConstant: 45.0).isActive = true
                    
                    //Text Label
                    let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 120))
                    textLabel.backgroundColor = UIColor.clear
                    textLabel.textColor = UIColor.black
                    textLabel.adjustsFontSizeToFitWidth = true
                    textLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
                    textLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
                    textLabel.text  = "Confirmo que TODAS as informações estão corretas"
                    textLabel.font = UIFont(name: "System-Bold", size: 17.0)
                    textLabel.textAlignment = .left
                    
                  
                    //Stack View
                    let stackView = UIStackView()
                    stackView.axis  = UILayoutConstraintAxis.horizontal
                    stackView.distribution  = UIStackViewDistribution.equalSpacing
                    stackView.alignment = UIStackViewAlignment.center
                    stackView.spacing   = 5.0
                    
                    stackView.addArrangedSubview(self.checkBox)
                    stackView.addArrangedSubview(textLabel)
                    stackView.translatesAutoresizingMaskIntoConstraints = false
                    
                        //bttn
                   self.bttnProsseguir = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
                   self.bttnProsseguir.backgroundColor = UIColor.blue
                   self.bttnProsseguir.setTitle("Prosseguir", for: .normal)
                   self.bttnProsseguir.setTitleColor(UIColor.white, for: .normal)
                    
                    
                    let stackView2   = UIStackView()
                    stackView2.axis  = UILayoutConstraintAxis.vertical
                    stackView2.distribution  = UIStackViewDistribution.equalSpacing
                    stackView2.alignment = UIStackViewAlignment.center
                    stackView2.spacing   = 0.0
                    
                    stackView2.addArrangedSubview(stackView)
                    stackView2.addArrangedSubview(self.bttnProsseguir)
                    stackView2.translatesAutoresizingMaskIntoConstraints = false
                    
                    footerview.addSubview(stackView2)
                    
                    //Constraints
                    stackView2.topAnchor.constraint(equalTo: footerview.topAnchor).isActive = true
                    stackView2.bottomAnchor.constraint(equalTo: footerview.bottomAnchor).isActive = true
                    stackView2.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
                    stackView2.leadingAnchor.constraint(equalTo: footerview.leadingAnchor).isActive = true
                    stackView2.trailingAnchor.constraint(equalTo: footerview.trailingAnchor).isActive = true
                    
                    //Constraints
                    self.bttnProsseguir.leadingAnchor.constraint(equalTo: stackView2.leadingAnchor).isActive = true
                    self.bttnProsseguir.trailingAnchor.constraint(equalTo: stackView2.trailingAnchor).isActive = true
                    
                
                
                    self.alertController = CFAlertViewController(title: "POR FAVOR, CONFIRME AS INFORMAÇÕES A SEGUIR", titleColor: UIColor.black, message: " Nome: \(dictionary!["nome"] as! String) \n CPF/CNPJ: \(dictionary?["cpfcnpj"] as! String) \n RG: \(dictionary?["rg"] as! String) \n Data de Nascimento: \(dictionary?["dtnasc"] as! String) \n Email: \(dictionary?["email"] as! String) \n Celular: \(dictionary?["celular"] as! String) \n Telefone: \(dictionary?["telefone"] as! String) \n CNH: \(dictionary?["cnh"] as! String) \n Mãe: \(dictionary?["mae"] as! String) \n CEP: \(dictionary?["cep"] as! String) \n UF: \(dictionary?["uf"] as! String) \n Cidade: \(dictionary?["cidade"] as! String) \n Bairro: \(dictionary?["bairro"] as! String) \n Logradouro: \(dictionary?["logradouro"] as! String) \n Número: \(dictionary?["num_residencia"] as! String) \n Ano de Fabricação: \(dictionary?["anofabricacao"] as! String) \n Ano do Modelo: \(dictionary?["anomodelo"] as! String) \n FIPE: \(dictionary?["fipe"] as! String) \n Placa: \(dictionary?["placa"] as! String) \n Renavam: \(dictionary?["renavam"] as! String) \n Chassi: \(dictionary?["chassi"] as! String) \n Valor Mensal: \(dictionary?["valorveiculo"] as! String) \n Tabela: \(dictionary?["ddltabela"] as! String) \n Observação: \(dictionary?["obs"] as! String) \n Data da Vistoria: \(dictionary?["dtvistoria"] as! String) \n Data da Proposta: \(dictionary?["dtproposta"] as! String)", messageColor: UIColor.darkGray, textAlignment: .left, preferredStyle: .alert, headerView: nil, footerView: footerview, didDismissAlertHandler: nil)
                  
                    self.bttnProsseguir.addTarget(self, action: #selector(self.MandaTelaEnvio), for: .touchUpInside)
                    // Present Alert View Controller
                    self.present(self.alertController, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    func getMotivoPermissao(){
        let alertController = UIAlertController(title: "Permissão", message: "Escreva o motivo do pedido.", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Motivo"
        }
        let cancelarCap = UIAlertAction(title: "Pronto", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            if firstTextField.text! != ""{
                KRProgressHUD.show()
                let usersReference = self.db.collection("ConsultorSeven").document("MotivosPermissoes").collection("\(self.id_user!)").document("\(self.propostaEscolhida.id!)")
                
                let values = ["motivoPermissao": firstTextField.text!, "placa": self.propostaEscolhida.placa!]  as [String : Any]
                
                usersReference.setData(values) { (error) in
                    if error != nil{
                        print("erro ao cadastrar no firebase", error)
                        self.CriarAlerta(tituloAlerta: "Erro", mensagemAlerta: "Erro ao salvar dados no servidor!", acaoAlerta: "OK", erroRecebido: "\(error)")
                        KRProgressHUD.dismiss()
                        return
                    }else{
                        let vc = UIStoryboard(name: "Proposta", bundle: nil).instantiateViewController(withIdentifier: "PediuPermissaoVC") as! PediuPermissaoVC
                        vc.propostaEscolhida = self.propostaEscolhida
                        self.navigationController?.pushViewController(vc, animated: true)
                        KRProgressHUD.dismiss()
                    }
                }
              
                
            }else{
                self.CriarAlertaSemErro(tituloAlerta: "Ops", mensagemAlerta: "Você precisa escrever o motivo!", acaoAlerta: "OK")
            }
            
            
        })
        let voltar = UIAlertAction(title: "Voltar", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        
        alertController.addAction(voltar)
        alertController.addAction(cancelarCap)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //then make a action method :
    
    func MandaTelaEnvio(sender: UIButton!) {
        if self.checkBox.isChecked == true{
         
            let alert = CFAlertViewController(title: "ATENÇÃO", message: "Como deseja prosseguir?", textAlignment: .center, preferredStyle: .alert, didDismissAlertHandler: nil)
            
            let enviar = CFAlertAction(title: "Enviar Proposta", style: .Default, alignment: .center, backgroundColor: UIColor(red: 0, green: 26, blue: 94), textColor: UIColor.white) { (action) in
                let vc = UIStoryboard(name: "Proposta", bundle: nil).instantiateViewController(withIdentifier: "EnviarTudoVC") as! EnviarTudoVC
                vc.propostaEscolhida = self.propostaEscolhida
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
            let pedirPermissao = CFAlertAction(title: "Pedir Permissão", style: .Default, alignment: .center, backgroundColor: UIColor(red: 0, green: 26, blue: 94), textColor: UIColor.white) { (action) in
                self.getMotivoPermissao()
            }
            
            alert.addAction(enviar)
            alert.addAction(pedirPermissao)
            
            self.checkBox.setCheckState(.unchecked, animated: true)
            self.alertController.dismissAlert(withAnimation: true) {
              self.present(alert, animated: true, completion: nil)
            }
        }else{
            UIView.animate(withDuration: 0.4, animations: {
                self.bttnProsseguir.backgroundColor = UIColor.red
            }) { (true) in
                UIView.animate(withDuration: 0.4, animations: {
                    self.bttnProsseguir.backgroundColor = UIColor.blue
                }, completion: nil)
            }
        }
        
    }
    
    @IBAction func clicouAssinatura(_ sender: AnyObject){
        let signatureVC = EPSignatureViewController(signatureDelegate: self, showsDate: true, showsSaveSignatureOption: false)
        signatureVC.subtitleText = "Eu concordo com todos os termos e condições"
        signatureVC.title = ""
        signatureVC.propostaEscolhida = self.propostaEscolhida
        let nav = UINavigationController(rootViewController: signatureVC)
        present(nav, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }
    
    
    func epSignature(_: EPSignatureViewController, didCancel error: NSError) {
        print("didcancel")
    }
    
    func epSignature(_: EPSignatureViewController, didSign imagem: UIImage, boundingRect: CGRect) {
        
        let data1 = UIImagePNGRepresentation(imagem)
        
        if let fotoComprimida = self.colocaLogo(imgData: data1!).jpeg(.lowest) {
            print("data1.count => \(data1!.count) \n fotoComprimida.count => \(fotoComprimida.count)" )
            
            self.enviaFotoStorage(nomeImg: "vistoria_str", imagemDados: fotoComprimida, id_user: "\(self.id_user!)", proposta: self.propostaEscolhida)
            
        }
    }
    
    func enviarProposta(){
        
        checkCampos()
        
        
    }
    
    @IBAction func clicouVideo(_ sender: AnyObject){
        var storyboard = UIStoryboard(name: "FotosProposta", bundle: nil)
        var ivc = storyboard.instantiateViewController(withIdentifier: "VideoVistoriaVC") as! VideoVistoriaVC
        ivc.modalTransitionStyle = .coverVertical
        ivc.propostaEscolhida = self.propostaEscolhida
        self.navigationController?.pushViewController(ivc, animated: true)
    }
    
    @IBAction func clicouPerfil(_ sender: AnyObject){
        var storyboard = UIStoryboard(name: "FotosProposta", bundle: nil)
        var ivc = storyboard.instantiateViewController(withIdentifier: "Perfil") as! Perfil
        ivc.modalTransitionStyle = .coverVertical
        ivc.propostaEscolhida = self.propostaEscolhida
        self.navigationController?.pushViewController(ivc, animated: true)
    }
    
    @IBAction func clicouDoc(_ sender: AnyObject){
        var storyboard = UIStoryboard(name: "FotosProposta", bundle: nil)
        var ivc = storyboard.instantiateViewController(withIdentifier: "DocumentacaoVC") as! DocumentacaoVC
        ivc.modalTransitionStyle = .coverVertical
        ivc.propostaEscolhida = self.propostaEscolhida
        self.navigationController?.pushViewController(ivc, animated: true)
    }
    @IBAction func clicouDut(_ sender: AnyObject){
        var storyboard = UIStoryboard(name: "FotosProposta", bundle: nil)
        var ivc = storyboard.instantiateViewController(withIdentifier: "Dut") as! Dut
        ivc.modalTransitionStyle = .coverVertical
        ivc.propostaEscolhida = self.propostaEscolhida
        self.navigationController?.pushViewController(ivc, animated: true)
    }
    @IBAction func clicouFrontal(_ sender: AnyObject){
        var storyboard = UIStoryboard(name: "FotosProposta", bundle: nil)
        var ivc = storyboard.instantiateViewController(withIdentifier: "Frontal") as! Frontal
        ivc.modalTransitionStyle = .coverVertical
        ivc.propostaEscolhida = self.propostaEscolhida
        self.navigationController?.pushViewController(ivc, animated: true)
    }
    
    @IBAction func clicouLateral(_ sender: AnyObject){
        var storyboard = UIStoryboard(name: "FotosProposta", bundle: nil)
        var ivc = storyboard.instantiateViewController(withIdentifier: "Laterais") as! Laterais
        ivc.modalTransitionStyle = .coverVertical
        ivc.propostaEscolhida = self.propostaEscolhida
        self.navigationController?.pushViewController(ivc, animated: true)
    }

    @IBAction func clicouVidro(_ sender: AnyObject){
        var storyboard = UIStoryboard(name: "FotosProposta", bundle: nil)
        var ivc = storyboard.instantiateViewController(withIdentifier: "Vidro") as! Vidro
        ivc.modalTransitionStyle = .coverVertical
        ivc.propostaEscolhida = self.propostaEscolhida
        self.navigationController?.pushViewController(ivc, animated: true)
    }
    
    @IBAction func clicouTraseira(_ sender: AnyObject){
        var storyboard = UIStoryboard(name: "FotosProposta", bundle: nil)
        var ivc = storyboard.instantiateViewController(withIdentifier: "Traseira") as! Traseira
        ivc.modalTransitionStyle = .coverVertical
        ivc.propostaEscolhida = self.propostaEscolhida
        self.navigationController?.pushViewController(ivc, animated: true)
    }
    
    @IBAction func clicouPortaMalas(_ sender: AnyObject){
        var storyboard = UIStoryboard(name: "FotosProposta", bundle: nil)
        var ivc = storyboard.instantiateViewController(withIdentifier: "PortaMalas") as! PortaMalas
        ivc.modalTransitionStyle = .coverVertical
        ivc.propostaEscolhida = self.propostaEscolhida
        self.navigationController?.pushViewController(ivc, animated: true)
    }
    
    @IBAction func clicouTeto(_ sender: AnyObject){
        var storyboard = UIStoryboard(name: "FotosProposta", bundle: nil)
        var ivc = storyboard.instantiateViewController(withIdentifier: "Teto") as! Teto
        ivc.modalTransitionStyle = .coverVertical
        ivc.propostaEscolhida = self.propostaEscolhida
        self.navigationController?.pushViewController(ivc, animated: true)
    }
    
    @IBAction func clicouMotor(_ sender: AnyObject){
        var storyboard = UIStoryboard(name: "FotosProposta", bundle: nil)
        var ivc = storyboard.instantiateViewController(withIdentifier: "Motor") as! Motor
        ivc.modalTransitionStyle = .coverVertical
        ivc.propostaEscolhida = self.propostaEscolhida
        self.navigationController?.pushViewController(ivc, animated: true)
    }
    
    @IBAction func clicouChassi(_ sender: AnyObject){
        var storyboard = UIStoryboard(name: "FotosProposta", bundle: nil)
        var ivc = storyboard.instantiateViewController(withIdentifier: "Chassi") as! Chassi
        ivc.modalTransitionStyle = .coverVertical
        ivc.propostaEscolhida = self.propostaEscolhida
        self.navigationController?.pushViewController(ivc, animated: true)
    }
    
    @IBAction func clicouVelocimetro(_ sender: AnyObject){
        var storyboard = UIStoryboard(name: "FotosProposta", bundle: nil)
        var ivc = storyboard.instantiateViewController(withIdentifier: "Velocimetro") as! Velocimetro
        ivc.modalTransitionStyle = .coverVertical
        ivc.propostaEscolhida = self.propostaEscolhida
        self.navigationController?.pushViewController(ivc, animated: true)
    }
    
    @IBAction func clicouEstofados(_ sender: AnyObject){
        var storyboard = UIStoryboard(name: "FotosProposta", bundle: nil)
        var ivc = storyboard.instantiateViewController(withIdentifier: "Estofados") as! Estofados
        ivc.modalTransitionStyle = .coverVertical
        ivc.propostaEscolhida = self.propostaEscolhida
        self.navigationController?.pushViewController(ivc, animated: true)
    }
    
    @IBAction func clicouLanterna(_ sender: AnyObject){
        var storyboard = UIStoryboard(name: "FotosProposta", bundle: nil)
        var ivc = storyboard.instantiateViewController(withIdentifier: "Lanterna") as! Lanterna
        ivc.modalTransitionStyle = .coverVertical
        ivc.propostaEscolhida = self.propostaEscolhida
        self.navigationController?.pushViewController(ivc, animated: true)
    }
    
    @IBAction func clicouFarois(_ sender: AnyObject){
        var storyboard = UIStoryboard(name: "FotosProposta", bundle: nil)
        var ivc = storyboard.instantiateViewController(withIdentifier: "Farois") as! Farois
        ivc.modalTransitionStyle = .coverVertical
        ivc.propostaEscolhida = self.propostaEscolhida
        self.navigationController?.pushViewController(ivc, animated: true)
    }
    
    @IBAction func clicouPneus(_ sender: AnyObject){
        var storyboard = UIStoryboard(name: "FotosProposta", bundle: nil)
        var ivc = storyboard.instantiateViewController(withIdentifier: "Pneus") as! Pneus
        ivc.modalTransitionStyle = .coverVertical
        ivc.propostaEscolhida = self.propostaEscolhida
        self.navigationController?.pushViewController(ivc, animated: true)
    }
    
    @IBAction func clicouPlacaLacre(_ sender: AnyObject){
        var storyboard = UIStoryboard(name: "FotosProposta", bundle: nil)
        var ivc = storyboard.instantiateViewController(withIdentifier: "PlacaLacre") as! PlacaLacre
        ivc.modalTransitionStyle = .coverVertical
        ivc.propostaEscolhida = self.propostaEscolhida
        self.navigationController?.pushViewController(ivc, animated: true)
    }
    
    @IBAction func clicouSuperiorMoto(_ sender: AnyObject){
        var storyboard = UIStoryboard(name: "FotosProposta", bundle: nil)
        var ivc = storyboard.instantiateViewController(withIdentifier: "SuperiorMoto") as! SuperiorMoto
        ivc.modalTransitionStyle = .coverVertical
        ivc.propostaEscolhida = self.propostaEscolhida
        self.navigationController?.pushViewController(ivc, animated: true)
    }
    
    @IBAction func clicouAvarias(_ sender: AnyObject){
        var storyboard = UIStoryboard(name: "FotosProposta", bundle: nil)
        var ivc = storyboard.instantiateViewController(withIdentifier: "Avarias") as! Avarias
        ivc.modalTransitionStyle = .coverVertical
        ivc.propostaEscolhida = self.propostaEscolhida
        self.navigationController?.pushViewController(ivc, animated: true)
    }
}
