//
//  UICircularRing.swift
//  msj-swift
//
//  Created by 马少杰 on 2021/5/30.
//
import UIKit

class UICircularRing: UIView, CAAnimationDelegate, UIGestureRecognizerDelegate {

    //圆环线宽
    let lineWidth = 50.0
    
    //整个圆环完成所需时间
    let duration:CGFloat = 5.0  //
    
    //背景灰色圆环
    var backgroundLayer: CAShapeLayer!
    
    //所有圆环段的集合
    var layerArray: [CAShapeLayer]!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
  
    func addBackgroundCircle(color :String) {
        backgroundLayer = CAShapeLayer()
        backgroundLayer.fillColor = UIColor.init(hexString: color).cgColor
        backgroundLayer.strokeColor = UIColor.init(hexString: color).cgColor
        
        backgroundLayer.lineWidth = CGFloat(lineWidth)
        layer.addSublayer(backgroundLayer)
        
        let backgroundPath = UIBezierPath(ovalIn: self.bounds)
        backgroundLayer.path = backgroundPath.cgPath
    }
    
    func randomColor() -> UIColor {
        let h = CGFloat(Double(arc4random() % 256) / 256.0)
        let s = CGFloat(Double(arc4random() % 128) / 256.0) + 0.5
        let b = CGFloat(Double(arc4random() % 128) / 256.0) + 0.5
        
        return UIColor(hue: h, saturation: s, brightness: b, alpha: 1.0)
    }
    
    func createOneLayer(strokeStart :CGFloat, strokeEnd :CGFloat, radius:CGFloat = 1, lineWidth:CGFloat,  color :String, alpha: CGFloat = 1.0) -> CAShapeLayer {
        let progessLayer = CAShapeLayer()
        progessLayer.fillColor = UIColor.clear.cgColor
        if( color.isEmpty ){
            progessLayer.strokeColor = randomColor().cgColor
        }else{
            progessLayer.strokeColor = UIColor.init(hexString: color, alpha: alpha).cgColor
        }
        progessLayer.lineWidth = lineWidth
        
        progessLayer.strokeStart = strokeStart
        progessLayer.strokeEnd = strokeEnd

        let newBounds = getCGRect(radius: radius)
        
        let backgroundPath = CGPath(ellipseIn: newBounds, transform: nil)
        progessLayer.path = backgroundPath
        
        layer.addSublayer(progessLayer)
        return progessLayer
    }
    
    func getCGRect(radius:CGFloat = 1, offSetY: CGFloat = 0) -> CGRect {
        let width = self.bounds.width * radius
        let height = self.bounds.width * radius
        return CGRect(x: (self.bounds.width - width)/2 ,y: (self.bounds.height - height)/2 + offSetY, width: width, height: height)
    }
}
