//
//  WebViewController.swift
//  WorldTrotter-V2
//
//  Created by Alexis Kirkman on 2/7/17.
//  Copyright © 2017 Alexis Kirkman. All rights reserved.
//

import UIKit
import WebKit

//Bronze Challenge: Another Tab
class WebViewController: UIViewController {
   
   var webView: WKWebView!
   
   override func loadView() {
      let webConfiguration = WKWebViewConfiguration()
      webView = WKWebView(frame: .zero, configuration: webConfiguration)
      view = webView
   }
   override func viewDidLoad() {
      super.viewDidLoad()
      
      let myURL = URL(string: "https://www.bignerdranch.com")
      let myRequest = URLRequest(url: myURL!)
      webView.load(myRequest)
   }}
