//
//  ViewController.swift
//  CoolAnimation
//
//  Created by Leonid Safronov on 28.04.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = .cyan
        backgroundImage.image = UIImage(named: "person")
        let eye = configureEye()
        let topEye = configureTopEye()
        let bottomEye = configureBottomEye()
        containerView.layer.addSublayer(eye)
        containerView.layer.addSublayer(topEye)
        containerView.layer.addSublayer(bottomEye)
        containerView.layer.mask = eye
        self.eyeMaskLayer = eye
        self.topPartLayer = topEye
        self.bottomPartLayer = bottomEye
        startAnimation(duration: 1)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        eyeMaskLayer?.path = configureEyePath()
        topPartLayer?.path = configureTopEyePath()
        bottomPartLayer?.path = configureBottomEyePath()
    }


    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    private var eyeMaskLayer: CAShapeLayer?
    private var topPartLayer: CAShapeLayer?
    private var bottomPartLayer: CAShapeLayer?
    
    private let path = UIBezierPath()
    private let radius: CGFloat = 180
    private let centerOffset: CGFloat = 97
    
    private func changeImage(duration: TimeInterval) {
        let firstImage = UIImage(named: "person")
        let secondImage = UIImage(named: "creature")
        backgroundImage.animationImages = [firstImage!, secondImage!]
        backgroundImage.animationDuration = duration * 2
        backgroundImage.startAnimating()
        
    }
    
    private func configureTopEye() -> CAShapeLayer {
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = configureTopEyePath()
        backgroundLayer.fillColor = UIColor.white.cgColor
        
        return backgroundLayer
    }
    
    private func configureBottomEye() -> CAShapeLayer {
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = configureBottomEyePath()
        backgroundLayer.fillColor = UIColor.white.cgColor
        
        return backgroundLayer
    }
    
    private func configureEye() -> CAShapeLayer {
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = configureEyePath()
        
        return backgroundLayer
    }
    
    private func configureEyePath() -> CGPath {
        path.addArc(
            withCenter: CGPoint(
                x: containerView.bounds.midX,
                y: containerView.bounds.midY + centerOffset
            ),
            radius: radius,
            startAngle: 7 * CGFloat.pi / 6,
            endAngle: 11 * CGFloat.pi / 6,
            clockwise: true
        )
        path.addArc(
            withCenter: CGPoint(
            x: containerView.bounds.midX,
            y: containerView.bounds.midY - centerOffset
        ),
        radius: radius,
        startAngle: CGFloat.pi / 6,
        endAngle: 5 * CGFloat.pi / 6,
        clockwise: true
        )
        return path.cgPath
    }
    
    private func resetProgress() {
        topPartLayer?.removeAllAnimations()
        bottomPartLayer?.removeAllAnimations()
    }
    
    private func configureBottomEyePath() -> CGPath {
        return UIBezierPath(rect: CGRect(x: 0, y: 110, width: 300, height: 110)
        ).cgPath
    }
    
    private func configureTopEyePath() -> CGPath {
        return UIBezierPath(rect: CGRect(x: 0, y: 0, width: 300, height: 110)
        ).cgPath
    }
    
    private func startAnimation(duration: TimeInterval) {
        
        let blinkTop = CABasicAnimation(keyPath: "position.y")
        let blinkBottom = CABasicAnimation(keyPath: "position.y")
        resetProgress()
        
        blinkTop.fromValue = -containerView.bounds.size.height / 2
        blinkTop.toValue = containerView.bounds.size.height / 8
        blinkTop.duration = duration
        changeImage(duration: duration)
        blinkTop.autoreverses = true
        blinkTop.repeatCount = .infinity
        blinkBottom.fromValue = containerView.bounds.size.height / 2
        blinkBottom.toValue = -containerView.bounds.size.height / 8
        blinkBottom.duration = duration
        blinkBottom.autoreverses = true
        blinkBottom.repeatCount = .infinity
        
        
        topPartLayer?.add(blinkTop, forKey: "blinkTop")
        bottomPartLayer?.add(blinkBottom, forKey: "blinkBottom")
        
    }
}

