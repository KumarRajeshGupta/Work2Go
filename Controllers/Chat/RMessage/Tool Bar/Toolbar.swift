//
//  Toolbar.swift
//  RMessage
//
//  Created by Rajesh Gupta on 5/30/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit
import MobileCoreServices
import SDLoader
import IQKeyboardManagerSwift

enum Source {
    case camera
    case photo
}


protocol ToolbarDelegate: class {
    func toolbar(type : String)
}

class Toolbar: UIView {
    @IBOutlet weak var attachedImg: UIImageView!
    @IBOutlet weak var sendImg: UIImageView!
    
    @IBOutlet weak var textview: IQTextView!
    weak var delegate:ToolbarDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    private func setup(){
        guard let nib = Bundle.main.loadNibNamed("Toolbar", owner: self, options: nil)?.first as? UIView else {
            fatalError("Failed to load custom calendar xib")
        }
        addSubview(nib)
        nib.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        nib.frame = bounds
        textview.delegate = self
        
        attachedImg.image = attachedImg.image!.withRenderingMode(.alwaysTemplate)
        attachedImg.tintColor = Helper.hexStringToUIColor(hex: "FCA132")
        
        sendImg.image = sendImg.image!.withRenderingMode(.alwaysTemplate)
        sendImg.tintColor = Helper.hexStringToUIColor(hex: "FCA132")
        
    }
    
    @IBAction func attachedBtnAction(_ sender: UIButton) {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
        }
        let action2 = UIAlertAction(title: "Photo", style: .default) { (action:UIAlertAction) in
            self.imagePicker(source: .photo)
        }
        let action3 = UIAlertAction(title: "Camera", style: .default) { (action:UIAlertAction) in
            self.imagePicker(source: .camera)
        }
        let action4 = UIAlertAction(title: "File", style: .default) { (action:UIAlertAction) in
            self.documentPicker()
        }
       
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(action4)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
       
    }
    @IBAction func sendBtnAction(_ sender: UIButton) {
        if textview.text.isEmpty {
        }else{
            let sdLoader = SDLoader()
            sdLoader.startAnimating(atView: (UIApplication.shared.keyWindow?.rootViewController?.view)!)
            let rec_id = UserDefaults.standard.string(forKey: "receiver_id")
            let jb_id = UserDefaults.standard.string(forKey: "job_id")
            
            DispatchQueue.main.async {
                let details = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
                let str = "\(baseURL)job_chat.php?sender_id=\(details.user_id!)&&reciver_id=\(rec_id ?? "")&&job_id=\(jb_id ?? "")&&type=text&&message=\(self.textview.text!)".condenseWhitespace()
                if let url = URL.init(string: str) {
                    do {
                        let data = try Data(contentsOf: url as URL)
                        let datastring :  String = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? ?? ""
                        print(datastring)
                        sdLoader.stopAnimation()
                        if datastring.isEmpty == false {
                            self.delegate?.toolbar(type: "success")
                            self.textview.text = ""
                        }
                    } catch {
                        sdLoader.stopAnimation()
                        print("Unable to load data: \(error)")
                    }
                }
            }
        }
    }
    
    func documentPicker() {
       
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.pdf"], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        UIApplication.shared.keyWindow?.rootViewController?.present(documentPicker, animated: true, completion: nil)
    }
    
    func imagePicker(source : Source)  {
        switch source {
        case .camera:
            do {
                let imag = UIImagePickerController()
                imag.delegate = self
                imag.sourceType = UIImagePickerControllerSourceType.camera;
                imag.mediaTypes = [kUTTypeImage as String , kUTTypeMovie as String];
                imag.allowsEditing = true
                UIApplication.shared.keyWindow?.rootViewController?.present(imag, animated: true, completion: nil)
            }
        case .photo:
            do {
                let imag = UIImagePickerController()
                imag.delegate = self
                imag.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imag.mediaTypes = [kUTTypeImage as String , kUTTypeMovie as String];
                imag.allowsEditing = true
                UIApplication.shared.keyWindow?.rootViewController?.present(imag, animated: true, completion: nil)
            }
      
        }
    }

}

extension Toolbar:UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print(url)
    }
}

extension Toolbar : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: {
            guard info[UIImagePickerControllerMediaType] != nil else { return }
            let mediaType = info[UIImagePickerControllerMediaType] as! CFString
            
            switch mediaType {
            case kUTTypeImage:
                
                guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }

                self.sendImgOnServer(img: image)
                
                break
            case kUTTypeMovie:
                print(mediaType)
                break
            default:
                break
            }
        })
    }
    
    func sendImgOnServer(img:UIImage) {
        
        //http://demo2.mediatrenz.com/worktogo-apps/Api/job_chat.php?sender_id=3&&reciver_id=4&&job_id=3&&type=attachment
        let userDetails = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        let rec_id = UserDefaults.standard.string(forKey: "receiver_id")
        let jb_id = UserDefaults.standard.string(forKey: "job_id")
        let service = ServerHandler()
        let params = ["sender_id":userDetails.user_id,"reciver_id":rec_id!,"type":"attachment","job_id":jb_id!]
       
        let imgData1 = UIImageJPEGRepresentation(img, 0.2)!
       
        service.getResponseUploadImageApi(parametrs: params as NSDictionary, imgData: imgData1, imagekey: "message_image", serviceName: "job_chat.php") { (results) in
            
            let status = results["status"] as? String ?? ""
            if status == "1"{
                print(results)
            }
        }
    }
    
    
}

extension Toolbar : UITextViewDelegate{
    
}
