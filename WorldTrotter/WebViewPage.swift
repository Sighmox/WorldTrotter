//
//  WebViewPage.swift
//  WorldTrotter
//
//  Created by Paul Baker on 2/16/19.
//  Copyright © 2019 Paul Baker. All rights reserved.
//

import UIKit
import WebKit

class WebViewPage: UIViewController, UITextFieldDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var urlTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlTextField.delegate = self
        webView.navigationDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Page loading for webView
        let urlString:String = "https://www.google.com"
        let url:URL = URL(string: urlString)!
        let urlRequest:URLRequest = URLRequest(url: url)
        webView.load(urlRequest)
        
        urlTextField.text = urlString
       
    }
    // This makes the textfield display the URL after hitting return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let urlString:String = urlTextField.text!
        let url:URL = URL(string: urlString)!
        let urlRequest:URLRequest = URLRequest(url: url)
        webView.load(urlRequest)
        
        textField.resignFirstResponder()
        
        return true
    }
    // The back button action
    @IBAction func backTouch(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        }
    // The forward button action
    }
    @IBAction func forwardTouch(_ sender: Any) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    // Checks if the buttons can work and enables them and updates textfield
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        
        urlTextField.text = webView.url?.absoluteString
    }
    
}
