//
//  XBCornerRadius.swift
//  XBCornerRadiusDemo
//
//  Created by xiabob on 16/7/2.
//  Copyright © 2016年 xiabob. All rights reserved.
//

import UIKit

public extension UIView {
    public func xb_setCornerRadius(_ radius: CGFloat) {
        xb_setCornerRadius(radius, backgroundColor: backgroundColor ?? .white)
    }
    
    public func xb_setCornerRadius(_ radius: CGFloat, backgroundColor: UIColor) {
        xb_setCornerRadius(radius, backgroundColor: backgroundColor, corners: .allCorners)
    }
    
    public func xb_setCornerRadius(_ radius: CGFloat, backgroundColor: UIColor, corners: UIRectCorner) {
        xb_setCornerRadii(CGSize(width: radius, height: radius), backgroundColor: backgroundColor, corners: corners)
    }
    
    public func xb_setCornerRadii(_ cornerRadii: CGSize, backgroundColor: UIColor, corners: UIRectCorner, borderColor: UIColor? = nil, borderWidth: CGFloat? = nil) {
        layer.xb_roundedCorner(cornerRadii, cornerColor: backgroundColor, corners: corners, borderColor: borderColor, borderWidth: borderWidth)
    }
}


public extension CALayer {
    public func xb_roundedCorner(_ cornerRadii: CGSize, cornerColor: UIColor, corners: UIRectCorner, borderColor: UIColor?, borderWidth: CGFloat?) {
        //remove exit layer
        for layer in sublayers ?? [] {
            if layer is _RoundedCornerLayer {
                layer.removeFromSuperlayer()
                break;
            }
        }
        
        let size = bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {return}
        
        //draw round corner by using eo rule
        context.setLineWidth(0)
        cornerColor.setFill()
        
        let rect = CGRect(origin: .zero, size: size)
        //outer rect path
        let rectPath = UIBezierPath(rect: rect)
        //inner round path
        let roundPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: cornerRadii)
        rectPath.append(roundPath)
        context.addPath(rectPath.cgPath)
        
        //set even-odd fill rule
        context.__eoFillPath()
        
        //set border
        if let borderColor = borderColor, let borderWidth = borderWidth  {
            borderColor.setFill()
            let borderOutterPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: cornerRadii)
            let borderInnerPath = UIBezierPath(roundedRect: rect.insetBy(dx: borderWidth, dy: borderWidth), byRoundingCorners: corners, cornerRadii: cornerRadii)
            borderOutterPath.append(borderInnerPath)
            context.addPath(borderOutterPath.cgPath)
            context.__eoFillPath()
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let subLayer = _RoundedCornerLayer()
        subLayer.frame = bounds
        subLayer.isOpaque = true
        subLayer.contents = image?.cgImage
        self.addSublayer(subLayer)
    }
}


//MARK: - _RoundedCornerLayer
class _RoundedCornerLayer: CALayer {}
