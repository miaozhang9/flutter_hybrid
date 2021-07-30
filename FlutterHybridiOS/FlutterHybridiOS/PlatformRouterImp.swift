//
//  PlatformRouterImp.swift
//  Runner
//
//  Created by yujie on 2019/9/18.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
//import flutter_boost

class PlatformRouterImp: NSObject, FLBPlatform {
    func open(_ url: String, urlParams: [AnyHashable : Any], exts: [AnyHashable : Any], completion: @escaping (Bool) -> Void) {
        if (url == "native") {
           self.openNativeVC(url, urlParams: urlParams, exts: exts)
           return
        }
        
        var animated = false;
        if exts["animated"] != nil{
            animated = exts["animated"] as! Bool;
        }
        let vc = FLBFlutterViewContainer.init();
        vc.setName(url, params: urlParams);
        self.navigationController().pushViewController(vc, animated: animated);
        completion(true);
    }
    
    func present(_ url: String, urlParams: [AnyHashable : Any], exts: [AnyHashable : Any], completion: @escaping (Bool) -> Void) {
        var animated = false;
        if exts["animated"] != nil{
            animated = exts["animated"] as! Bool;
        }
        let vc = FLBFlutterViewContainer.init();
        vc.setName(url, params: urlParams);
        navigationController().present(vc, animated: animated) {
            completion(true);
        };
    }
    
    func close(_ uid: String, result: [AnyHashable : Any], exts: [AnyHashable : Any], completion: @escaping (Bool) -> Void) {
        var animated = false;
        if exts["animated"] != nil{
            animated = exts["animated"] as! Bool;
        }
        let presentedVC = self.navigationController().presentedViewController;
        let vc = presentedVC as? FLBFlutterViewContainer;
        if vc?.uniqueIDString() == uid {
            vc?.dismiss(animated: animated, completion: {
                completion(true);
            });
        }else{
            self.navigationController().popViewController(animated: animated);
        }
    }
    
   private func openNativeVC(
        _ name: String?,
        urlParams params: [AnyHashable : Any]?,
        exts: [AnyHashable : Any]?
    ) {
        let vc = UIViewController()
        let animated = (exts?["animated"] as? NSNumber)?.boolValue ?? false
        if (params?["present"] as? NSNumber)?.boolValue ?? false {
            self.navigationController().present(vc, animated: animated) {}
        } else {
      
            self.navigationController().pushViewController(vc, animated: animated)
        }
    }
    
    func navigationController() -> UINavigationController {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let navigationController = delegate.window?.rootViewController as! UINavigationController
        return navigationController;
    }
}
