import UIKit

final class TrackerCell: UICollectionViewCell {
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    static let reuseIdentifier: String = "trackerCell"
    private let constants = Constants.TrackerCellConstants.self
    weak var delegate: TrackerCellDelegate?
    private var id: UUID? = nil
    private var isCompleted: Bool = false
    private var counter: Int = .zero {
        didSet {
            counterLabel.text = String.localizedStringWithFormat(
                NSLocalizedString("numberOfDays", comment: ""),
                counter
            )
        }
    }
    
    private lazy var counterButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = true
        button.layer.cornerRadius = constants.counterButtonDiameter / 2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(counterButtonTapped), for: .touchUpInside)
        return button
    } ()
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Typography.medium12
        label.textColor = .ypBlack
        return label
    } ()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        label.layer.cornerRadius = constants.emojiAndPinSides / 2
        label.layer.masksToBounds = true
        label.backgroundColor = .ypWhite.withAlphaComponent(0.3)
        return label
    } ()
    
    private lazy var trackerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Typography.medium12
        label.numberOfLines = 2
        label.textColor = .ypWhite
        return label
    } ()
    
    private lazy var pinImageView: UIImageView = {
        let imageView = UIImageView(image: .pin)
        imageView.tintColor = .white
        imageView.isHidden = true
        return imageView
    } ()
    
    private lazy var topView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.General.radius16
        view.layer.masksToBounds = true
        return view
    } ()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    } ()
    
    //MARK: - Methods
    
    func configureCell(model: TrackerCellModel) {
        self.id = model.tracker.id
        self.isCompleted = model.isCompleted
        self.counter = model.count
        pinImageView.isHidden = !model.tracker.isPinned
        trackerTitleLabel.text = model.tracker.title
        emojiLabel.text = model.tracker.emoji
        topView.backgroundColor = UIColor.fromCodedString(model.tracker.color) 
        switchCounterButtonImage(isCompleted)
    }
    
    func toggleCellPin() {
        pinImageView.isHidden.toggle()
    }
    
    func topViewForPreview() -> UIView {
        return topView
    }
    
    func isPinned() -> Bool {
        return !pinImageView.isHidden
    }
    
    //MARK: - Private methods
        
    @objc private func counterButtonTapped() {
        AnalyticsService.shared.trackEvent(
            event: .click,
            parameters: TrackersScreenParameters.clickCellCounterButton)
        guard let id else { return }
        delegate?.counterButtonTapped(with: id, isCompleted: !isCompleted)
    }
    
    private func switchCounterButtonImage(_ isCompleted: Bool) {
        self.isCompleted = isCompleted
        if isCompleted {
            counterButton.setImage(.doneButton, for: .normal)
            counterButton.tintColor = .white
            counterButton.backgroundColor = topView.backgroundColor?.withAlphaComponent(0.3)
        } else {
            counterButton.setImage(.plusButton, for: .normal)
            counterButton.tintColor = topView.backgroundColor
            counterButton.backgroundColor = .ypWhite
        }
    }
}

//MARK: - Extensions

extension TrackerCell: SetupSubviewsProtocol {
    
    func addSubviews() {
        [topView,
         bottomView,
         counterLabel,
         counterButton,
         emojiLabel,
         pinImageView,
         trackerTitleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        contentView.addSubview(topView)
        contentView.addSubview(bottomView)
        topView.addSubview(emojiLabel)
        topView.addSubview(trackerTitleLabel)
        topView.addSubview(pinImageView)
        bottomView.addSubview(counterLabel)
        bottomView.addSubview(counterButton)
    }

    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            topView.heightAnchor.constraint(equalToConstant: constants.topViewHeight),
            bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            bottomView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: constants.bottomViewHeight),
            emojiLabel.heightAnchor.constraint(equalToConstant: constants.emojiAndPinSides),
            emojiLabel.widthAnchor.constraint(equalToConstant: constants.emojiAndPinSides),
            emojiLabel.topAnchor.constraint(equalTo: topView.topAnchor,
                                            constant: constants.insets.top),
            emojiLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor,
                                                constant: constants.insets.left),
            pinImageView.topAnchor.constraint(equalTo: topView.topAnchor, constant: constants.insets.top),
            pinImageView.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -Constants.General.inset4),
            pinImageView.widthAnchor.constraint(equalToConstant: constants.emojiAndPinSides),
            pinImageView.heightAnchor.constraint(equalToConstant: constants.emojiAndPinSides),
            trackerTitleLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor,
                                                       constant: constants.insets.left),
            trackerTitleLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor,
                                                        constant: -constants.insets.right),
            trackerTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.General.labelTextHeight),
            trackerTitleLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor,
                                                      constant: -constants.insets.bottom),
            counterButton.topAnchor.constraint(equalTo: bottomView.topAnchor,
                                               constant: constants.counterButtonTopInset),
            counterButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor,
                                                    constant: -constants.insets.right),
            counterButton.widthAnchor.constraint(equalToConstant: constants.counterButtonDiameter),
            counterButton.heightAnchor.constraint(equalToConstant: constants.counterButtonDiameter),
            counterLabel.centerYAnchor.constraint(equalTo: counterButton.centerYAnchor),
            counterLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor,
                                                  constant: constants.insets.left),
            counterLabel.heightAnchor.constraint(equalToConstant: Constants.General.labelTextHeight)
            ])
    }
}
