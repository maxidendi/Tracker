//
//  TrackerCell.swift
//  Tracker
//
//  Created by Денис Максимов on 01.10.2024.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func counterButtonTapped(with id: UInt, isCompleted: Bool, completion: @escaping () -> Void)
}

final class TrackerCell: UICollectionViewCell {
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    static let reuseIdentifier: String = "cell"
    weak var delegate: TrackerCellDelegate?
    private var id: UInt? = nil
    private var isCompleted: Bool = false
    private var counter: Int = 0
    private var counterTitle: String {
        counter.toString()
    }
    
    private lazy var counterButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = true
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(counterButtonTapped), for: .touchUpInside)
        return button
    } ()
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.text = counterTitle
        label.textColor = .ypBlack
        return label
    } ()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.backgroundColor = .ypWhite.withAlphaComponent(0.3)
        return label
    } ()
    
    private lazy var trackerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypWhite
        return label
    } ()
    
    private lazy var topView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    } ()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    } ()
    
    //MARK: - Methods
    
    func configureCell(
        id: UInt,
        title: String,
        emoji: String,
        color: UIColor,
        counter: Int,
        isCompleted: Bool
    ) {
        self.id = id
        self.isCompleted = isCompleted
        self.counter = counter
        counterLabel.text = counterTitle
        trackerTitleLabel.text = title
        emojiLabel.text = emoji
        topView.backgroundColor = color
        switchCounterButtonImage(isCompleted)
    }
    
    //MARK: - Private methods
        
    @objc private func counterButtonTapped() {
        guard let id else { return }
        delegate?.counterButtonTapped(with: id, isCompleted: !isCompleted) { [weak self] in
            guard let self else { return }
            switchCounterButtonImage(!isCompleted)
            changeCounterLabelText(isCompleted)
        }
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
    
    private func changeCounterLabelText(_ isCompleted: Bool) {
        counter = isCompleted ? counter + 1 : counter - 1
        counterLabel.text = counterTitle
    }
    
    private func addSubviews() {
        [topView,
         bottomView,
         counterLabel,
         counterButton,
         emojiLabel,
         trackerTitleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        contentView.addSubview(topView)
        contentView.addSubview(bottomView)
        topView.addSubview(emojiLabel)
        topView.addSubview(trackerTitleLabel)
        bottomView.addSubview(counterLabel)
        bottomView.addSubview(counterButton)
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            topView.heightAnchor.constraint(equalToConstant: 90),
            bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            bottomView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 58),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 12),
            trackerTitleLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 12),
            trackerTitleLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -12),
            trackerTitleLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 44),
            trackerTitleLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -12),
            counterButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 8),
            counterButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -12),
            counterButton.widthAnchor.constraint(equalToConstant: 34),
            counterButton.heightAnchor.constraint(equalToConstant: 34),
            counterLabel.centerYAnchor.constraint(equalTo: counterButton.centerYAnchor),
            counterLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 12),
            counterLabel.heightAnchor.constraint(equalToConstant: 18)
            ])
    }
}
