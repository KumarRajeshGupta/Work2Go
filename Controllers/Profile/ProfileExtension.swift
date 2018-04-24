//
//  ProfileExtension.swift
//  Work2go
//
//  Created by Rajesh Gupta on 4/1/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit
import MobileCoreServices


extension ProfileViewController : UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    
    func selectImageFromGallery() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imag.mediaTypes = [kUTTypeImage as String];
            imag.allowsEditing = false
            self.present(imag, animated: true, completion: nil)
        }
        
    }
    
    
    func selectImageFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerControllerSourceType.camera;
            imag.mediaTypes = [kUTTypeImage as String];
            imag.allowsEditing = false
            self.present(imag, animated: true, completion: nil)
        }
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.dismiss(animated: true) {
            self.profileImg.image  = chosenImage
            self.uploadimageservice()
            
        }
    }
    
  
    func uploadimageservice(){
        
        let userDetails = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        
        let params = ["user_id":userDetails.user_id]
        
        let imgData1 = UIImageJPEGRepresentation(profileImg.image!, 0.2)!
        
        service.getResponseUploadImageApi(parametrs: params as NSDictionary, imgData: imgData1) { (results) in
            
            print(results)
        }
 
    }
    
}
