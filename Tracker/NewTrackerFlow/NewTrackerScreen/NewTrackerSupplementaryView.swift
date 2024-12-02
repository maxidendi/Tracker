import UIKit

final class NewTrackerSupplementaryView: UICollectionReusableView {
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.General.inset12),
//            titleLabel.heightAnchor.constraint(equalToConstant: Constants.General.labelTextHeight),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.General.inset12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    static let identifier: String = "header"
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Typography.bold19
        label.textColor = .ypBlack
        return label
    } ()
    
    //MARK: - Methods
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
