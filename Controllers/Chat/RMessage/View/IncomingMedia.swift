//
//  IncomingMedia.swift
//  RMessage
//
//  Created by Rajesh Gupta on 5/30/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit
import AVFoundation

class IncomingMedia: UITableViewCell {

    @IBOutlet weak var incomingBubble: UIView!
    @IBOutlet weak var incomingImg: UIImageView!
    @IBOutlet weak var videoIcon: UIImageView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var time: UILabel!
    
    
    
    
    var item: ChatRow? {
        didSet {
            guard let item = item else {
                return
            }
            videoIcon.image = UIImage(named: "")
            if item.type == "attachment" {
                   incomingImg.sd_setImage(with: URL(string: ChatType.isValidUrl(str: item.text)), placeholderImage: UIImage(named: "notfound"))
            }
            else if item.type == "video" {
                self.videoIcon.image = UIImage(named: "video")
                if let url = URL(string: isValidUrl(str: item.text)) {
                    DispatchQueue.global().async {
                        let asset = AVAsset(url: url)
                        let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
                        assetImgGenerate.appliesPreferredTrackTransform = true
                        let time = CMTimeMake(1, 2)
                        let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                        if img != nil {
                            let frameImg  = UIImage(cgImage: img!)
                            DispatchQueue.main.async(execute: {
                                self.incomingImg.image = frameImg
                            })
                        }
                    }
                }
            }
            else if item.type == "file" {
                self.incomingImg.image = UIImage.init(named: "pdf")
            }
            
            time.text = ChatType.timeFormate(str: item.timestamp)
            incomingImg.contentMode = .scaleAspectFill
            incomingImg.layer.cornerRadius = 10.0
            incomingImg.clipsToBounds = true
             avatar.sd_setImage(with: URL(string: ChatType.isValidUrl(str: item.sender_img ?? "")), placeholderImage: UIImage(named: "user"))
            
        }
    }
    
    func isValidUrl(str:String) -> String {
        return str.replacingOccurrences(of: " ", with: "%20")
    }
    
    
    
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.incomingImg.image = UIImage(data: data)
            }
        }
    }
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func createThumbnailOfVideoFromRemoteUrl(url: String) -> UIImage? {
        let asset = AVAsset(url: URL(string: url)!)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        //Can set this to improve performance if target size is known before hand
        //assetImgGenerate.maximumSize = CGSize(width,height)
        let time = CMTimeMakeWithSeconds(1.0, 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    static var identifier: String {
        return String(describing: self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        incomingBubble.layer.cornerRadius = 8.0
        incomingBubble.clipsToBounds = true
        avatar.backgroundColor = .gray
        avatar.layer.cornerRadius = avatar.bounds.size.height/2
        avatar.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
