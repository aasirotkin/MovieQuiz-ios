import UIKit

final class MovieQuizViewController:
    UIViewController,
    MovieQuizViewControllerProtocol {

    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    private var presenter: MovieQuizPresenter?
    private var alertPresenter: AlertPresenter?

    func show(quiz step: QuizStepViewModel) {
        configureImageLayer(thickness: 0, color: UIColor.ypWhite)
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
    }

    func show(quiz result: QuizResultsViewModel) {
        guard let presenter = presenter else { return }
        alertPresenter?.show(
            model: presenter.convertToAlertModel(result: result),
            controller: self)
        presenter.restartGame()
    }

    func showProgress(isShown: Bool) {
        showLoadingIndicator(isLoad: isShown)
    }

    func showError(message: String) {
        guard let presenter = presenter else { return }
        alertPresenter?.show(
            model: presenter.createErrorAlertModel(message: message),
            controller: self)
    }

    func setEnabled(isEnable: Bool) {
        noButton.isEnabled = isEnable
        yesButton.isEnabled = isEnable
    }

    func highlightResult(isCorrect: Bool) {
        (isCorrect)
        ? configureImageLayer(thickness: 8, color: UIColor.ypGreen)
        : configureImageLayer(thickness: 8, color: UIColor.ypRed)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setBaseProperties()
        initAbstractClasses()
        presenter?.startGame()
    }

    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter?.yesButtonClicked()
    }

    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter?.noButtonClicked()
    }

    private func setBaseProperties() {
        activityIndicator.hidesWhenStopped = true;
    }

    private func initAbstractClasses() {
        presenter = MovieQuizPresenter(controller: self)
        alertPresenter = AlertPresenter()
    }

    private func configureImageLayer(thickness: Int, color: UIColor) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = CGFloat(thickness)
        imageView.layer.borderColor = color.cgColor
        imageView.layer.cornerRadius = 15
    }

    private func showLoadingIndicator(isLoad: Bool) {
        if isLoad {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

}
