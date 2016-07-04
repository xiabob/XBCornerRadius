//
//  BigImageViewController.swift
//  XBCornerRadiusDemo
//
//  Created by xiabob on 16/7/2.
//  Copyright © 2016年 xiabob. All rights reserved.
//

import UIKit

class BigImageViewController: UIViewController {
    var link = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.whiteColor()
        
        let bigImage = UIImageView(frame: CGRect(x: 10, y: 74, width: view.bounds.size.width-20, height: view.bounds.size.height-84))
        bigImage.xb_setCornerRadius(30, isAsync: false)
        bigImage.kf_setImageWithURL(NSURL(string: link + "#big")!)
        view.addSubview(bigImage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
