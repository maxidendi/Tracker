import UIKit

extension CALayer {
        func addGradientBorder(colors: [UIColor], width: CGFloat) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: .zero, size: frame.size)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = colors.map{ $0.cgColor }
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.path = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: Constants.General.radius16).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.ypBlack.cgColor
        gradientLayer.mask = shapeLayer
        addSublayer(gradientLayer)
    }
}
