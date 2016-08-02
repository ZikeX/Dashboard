//
//  PanelView.swift
//  CircleView
//
//  Created by Zero on 16/7/26.
//  Copyright © 2016年 Zero. All rights reserved.
//

import UIKit

class PanelView: UIView {

    /**
     设置当前值
     */
    var value: CGFloat = 0 {
        didSet {
            let interval = scales.last! - scales.first!
            let angle = ((value - scales.first!) / interval - 1) * CGFloat(M_PI) + CGFloat(M_PI) / 2
            UIView.animateWithDuration(0.25) { [weak self] _ in
                guard let `self` = self else { return }
                self.arrowIcon.transform = CGAffineTransformMakeRotation(angle)
            }
        }
    }
    /**
     设置刻度数字的文本颜色
     */
    var textColor: UIColor = UIColor.grayColor()
    /**
     设置刻度数字的文本字体
     */
    var textFont: UIFont = UIFont.systemFontOfSize(11)
    /**
     text label显示数字的格式, default: "%0f"
     */
    var textFormat: String = "%0.f"
    /**
     设置需要标注的所有刻度
     */
    var scales: [CGFloat] = [0, 50, 60, 100, 120, 220]
    /**
     设置分段的所有颜色
     */
    var circlecolors: [UIColor] = [UIColor.brownColor(), UIColor.yellowColor(), UIColor.greenColor(), UIColor.darkGrayColor(), UIColor.orangeColor()]
    /**
     设置圆弧的宽度
     */
    var circlewidth: CGFloat = 25
    /**
     常规刻度线长度
     */
    var scaleLineNormalLength: CGFloat = 5
    /**
     数字刻度线的长度
     */
    var scaleLineSpecialLength: CGFloat = 15
    /**
     刻度线的宽度
     */
    var scaleLineWidth: CGFloat = 1
    /**
     刻度线的颜色
     */
    var scaleLineColor: UIColor = UIColor.whiteColor()
    /**
     数字刻度label的高度
     */
    var scaleLabelH: CGFloat = 17
    /**
     数字刻度label的宽度
     */
    var scaleLabelW: CGFloat = 80
    /**
     被分割的数量
     */
    var sliceCount = 22
    /**
     表针的图片
     */
    var watchHandImage = "ecg_pic_pointer"
    /**
     表中心点的图片
     */
    var watchCenterImage = "ecg_pic_pointer01"
    /**
     初始化/参数配置完成后show view
     */
    func showView() {
        minLength = min(self.bounds.size.width / 2, self.bounds.size.height)
        drawNumText()
        self.layer.addSublayer(circleLayer)
        circleLayer.drawLayer()
        self.addSubview(arrowIcon)
        self.addSubview(semiCircleIcon)
    }
    
    //取最短width / 2 : height
    private var minLength: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var labelRotationAngels: [CGFloat] {
        let interval = scales.last! - scales.first!
        
        let labelRotationAngels = scales.reduce([CGFloat]()) { (angels, scale) -> [CGFloat] in
            let angle = ((scale - scales.first!) / interval - 1) * CGFloat(M_PI) + CGFloat(M_PI) / 2
            return angels + [angle]
        }
        return labelRotationAngels
    }
    
    private var textCenters: [CGPoint] {
        let centerP = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height)
        let interval = scales.last! - scales.first!
        
        let points = scales.reduce([CGPoint](), combine: { (points, scale) -> [CGPoint] in
            let angle = Float(scale / interval) * Float(M_PI)
            let startX = -CGFloat(cosf(angle)) * (self.minLength - self.scaleLabelH / 2) + centerP.x
            let startY = -CGFloat(sinf(angle)) * (self.minLength - self.scaleLabelH / 2) + centerP.y
            return points + [CGPointMake(startX, startY)]
        })
        return points
    }
    
    private lazy var circleLayer: ColorfulLayer = {
        var circleLayer = ColorfulLayer(frame: CGRectMake(self.bounds.size.width / 2 - self.minLength + self.scaleLabelH, 0, (self.minLength - self.scaleLabelH) * 2, self.bounds.size.height))
        circleLayer.circlewidth = self.circlewidth
        circleLayer.circlecolors = self.circlecolors
        circleLayer.scaleLineNormalLength = self.scaleLineNormalLength
        circleLayer.scaleLineSpecialLength = self.scaleLineSpecialLength
        circleLayer.scaleLineWidth = self.scaleLineWidth
        circleLayer.scaleLineColor = self.scaleLineColor
        circleLayer.scales = self.scales
        circleLayer.sliceCount = self.sliceCount
        return circleLayer
    }()
    
    private lazy var semiCircleIcon: UIImageView = {
        var semiCircleIcon = UIImageView(image: UIImage(named: self.watchCenterImage))
        let tmpWidth = self.minLength * 2 - self.scaleLabelH - self.circlewidth
        semiCircleIcon.frame = CGRectMake(0, 0, tmpWidth / 3, tmpWidth / 6)
        semiCircleIcon.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height - tmpWidth / 12 )
        return semiCircleIcon
    }()
    
    private lazy var arrowIcon: UIImageView = {
        var arrowIcon = UIImageView(image: UIImage(named: self.watchHandImage))
        arrowIcon.layer.anchorPoint = CGPointMake(0.5, 1)
        let arrowHeight = (self.minLength - self.scaleLabelH - self.circlewidth - 5)
        arrowIcon.frame = CGRectMake(self.bounds.size.width / 2 - 5, self.bounds.size.height - arrowHeight, 10, arrowHeight)
        return arrowIcon
    }()
    
    private func drawNumText() {
        for i in 0..<scales.count {
            let numLbl = UILabel(frame: CGRectMake(0, 0, self.scaleLabelW, self.scaleLabelH))
            numLbl.textAlignment = .Center
            numLbl.center = CGPointMake(textCenters[i].x, textCenters[i].y - scaleLabelW / 2)
            if i == 0 {
                numLbl.textAlignment = .Left
            } else if i == scales.count - 1 {
                numLbl.textAlignment = .Right
            } else {
                numLbl.center = textCenters[i]
            }
            numLbl.textColor = textColor
            numLbl.font = textFont
            numLbl.text = String(format: textFormat, scales[i])
            numLbl.transform = CGAffineTransformMakeRotation(labelRotationAngels[i])
            self.addSubview(numLbl)
        }
    }
}
