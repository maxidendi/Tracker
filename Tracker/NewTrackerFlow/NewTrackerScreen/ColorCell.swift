import UIKit

final class ColorCell: UICollectionViewCell {
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Properties
    
    private let constants = Constants.NewTrackerViewControllerConstants.self
    static let reuseIdentifier: String = "colorCell"
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.General.radius8
        view.layer.masksToBounds = true
        return view
    } ()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.General.radius8
        view.layer.masksToBounds = true
        view.backgroundColor = .clear
        return view
    } ()

    //MARK: - Methods
    
    func configureCell(
        color: UIColor
    ) {
        colorView.backgroundColor = color
    }
    
    func cellDidSelected() {
        containerView.layer.borderWidth = constants.colorCellBorderWidth
        containerView.layer.borderColor = colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
    }
    
    func cellDidDeselected() {
        containerView.layer.borderWidth = .zero
    }

    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            containerView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            colorView.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                             constant: -constants.colorCellBorderWidth * 4),
            colorView.heightAnchor.constraint(equalTo: contentView.heightAnchor,
                                              constant: -constants.colorCellBorderWidth * 4)
        ])
    }
}
