//
//  ViewController.swift
//  XBCornerRadiusDemo
//
//  Created by xiabob on 16/7/2.
//  Copyright © 2016年 xiabob. All rights reserved.
//

import UIKit
import Kingfisher

private let height: CGFloat = 60

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        let tableView: UITableView = UITableView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: self.view.bounds.size))
        tableView.register(imageCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = height
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    fileprivate var imageUrls = ["http://img.taopic.com/uploads/allimg/120502/128207-120502121H969.jpg",
                             "http://photocdn.sohu.com/20110707/Img312698512.jpg",
                             "http://www.jinmalvyou.com/kindeditor/attached/image/20130618/20130618140325_74663.jpg",
                             "http://hiphotos.baidu.com/lvpics/pic/item/5243fbf2b2119313f800d65e64380cd790238d98.jpg",
                             "http://pic.yesky.com/imagelist/07/15/2837580_2507.jpg",
                             "http://pic35.nipic.com/20131106/14645256_152053470149_2.jpg",
                             "http://f.hiphotos.baidu.com/image/h%3D200/sign=650d5402a318972bbc3a07cad6cd7b9d/9f2f070828381f305c3fe5bfa1014c086e06f086.jpg",
                             "http://pic.58pic.com/58pic/14/00/69/66858PICNfJ_1024.jpg",
                             "http://img5.duitang.com/uploads/item/201507/14/20150714175013_UZ8VF.jpeg",
                             "http://f.hiphotos.baidu.com/zhidao/pic/item/0dd7912397dda14408ea98f2b4b7d0a20df4868b.jpg",
                             "http://f.hiphotos.baidu.com/zhidao/pic/item/962bd40735fae6cd5eb9228b0db30f2443a70fce.jpg"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.isHidden = false
    }
    
    deinit {
        print("deinit")
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 80
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! imageCell

        let link = imageUrls[indexPath.row%imageUrls.count]
        if let url = URL(string: link) {
            cell.updateWithUrl(url)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = imageUrls[indexPath.row%imageUrls.count]
        let vc = BigImageViewController()
        vc.link = link
        navigationController?.pushViewController(vc, animated: true)
    }

}


class imageCell: UITableViewCell {
    lazy var firstImage: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 12, y: 5, width: height-10, height: height-10))
        view.xb_setCornerRadius((height-10)/2)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    lazy var secondImage: UIImageView = { [unowned self] in
        let view = UIImageView(frame: CGRect(x: self.firstImage.frame.maxX+10, y: 5, width: height-10, height: height-10))
        view.xb_setCornerRadius(12, backgroundColor: .white, corners: UIRectCorner.topLeft.union(.bottomRight))
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    lazy var thirdImage: UIImageView = { [unowned self] in
        let view: UIImageView = UIImageView(frame: CGRect(x: self.secondImage.frame.maxX+10, y: 5, width: height-10, height: height-10))
        view.xb_setCornerRadius((height-10)/2)
        view.xb_setCornerRadii(CGSize(width: (height-10)/2, height: (height-10)/2), backgroundColor: .white, corners: .allCorners, borderColor: .orange, borderWidth: 5)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(firstImage)
        addSubview(secondImage)
        addSubview(thirdImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateWithUrl(_ url: URL) {
        firstImage.kf.setImage(with: url)
        
        secondImage.kf.setImage(with: url)

        thirdImage.kf.setImage(with: url)
    }
}

