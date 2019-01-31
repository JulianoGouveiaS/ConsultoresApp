//
//  EPSignatureViewController.swift
//  Pods
//
//  Created by Prabaharan Elangovan on 13/01/16.
//
//

import UIKit



    // MARK: - EPSignatureDelegate
@objc public protocol EPSignatureDelegate {
    @objc optional    func epSignature(_: EPSignatureViewController, didCancel error : NSError)
    @objc optional    func epSignature(_: EPSignatureViewController, didSign signatureImage : UIImage, boundingRect: CGRect)
}

open class EPSignatureViewController: UIViewController {

    let cpf_user = KeychainWrapper.standard.string(forKey: "CPF")
    let id_user = KeychainWrapper.standard.integer(forKey: "ID")
    let nome_user = KeychainWrapper.standard.string(forKey: "NOME")
    
    // MARK: - IBOutlets
    var propostaEscolhida: Proposta!
    
    
    
    @IBOutlet weak var switchSaveSignature: UISwitch!
    @IBOutlet weak var lblSignatureSubtitle: UILabel!
    @IBOutlet weak var lblDefaultSignature: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewMargin: UIView!
    @IBOutlet weak var lblX: UILabel!
    @IBOutlet weak var signatureView: EPSignatureView!
    
    // MARK: - Public Vars
    
    open var showsDate: Bool = true
    open var showsSaveSignatureOption: Bool = true
    open weak var signatureDelegate: EPSignatureDelegate?
    open var subtitleText = "Assine aqui"
    open var tintColor = UIColor(red: (0/255), green: (26/255), blue: (94/255), alpha: 1.0)

    // MARK: - Life cycle methods
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.restorationIdentifier = "EPSignatureViewController"
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(EPSignatureViewController.onTouchCancelButton))
        cancelButton.tintColor = tintColor
        self.navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(EPSignatureViewController.onTouchDoneButton))
        doneButton.tintColor = tintColor
        let clearButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash, target: self, action: #selector(EPSignatureViewController.onTouchClearButton))
        clearButton.tintColor = tintColor
        
        if showsDate {
            let date = Date()
            let calendar = Calendar.current
            lblDate.text = "\(calendar.component(.day, from: date))/\(calendar.component(.month, from: date))/\(calendar.component(.year, from: date))"
        } else {
            lblDate.isHidden = true
        }
        
        if showsSaveSignatureOption {
            let actionButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target:   self, action: #selector(EPSignatureViewController.onTouchActionButton(_:)))
            actionButton.tintColor = tintColor
            self.navigationItem.rightBarButtonItems = [doneButton, clearButton, actionButton]
            switchSaveSignature.onTintColor = tintColor
        } else {
            self.navigationItem.rightBarButtonItems = [doneButton, clearButton]
            lblDefaultSignature.isHidden = true
            switchSaveSignature.isHidden = true
        }
        
        lblSignatureSubtitle.text = subtitleText
        switchSaveSignature.setOn(false, animated: true)
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Initializers
    
    public convenience init(signatureDelegate: EPSignatureDelegate) {
        self.init(signatureDelegate: signatureDelegate, showsDate: true, showsSaveSignatureOption: true)
    }
    
    public convenience init(signatureDelegate: EPSignatureDelegate, showsDate: Bool) {
        self.init(signatureDelegate: signatureDelegate, showsDate: showsDate, showsSaveSignatureOption: true)
    }
    
    public init(signatureDelegate: EPSignatureDelegate, showsDate: Bool, showsSaveSignatureOption: Bool ) {
        self.showsDate = showsDate
        self.showsSaveSignatureOption = showsSaveSignatureOption
        self.signatureDelegate = signatureDelegate
        let bundle = Bundle(for: EPSignatureViewController.self)
        super.init(nibName: "EPSignatureViewController", bundle: bundle)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Button Actions
    
    @objc func onTouchCancelButton() {
        signatureDelegate?.epSignature!(self, didCancel: NSError(domain: "EPSignatureDomain", code: 1, userInfo: [NSLocalizedDescriptionKey:"User not signed"]))
        dismiss(animated: true, completion: nil)
    }

    @objc func onTouchDoneButton() {
        if let signature = signatureView.getSignatureAsImage() {
            if switchSaveSignature.isOn {
                let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                let filePath = (docPath! as NSString).appendingPathComponent("sig.data")
                signatureView.saveSignature(filePath)
            }
            signatureDelegate?.epSignature!(self, didSign: signature, boundingRect: signatureView.getSignatureBoundsInCanvas())
            UIImageWriteToSavedPhotosAlbum(signature, nil, nil, nil);
            let data1 = UIImagePNGRepresentation(signature)
            
            if let fotoComprimida = self.colocaLogo(imgData: data1!).jpeg(.lowest) {
                
                self.enviaFotoStorage(nomeImg: "vistoria_str", imagemDados: fotoComprimida, id_user: "\(self.id_user!)", proposta: self.propostaEscolhida)
               
            }
            dismiss(animated: true, completion: nil)
        } else {
            self.CriarAlertaSemErro(tituloAlerta: "Opa", mensagemAlerta: "Não detectamos sua assinatura", acaoAlerta: "OK")
        }
    }
    
    @objc func onTouchActionButton(_ barButton: UIBarButtonItem) {
        let action = UIAlertController(title: "Action", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        action.view.tintColor = tintColor
        
        action.addAction(UIAlertAction(title: "Load default signature", style: UIAlertActionStyle.default, handler: { action in
            let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let filePath = (docPath! as NSString).appendingPathComponent("sig.data")
            self.signatureView.loadSignature(filePath)
        }))
        
        action.addAction(UIAlertAction(title: "Delete default signature", style: UIAlertActionStyle.destructive, handler: { action in
            self.signatureView.removeSignature()
        }))
        
        action.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        if let popOver = action.popoverPresentationController {
            popOver.barButtonItem = barButton
        }
        present(action, animated: true, completion: nil)
    }

    @objc func onTouchClearButton() {
        signatureView.clear()
    }
    
    override open func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        signatureView.reposition()
    }
}
