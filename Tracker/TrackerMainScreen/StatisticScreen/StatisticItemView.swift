import UIKit

final class StatisticItemView: UIView {
    
    //MARK: - Init
    
    init(
        frame: CGRect,
        count: Int = 0,
        title: String
    ) {
        super.init(frame: frame)
        backgroundColor = .red
        countLabel.text = "\(count)"
        titleLabel.text = title
        setupUI()
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Properties
    
    private let gradientLayer = CAGradientLayer()
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
        let path = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: Constants.General.radius16).cgPath
        borderShapeLayer.path = path
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = path
//        layer.mask = maskLayer
//        borderShapeLayer.path = path
    }
    
    private func setupLayers() {
        gradientLayer.colors = [
            UIColor.ypGradientColor1,
            UIColor.ypGradientColor2,
            UIColor.ypGradientColor3
        ]
        gradientLayer.startPoint = .init(x: 0, y: 0.5)
        gradientLayer.endPoint = .init(x: 1, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
        borderShapeLayer.lineWidth = 1
        borderShapeLayer.strokeColor = UIColor.clear.cgColor
        borderShapeLayer.fillColor = nil
        layer.addSublayer(borderShapeLayer)
    }
    
    
    private func setupUI() {
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
