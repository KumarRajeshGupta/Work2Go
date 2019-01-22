//
//  TermsConditionViewController.swift
//  Work2go
//
//  Created by Rajesh Gupta on 5/12/18.
//  Copyright © 2018 Rajesh Gupta. All rights reserved.
//

import UIKit

class TermsConditionViewController: UIViewController , UIWebViewDelegate{
    @IBOutlet weak var webview: UIWebView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let url = URL (string: "http://demo2.mediatrenz.com/worktogo-apps/Api/policy/Terms_of_Use.pdf")
        let requestObj = URLRequest(url: url!)
         webview.loadRequest(requestObj)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView){
        activityIndicator.startAnimating()
    }
    
   
    func webViewDidFinishLoad(_ webView: UIWebView){
        activityIndicator.stopAnimating()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
