//
//  ViewController.swift
//  fotografPaylasmaUygulamasi
//
//  Created by Dilan Öztürk on 4.01.2023.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var sifreTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func girisYapTiklandi(_ sender: Any) { // kayıt olla neredeyse aynı kodlama
        
        if emailTextField.text != "" && sifreTextField.text != "" {
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: sifreTextField.text!) { authdataresult, error in
                if error != nil {
                    self.hataMesaji(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata Aldınız. Tekrar Deneyin")
                }else{
                    self.performSegue(withIdentifier: "toSecondVC", sender: nil)
                }
            }
            
        }else{
            hataMesaji(titleInput: "Hata", messageInput: "Email ve Parola Giriniz!")
        }

        
    }
    
    @IBAction func kayitOlTiklandi(_ sender: Any) {
        
        if emailTextField.text != "" && sifreTextField.text != ""{
            // kayıt olma işlemi. Kullanıcının verdiği email ve şifreyi alıp sunucuya yolluyor, sunucu da kullanıcıyı oluşturdum mesajı yolluyor. Kullanıcı oluşturulamazsa hata mesajı çıkıyor.
            Auth.auth().createUser(withEmail: emailTextField.text!, password: sifreTextField.text!) { authdataresult, error in
                if error != nil {
                    self.hataMesaji(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata Aldınız. Tekrar Deneyin")
                }else{
                    self.performSegue(withIdentifier: "toSecondVC", sender: nil)
                }
            }
        }else{
            hataMesaji(titleInput: "Hata!", messageInput: "Email ve Parola Giriniz!")
        }
        
    }
    func hataMesaji(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}

