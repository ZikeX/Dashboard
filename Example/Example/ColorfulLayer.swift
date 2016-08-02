//
//  ColorfulLayer.swift
//  CircleView
//
//  Created by Zero on 16/7/25.
//  Copyright © 2016年 Zero. All rights reserved.
//

import UIKit

class ColorfulLayer: CAShapeLayer {
    
    var circlewidth: CGFloat = 25 //线宽
    var circlecolors: [UIColor] = [UIColor.brownColor(), UIColor.yellowColor(), UIColor.greenColor(), UIColor.darkGrayColor(), UIColor.orangeColor()] //分段颜色
    
    var scaleLineNormalLength: CGFloat = 5 //刻度线长度
    var scaleLineSpecialLength: CGFloat = 15    //刻度线的分段长度
    var scaleLineWidth: CGFloat = 1 //刻度线宽度
    var scaleLineColor: UIColor = UIColor.whiteColor()  //刻度线颜色
    var scales: [CGFloat] = [0, 50, 60, 100, 120, 220] //分段刻度
    var sliceCount = 22 //切分的数量
    
    private var radius: CGFloat = 0
    
    init(frame:CGRect) {
        super.init()
        self.frame = frame
        radius = min(self.bounds.size.width / 2, self.bounds.size.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawLayer() {
        let angels = arcAngels
        let count = min(arcAngels.count, circlecolors.count)
        for i in 0..<count {
            let circleLayer = CAShapeLayer()
            let path = UIBezierPath(arcCenter: CGPointMake(self.bounds.size.width / 2, self.bounds.size.height),
                                    radius:radius - circlewidth / 2,
                                    startAngle: angels[i].0,
                                    endAngle: angels[i].1,
                                    clockwise: true).CGPath
            circleLayer.path = path
            circleLayer.strokeColor = circlecolors[i].CGColor;
            circleLayer.fillColor = UIColor.clearColor().CGColor;
            circleLayer.lineWidth = circlewidth
            self.addSublayer(circleLayer)
        }
        
        self.drawCommonLineLayer()
        self.drawScaleLineLayer()
    }
    
    private func drawCommonLineLayer() {
        let points = self.commonLinePoints
        drawLineLayer(points)
    }
    
    private func drawScaleLineLayer() {
        let points = self.scalesLinePoints
        drawLineLayer(points)
    }
    
    private func drawLineLayer(points: [(startP: CGPoint, endP: CGPoint)]) {
        let points = points
        let lineLayer = CAShapeLayer()
        lineLayer.lineWidth = scaleLineWidth
        lineLayer.strokeColor = scaleLineColor.CGColor
        let path = UIBezierPath()
        _ = points.map{
            path.moveToPoint($0.0)
            path.addLineToPoint($0.1)
        }
        lineLayer.path = path.CGPath
        self.addSublayer(lineLayer)
    }
    
    private var arcAngels: [(CGFloat, CGFloat)] {
        var arcAngels = [(CGFloat, CGFloat)]()
        let interval = scales.last! - scales.first!
        for i in 1..<scales.count {
            let startAngle = ((scales[i - 1] - scales.first!) / interval - 1) * CGFloat(M_PI)
            let endAngle = ((scales[i] - scales.first!) / interval - 1) * CGFloat(M_PI)
            arcAngels.append((startAngle, endAngle))
        }
        return arcAngels
    }
    
    private var commonLinePoints: [(startP: CGPoint, endP: CGPoint)] {
        var points = [(startP: CGPoint, endP: CGPoint)]()
        let aveAngle = Float(M_PI) / Float(sliceCount)
        let centerP = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height)
        for i in 1..<sliceCount {
            let startX = -CGFloat(cosf(Float(i) * aveAngle)) * (radius - circlewidth) + centerP.x
            let startY = -CGFloat(sinf(Float(i) * aveAngle)) * (radius - circlewidth) + centerP.y
            let endX = -CGFloat(cosf(Float(i) * aveAngle)) * (radius - circlewidth + scaleLineNormalLength) + centerP.x
            let endY = -CGFloat(sinf(Float(i) * aveAngle)) * (radius - circlewidth + scaleLineNormalLength) + centerP.y
            let startP = CGPointMake(startX, startY)
            let endP = CGPointMake(endX, endY)
            points.append((startP, endP))
        }
        return points
    }
    
    private var scalesLinePoints: [(startP: CGPoint, endP: CGPoint)] {
        var points = [(startP: CGPoint, endP: CGPoint)]()
        let centerP = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height)
        let interval = scales.last! - scales.first!
        for i in 1..<scales.count - 1 {
            let angle = Float(scales[i] / interval) * Float(M_PI)
            let startX = -CGFloat(cosf(angle)) * (radius - circlewidth) + centerP.x
            let startY = -CGFloat(sinf(angle)) * (radius - circlewidth) + centerP.y
            let endX = -CGFloat(cosf(angle)) * (radius - circlewidth + scaleLineSpecialLength) + centerP.x
            let endY = -CGFloat(sinf(angle)) * (radius - circlewidth + scaleLineSpecialLength) + centerP.y
            let startP = CGPointMake(startX, startY)
            let endP = CGPointMake(endX, endY)
            points.append((startP, endP))
        }
        return points
    }
    
}
