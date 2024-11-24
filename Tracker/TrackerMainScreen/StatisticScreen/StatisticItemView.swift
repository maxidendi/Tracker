import UIKit

final class StatisticItemView: UIView {
    
    //MARK: - Init
    
    init(
        frame: CGRect,
        count: Int,
        title: String
    ) {
        super.init(frame: frame)
        backgroundColor = .red
        countLabel.text = "\(count)"
        titleLabel.text = title
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Properties
    
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
    
    func setBorder() {
        let gradientLayer = CALayer()
        gradientLayer.frame = bounds
        gradientLayer.addGradientBorder(
            colors: [
                UIColor.ypGradientColor1,
                UIColor.ypGradientColor2,
                UIColor.ypGradientColor3
            ],
            width: 1)
        layer.addSublayer(gradientLayer)
        layoutIfNeeded()
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
