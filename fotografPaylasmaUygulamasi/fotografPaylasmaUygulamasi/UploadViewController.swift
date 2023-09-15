//
//  UploadViewController.swift
//  fotografPaylasmaUygulamasi
//
//  Created by Dilan Öztürk on 5.01.2023.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var yorumTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        imageView.addGestureRecognizer(gestureRecognizer)
    
    }
    
    @objc func gorselSec(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    } // görsel seçme kodları yazıldıktan sonra infoya gidip privacy - media library usage descripton eklenip not düşülüyor

    
    @IBAction func uploadButtonTiklandi(_ sender: Any) { // firebase e data yükleme
        
        let storage = Storage.storage() // burdan önce firebase e gidip storage ı açmak gerek

        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media") // bir yapının alt klasörüne gidiyorsak child kullanılır
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) { // media klasorüne kullanıcının seçtiği görüntüleri upload etmek gerek bunu image ı dataya çevirerek yapıyoruz
            
            let uuid = UUID().uuidString // bunu yazmanın sebebi, dataların her birini farklı isimlerle kaydedebilmek. tek isimle kaydolursa (image gibi) sonradan yüklenen datalar da aynı isimle kaydolur ve eski datalar görünmez
            
            let imageReference = mediaFolder.child("\(uuid).jpeg") // aldığım datayı media nın altına koyma  ve ona bir isim verme
            
            imageReference.putData(data, metadata: nil) { (metadata, error) in // datayı kaydetme
                if error != nil {
                    self.hataMesajiGoster(title: "Hata!", message: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyiniz")
                }else{
                    imageReference.downloadURL { url, error in // yüklediğim datanın url sini alma
                        if error == nil {
                            let imageUrl = url?.absoluteString // url nin stringe çevrilmiş halini verme
                            print(imageUrl)
                        }
                    }
                }
            }
        }
        
    }
    
    func hataMesajiGoster(title: String, message: String) {
   
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    

}
