import UIKit

final class PageViewController: UIViewController, SetupSubviewsProtocol {
    
    //MARK: - Init
    
    init(pageModel: PageModel) {
        self.pageModel = pageModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    private let pageModel: PageModel
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = pageModel.text
        label.textColor = .black
        label.numberOfLines = 0
        label.font = Constants.Typography.bold32
        label.textAlignment = .center
        return label
    } ()
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.OnboardingPages.buttonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .black
        button.layer.cornerRadius = Constants.General.radius16
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    } ()
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = pageModel.image
        imageView.contentMode = .scaleAspectFill
        return imageView
    } ()

    //MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        layoutSubviews()
    }

    //MARK: - Methods

    @objc private func didTapButton() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first
        else {
            assertionFailure("Invalid window configuration")
            return
        }
        window.rootViewController = TrackerTabBarController()
    }
    
    func addSubviews() {
        [imageView, label, button].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func layoutSubviews() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                          constant: -view.safeAreaLayoutGuide.layoutFrame.height * 0.37),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
