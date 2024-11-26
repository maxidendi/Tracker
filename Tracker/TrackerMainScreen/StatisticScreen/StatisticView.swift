import UIKit

final class StatisticView: UIView {
    
    //MARK: - Init
    
    init(count: Int = 0, title: String) {
        super.init(frame: .zero)
        countLabel.text = "\(count)"
        titleLabel.text = title
        setupUI()
        addGradientBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Properties
    
    private var gradientLayer = CAGradientLayer()
    private var borderShapeLayer = CAShapeLayer()
    private let constants = Constants.StatisticViewControllerConstants.self
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.font = Constants.Typography.bold34
        label.textColor = .ypBlack
        return label
    } ()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.textColor = .ypBlack
        label.font = Constants.Typography.medium12
        return label
    } ()
    
    //MARK: - Methods
    
    func configure(with count: Int) {
        countLabel.text = "\(count)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        borderShapeLayer.path = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: Constants.General.radius16).cgPath
    }
    
    private func addGradientBorder() {
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.colors = [
            UIColor.ypGradientColor1.cgColor,
            UIColor.ypGradientColor2.cgColor,
            UIColor.ypGradientColor3.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
        
        borderShapeLayer.fillColor = UIColor.clear.cgColor
        borderShapeLayer.strokeColor = UIColor.black.cgColor
        borderShapeLayer.lineWidth = 1
        borderShapeLayer.frame = bounds
        gradientLayer.mask = borderShapeLayer
    }
    
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        let stackView = UIStackView(arrangedSubviews: [countLabel, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = constants.stackViewSpacing
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
            countLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: constants.countLabelHeight),
            titleLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: constants.titleLabelHeight),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: constants.viewInsets.top),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -constants.viewInsets.bottom),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constants.viewInsets.left),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constants.viewInsets.right),
            heightAnchor.constraint(equalToConstant: constants.subViewHeight)
        ])
    }
}
