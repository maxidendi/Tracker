import UIKit

final class StatisticViewController: UIViewController {
    
    //MARK: - Properties
    
    private let constants = Constants.StatisticViewControllerConstants.self
    private lazy var imageStubView: UIImageView = {
        let imageView = UIImageView(image: .statisticImageStub)
        return imageView
    } ()
    
    private lazy var labelStub: UILabel = {
        let label = UILabel()
        label.text = constants.labelStubText
        label.font = Constants.Typography.medium12
        label.textAlignment = .center
        return label
    } ()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInset = .init(top: 75, left: 16, bottom: 0, right: 16)
        scrollView.backgroundColor = .clear
        return scrollView
    } ()
    
    private lazy var bestPeriodView: StatisticItemView = {
        let view = StatisticItemView(frame: .zero, count: 0, title: constants.bestPeriodText)
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private lazy var perfectDaysView: StatisticItemView = {
        let view = StatisticItemView(frame: .zero, count: 0, title: constants.perfectDaysText)
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private lazy var completedTrackersView: StatisticItemView = {
        let view = StatisticItemView(frame: .zero, count: 0, title: constants.trackersDoneText)
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private lazy var averageValueView: StatisticItemView = {
        let view = StatisticItemView(frame: .zero, count: 0, title: constants.averageValueText)
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()

    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            bestPeriodView,
            perfectDaysView,
            completedTrackersView,
            averageValueView
        ])
        stackView.axis = .vertical
        stackView.spacing = constants.subViewsSpacing
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        return stackView
    } ()

    //MARK: - Methods of lifecircle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        [bestPeriodView, perfectDaysView, completedTrackersView, averageValueView].forEach {
            $0.setBorder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        addSubviews()
        layoutSubviews()
        setupNavigationBar()
    }
    
    //MARK: - Methods
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = constants.title
    }
}

//MARK: - Extensions

extension StatisticViewController: SetupSubviewsProtocol {
    
    func addSubviews() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        [imageStubView, labelStub, scrollView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    func layoutSubviews() {
        NSLayoutConstraint.activate([
            imageStubView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageStubView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            labelStub.heightAnchor.constraint(equalToConstant: Constants.General.labelTextHeight),
            labelStub.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                               constant: Constants.General.inset16),
            labelStub.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                constant: -Constants.General.inset16),
            labelStub.topAnchor.constraint(equalTo: imageStubView.bottomAnchor,
                                           constant: constants.stubsSpacing),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
        [bestPeriodView, perfectDaysView, completedTrackersView, averageValueView].forEach {
            $0.configure(with: 0)
        }
    }
}
