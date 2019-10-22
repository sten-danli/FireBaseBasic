//
//  RegisterViewController.swift
//  FireBaseBasic
//
//  Created by Dan Li on 22.10.19.
//  Copyright © 2019 Dan Li. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    var selectedImage : UIImage?
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var upLoadetImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        addGestureToimageView()
        uploadImage.image = (selectedImage == nil) ? UIImage(named: "1") : selectedImage
        // Do any additional setup after loading the view.
    }
    

     //👇激活点击iamgevView更换用户招照片的方法。
    func addGestureToimageView(){
        //激活点击屏幕上的“profilImageView”。
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectProfilPhoto))
        uploadImage.addGestureRecognizer(tapGesture)
        uploadImage.isUserInteractionEnabled = true
    }
    //激活后做什么，允许pickerController照片改动，例如放大或缩小。
    @objc func handleSelectProfilPhoto(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //如果用户修改了照片。
        if let editImage = info[.cropRect] as? UIImage{
            uploadImage.image = editImage
            upLoadetImage.image = editImage
            selectedImage = editImage
        }else if let originalImage = info[.originalImage] as? UIImage{
        //如果用户未修改照片。
            uploadImage.image = originalImage
            upLoadetImage.image = originalImage
            selectedImage = originalImage
        }
        dismiss(animated: true, completion: nil)
    //👆点击iamgevView更换用户招照片
    }


    @IBAction func registerButtonTapped(_ sender: UIButton) {
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passWordTextField.text!) { (data, error) in
            if let err = error{
                print(err.localizedDescription)
                return
            }
            guard let newUser = data?.user else {return}
            let uid = newUser.uid
            let ref = Database.database().reference().child("users").child(uid)
            
            let storageRef = Storage.storage().reference().child("profil_image").child(uid)
            
            guard let image = self.selectedImage else {return}//var selectedImage：UIImage？得到修改后的用户照片。
             guard let uploadData = image.jpegData(compressionQuality: 0.1) else {return}
            storageRef.putData(uploadData, metadata: nil) { (metadata, error ) in
                        if let err = error{
                            print(err.localizedDescription)
                            return
                        }
            
                        storageRef.downloadURL { (url, error) in
                            if let err = error{
                                print(err.localizedDescription)
                                return
                            }
                            let profilImageUrlString = url?.absoluteString
            
            
            
            
            
            
            ref.setValue(["username" : self.userNameTextField.text!, "email" : self.emailTextField.text!, "password" : self.passWordTextField.text!, "profilImageUrl" : profilImageUrlString])
            self.dismiss(animated: true, completion: nil)
                }
  
            }
        }
    }
    
    
    @IBAction func haveAnAccountButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
