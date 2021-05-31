//
//  ViewController.swift
//  msj-swift
//
//  Created by 马少杰 on 2021/5/30.
//

import UIKit

class ViewController: UIViewController {
    var count = 20
    var progessView: UICircularRing!
    var randomTimer: Timer?
    var angleNumber: Double = 0 //当前角度指向
    var angleNumberLast = 0.0 //上一次角度指向
    var PI = Double.pi
    
    var orientationImageView: UIImageView = UIImageView(image:UIImage(named:"orientation-blue"))
    var arrowImageView: UIImageView = UIImageView(image:UIImage(named:"arrow"))
    var directionImageView: UIImageView = UIImageView(image:UIImage(named:"direction"))
    var aroundImageView: UIImageView = UIImageView(image:UIImage(named:"around"))
    var headerImageView: UIImageView = UIImageView(image:UIImage(named:"header-big"))
    
    var distanceLabel: UILabel?
    var aroundLabel1: UILabel?
    var aroundLabel2: UILabel?
    
    var innerCircle: CAShapeLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(hexString: "#101012")
        
        initView()
        showArrow()
        
        randomTimer = getTimer(myFunction: getRandomNumber)
    }
    
    func getRandomNumber(){
        count-=1
        if(count <= 5){
            showAround()
            clearTimer(timer: randomTimer!)
        }else{
            distanceLabel!.text =  String(count) + "m"
            
            angleNumberLast = angleNumber
            angleNumber = Double(arc4random() % 256) * 2 * PI / 256.0
            
            // 1.创建动画
            let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
            
            // 2.设置动画的属性
            rotationAnim.fromValue = angleNumberLast
            rotationAnim.toValue = angleNumber
            rotationAnim.duration = 1
            rotationAnim.isRemovedOnCompletion = false
            rotationAnim.fillMode = CAMediaTimingFillMode.forwards

            // 3.将动画添加到layer中
            orientationImageView.layer.add(rotationAnim, forKey: nil)
            arrowImageView.layer.add(rotationAnim, forKey: nil)
        }
    }
    
    func initView(){
        //环形背景图容器
        let uiFrame = CGRect(x: view.bounds.midX - 170, y: view.bounds.midY - 30, width: 340, height: 340)
        progessView = UICircularRing(frame: uiFrame)
        view.addSubview(progessView)
        
        //光晕背景图
        let backgroundImageView = UIImageView(image:UIImage(named:"background"))
        backgroundImageView.frame = progessView.getCGRect(radius: 0.9)//CGRect(x: view.bounds.midX - 190, y: 70, width: 380, height: 400)
        progessView.addSubview(backgroundImageView)
        
        //生成外围虚线圈
        let number = 200;
        let splitWidth = CGFloat(1.0/Double((number*2)))
        for a in 0 ..< number {
            progessView.createOneLayer(strokeStart: CGFloat(CGFloat(2*a)*splitWidth), strokeEnd: CGFloat(CGFloat((2*a+1))*splitWidth), radius: 0.98, lineWidth: 5, color: "#3F414B", alpha: 0.5)
        }
    }
    
    func showArrow(){
        headerImageView.frame = CGRect(x: view.bounds.midX - 100, y: 90, width: 200, height: 260)
        view.addSubview(headerImageView)
        
        // 生成内部大环
        innerCircle = progessView.createOneLayer(strokeStart: 0, strokeEnd: 1, radius: 0.76, lineWidth: 35, color: "#3F414B", alpha: 0.5)
     
        // 扇形方向图
        orientationImageView.frame = progessView.getCGRect()
        progessView.addSubview(orientationImageView)
        
        // 箭头方向图
        arrowImageView.frame = progessView.getCGRect(radius: 0.4)
        progessView.addSubview(arrowImageView)
        
        // 距离Label
        distanceLabel = setLabel(text: String(count) + "m", offSetY: 70, font: UIFont.boldSystemFont(ofSize: 23))
        
        //指南针背景图
        directionImageView.frame = CGRect(x: view.bounds.midX - 190, y: view.bounds.midY - 70, width: 380, height: 400)
        view.addSubview(directionImageView)
    }
    
    func showAround(){
        innerCircle!.isHidden = true
        orientationImageView.isHidden = true
        arrowImageView.isHidden = true
        distanceLabel!.isHidden = true
        directionImageView.isHidden = true
        
        //创建动画对象
        let headerScaleAnimation = CABasicAnimation()
        //设置动画属性
        headerScaleAnimation.keyPath = "transform.scale"
        //设置动画的起始位置。也就是动画从哪里到哪里。不指定起点，默认就从positoin开始
        headerScaleAnimation.toValue = 1.25
        //动画持续时间
        headerScaleAnimation.duration = 1.5
        headerScaleAnimation.isRemovedOnCompletion = false
        headerScaleAnimation.fillMode = CAMediaTimingFillMode.forwards
        headerImageView.layer.add(headerScaleAnimation, forKey: nil)
        
        progessView.createOneLayer(strokeStart: 0, strokeEnd: 1, radius: 1.25, lineWidth: 1, color: "#3F414B", alpha: 0.4)
        progessView.createOneLayer(strokeStart: 0, strokeEnd: 1, radius: 1.1, lineWidth: 3, color: "#3F414B", alpha: 0.4)
        progessView.createOneLayer(strokeStart: 0, strokeEnd: 1, radius: 0.9, lineWidth: 2, color: "#3F414B", alpha: 0.4)
        
        aroundImageView.frame = progessView.getCGRect(radius: 0.2, offSetY: -40)
        progessView.addSubview(aroundImageView)
        
        
        aroundLabel1 = setLabel(text: "投资人在你附近5m范围内", offSetY: 30, font: UIFont.systemFont(ofSize: 18))
        aroundLabel2 = setLabel(text: "请根据头像识别", offSetY: 60, font: UIFont.systemFont(ofSize: 18))
    }
    
    // 设置label
    func setLabel(text: String, offSetY: CGFloat, font: UIFont, color:UIColor = UIColor.init(hexString: "#ffffff")) -> UILabel{
        let label = UILabel()
        
        label.frame = progessView.getCGRect(radius: 1, offSetY: offSetY)
        label.text = text
        label.textColor = color
        label.font = font
        label.textAlignment=NSTextAlignment.center
        progessView.addSubview(label)
        
        return label
    }
    
    func getTimer(myFunction: @escaping ()-> Void, interval: Double = 1.0)-> Timer{
        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { (_) in
            myFunction()
        })
        // TableView的拖动不会导致定时器暂停
        RunLoop.current.add(timer, forMode: .common)
        return timer
    }
    
    func clearTimer(timer: Timer?) {
        if timer != nil {
            timer!.invalidate()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        clearTimer(timer: randomTimer!)
    }
}

// MARK:- 一、构造器设置颜色
extension UIColor {

    // MARK: 1.1、根据 RGBA 设置颜色颜色
    /// 根据 RGBA 设置颜色颜色
    /// - Parameters:
    ///   - r: red 颜色值
    ///   - g: green颜色值
    ///   - b: blue颜色值
    ///   - alpha: 透明度
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        // 提示：在 extension 中给系统的类扩充构造函数，只能扩充：遍历构造函数
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    

    // MARK: 1.2、十六进制字符串设置颜色
    /// 十六进制字符串设置颜色
    /// - Parameters:
    ///   - hex: 十六进制字符串
    ///   - alpha: 透明度
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
         
        if hexString.hasPrefix("#") {
            hexString = String(hexString.dropFirst())
        }
        
        assert(hexString.count == 6, "Invalid hex code used.")
         
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
         
        var rgbValue: UInt64 = 0
            Scanner(string: hexString).scanHexInt64(&rgbValue)

            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                      alpha: alpha)
    }
         
    // UIColor -> Hex String
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
         
        let multiplier = CGFloat(255.999999)
         
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
         
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}
