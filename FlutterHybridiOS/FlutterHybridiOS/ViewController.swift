//
//  ViewController.swift
//  FlutterHybridiOS
//
//  Created by Miaoz on 2020/7/16.
//  Copyright © 2020 ShuXun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        let btn = UIButton(type: .custom);
        btn.backgroundColor = UIColor.red
        btn.frame = CGRect(x: 10, y: 100, width: 200, height: 40)
        btn.setTitle("Push Flutter Page", for: .normal)
        self.view.addSubview(btn);
        btn.addTarget(self, action: #selector(onClickPushFlutterPage), for: .touchUpInside);
        
        let btn2 = UIButton(type: .custom);
        btn2.backgroundColor = UIColor.blue
        btn2.frame = CGRect(x: 10, y: 200, width: 200, height: 40)
        self.view.addSubview(btn2);
        btn2.setTitle("Present Flutter Page", for: .normal)
        btn2.addTarget(self, action: #selector(onClickPresentFlutterPage), for: .touchUpInside);

    }


    @objc func onClickPushFlutterPage(_ sender: UIButton, forEvent event: UIEvent){
//        self.navigationController?.navigationBar.isHidden = true
         FlutterBoostPlugin.open("first", urlParams:[kPageCallBackId:"MycallbackId#1"], exts: ["animated":true], onPageFinished: { (_ result:Any?) in
             print(String(format:"call me when page finished, and your result is:%@", result as! CVarArg));
         }) { (f:Bool) in
             print(String(format:"page is opened\(f)"));
         }
     }
    @objc func onClickPresentFlutterPage(_ sender: UIButton, forEvent event: UIEvent){
         FlutterBoostPlugin.present("second", urlParams:[kPageCallBackId:"MycallbackId#2"], exts: ["animated":true], onPageFinished: { (_ result:Any?) in
             print(String(format:"call me when page finished, and your result is:%@", result as! CVarArg));
         }) { (f:Bool) in
             print(String(format:"page is presented"));
         }
     }
}

