import UIKit

final class StatisticViewController: UIViewController {
    
    //MARK: - Init
    
    init(dataProvider: DataProviderProtocol) {
        self.dataProvider = dataProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    private let dataProvider: DataProviderProtocol
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
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = constants.subViewsSpacing
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        return stackView
    } ()

    //MARK: - Methods of lifecircle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        addSubviews()
        layoutSubviews()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let statistic = dataProvider.getStatistic()
        else {
            stubsIsHidden(false)
            return
        }
        stubsIsHidden(true)
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        [StatisticView(count: statistic.bestPeriod, title: constants.bestPeriodText),
         StatisticView(count: statistic.perfectDays, title: constants.perfectDaysText),
         StatisticView(count: statistic.completedTrackers, title: constants.trackersDoneText),
         StatisticView(count: statistic.averageValue, title: constants.averageValueText)
        ].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnalyticsService.shared.trackEvent(
            event: .open,
            parameters: TrackersScreenParameters.openCloseStatsScreen)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AnalyticsService.shared.trackEvent(
            event: .close,
            parameters: TrackersScreenParameters.openCloseStatsScreen)
    }
    
    //MARK: - Methods
    
    private func stubsIsHidden(_ isHidden: Bool) {
        imageStubView.isHidden = isHidden
        labelStub.isHidden = isHidden
        stackView.isHidden = !isHidden
    }
    
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
    }
}
