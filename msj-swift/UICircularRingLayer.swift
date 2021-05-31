//
//  Cricle.swift
//  msj-swift
//
//  Created by 马少杰 on 2021/5/30.
//
//动画起作用的枢纽，
//负责处理绘制和动画，
//对于使用者隐藏，使用者操作外部的视图类就好
import CoreGraphics

class UICircularRingLayer: CAShapeLayer {
    // MARK: 属性
    @NSManaged var val: CGFloat

    let ringWidth: CGFloat = 20
    let startAngle = CGFloat(-90).rads

    // MARK: 初始化

    override init() {
        super.init()
    }

    override init(layer: Any) {
        // 确保使用姿势
        guard let layer = layer as? UICircularRingLayer else { fatalError("unable to copy layer") }

        super.init(layer: layer)
    }

    required init?(coder aDecoder: NSCoder) { return nil }

    // MARK:  视图渲染部分

    /**
     重写 draw(in 方法，画圆环
     */
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        UIGraphicsPushContext(ctx)
        // 画圆环
        drawRing(in: ctx)
        UIGraphicsPopContext()
    }

    // MARK: 动画部分

    /**
      监听 val 属性的变化，重新渲染
     */
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == "val" {
            return true
        } else {
            return super.needsDisplay(forKey: key)
        }
    }

    /**
     监听 val 属性的变化，指定动画行为
     */
    override func action(forKey event: String) -> CAAction? {
        if event == "val"{
            // 实际动画部分
            let animation = CABasicAnimation(keyPath: "val")
            animation.fromValue = presentation()?.value(forKey: "val")
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            animation.duration = 2
            return animation
        } else {
            return super.action(forKey: event)
        }
    }


    /**
     画圆，通过路径布局。主要是指定 UIBezierPath 曲线的角度
     */
    private func drawRing(in ctx: CGContext) {

        let center: CGPoint = CGPoint(x: bounds.midX, y: bounds.midY)

        let radiusIn: CGFloat = (min(bounds.width, bounds.height) - ringWidth)/2
        // 开始画
        let innerPath: UIBezierPath = UIBezierPath(arcCenter: center,
                                                   radius: radiusIn,
                                                   startAngle: startAngle,
                                                   endAngle: toEndAngle,
                                                   clockwise: true)

        // 具体路径
        ctx.setLineWidth(ringWidth)
        ctx.setLineJoin(.round)
        ctx.setLineCap(CGLineCap.round)
        ctx.setStrokeColor(UIColor.red.cgColor)
        ctx.addPath(innerPath.cgPath)
        ctx.drawPath(using: .stroke)

    }

   // 本例子中，起始角度固定，终点角度通过 val 设置
    var toEndAngle: CGFloat {
        return (val * 360.0).rads + startAngle
    }


}

extension CGFloat {
    var rads: CGFloat { return self * CGFloat.pi / 180 }
}
