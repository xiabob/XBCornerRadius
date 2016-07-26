//
//  XBCornerRadius.swift
//  XBCornerRadiusDemo
//
//  Created by xiabob on 16/7/2.
//  Copyright © 2016年 xiabob. All rights reserved.
//

import UIKit


private var kCornerRadiusAssociatedKey      = "xb_kCornerRadiusAssociatedKey"
private var kProcessedImageAssociatedKey    = "xb_kProcessedImageAssociatedKey"
private var kHasProcessedImageAssociatedKey = "xb_kHasProcessedImageAssociatedKey"
private var kHasAddObserverAssociatedKey    = "xb_kHasAddObserverAssociatedKey"
private var kIsAsyncProcessAssociatedKey    = "xb_kIsAsyncProcessAssociatedKey"

private let kImageKeyPath = "image"

public extension UIImageView {
    private var cornerRadius: CGFloat {
        get {
            guard let value = (objc_getAssociatedObject(self, &kCornerRadiusAssociatedKey) as? NSNumber)?.floatValue else { return 0 }
            return CGFloat(value)
        }
        
        set {
            objc_setAssociatedObject(self, &kCornerRadiusAssociatedKey, NSNumber(float: Float(newValue)), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var hasAddObserver: Bool {
        get {
            guard let value = (objc_getAssociatedObject(self, &kHasAddObserverAssociatedKey) as? NSNumber)?.boolValue else {return false}
            return value
        }
        
        set {
            objc_setAssociatedObject(self, &kHasAddObserverAssociatedKey, NSNumber(bool: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var isAsyncProcess: Bool {
        get {
            guard let value = (objc_getAssociatedObject(self, &kIsAsyncProcessAssociatedKey) as? NSNumber)?.boolValue else {return false}
            return value
        }
        
        set {
            objc_setAssociatedObject(self, &kIsAsyncProcessAssociatedKey, NSNumber(bool: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var processedQueue: dispatch_queue_t {
        return dispatch_queue_create("com.xiabob.XBCornerRadius.processedQueue", DISPATCH_QUEUE_CONCURRENT)
    }
    
    //MARK: - api method
    
    /**
     设置UIImageView的图片的圆角半径
     
     - parameter radius: 圆角半径
     */
    public func xb_setCornerRadius(radius: CGFloat) {
        xb_setCornerRadius(radius, isAsync: true)
    }
    
    /**
     设置UIImageView的图片的圆角半径，默认是异步处理，通过isAsync参数可以修改处理方式
     
     - parameter radius:  圆角半径
     - parameter isAsync: 是异步还是同步方式处理图片
     */
    public func xb_setCornerRadius(radius: CGFloat, isAsync: Bool) {
        cornerRadius = radius
        isAsyncProcess = isAsync
        
        if !hasAddObserver {
            addImageViewObservers()
            hasAddObserver = true
        }
    }
    
    //MARK: - private method
    private func addImageViewObservers() {
        addObserver(self, forKeyPath: kImageKeyPath, options: .New, context: nil)
    }
    
    private func removeImageViewObservers() {
        removeObserver(self, forKeyPath: kImageKeyPath)
    }
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if newSuperview == nil && hasAddObserver {
            removeImageViewObservers()
            hasAddObserver = false
        }
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == kImageKeyPath && cornerRadius > 0 {
            guard let changeDic = change else {return}
            guard let newImage = changeDic[NSKeyValueChangeNewKey] as? UIImage else {return}
            
            //避免死循环
            let hasProcessed = (objc_getAssociatedObject(newImage, &kHasProcessedImageAssociatedKey) as? NSNumber)?.boolValue
            if hasProcessed != nil && hasProcessed! {
                return
            }
            
            let processedImage = objc_getAssociatedObject(newImage, &kProcessedImageAssociatedKey) as? UIImage
            if processedImage != nil {
                objc_setAssociatedObject(processedImage, &kHasProcessedImageAssociatedKey, NSNumber(bool: true), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.image = processedImage
                return
            }
            
            if isAsyncProcess {
                dispatch_async(processedQueue, {
                    let processedImage = self.processImage(newImage)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.image = processedImage
                    })
                })
            } else {
                self.image = processImage(newImage)
            }
            
        }
    }
    
    private func processImage(newImage: UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {return newImage}
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(cornerRadius))
        path.addClip()
        layer.renderInContext(context)
        let processedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        objc_setAssociatedObject(processedImage, &kHasProcessedImageAssociatedKey, NSNumber(bool: true), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(newImage, &kProcessedImageAssociatedKey, processedImage, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return processedImage
    }


}
