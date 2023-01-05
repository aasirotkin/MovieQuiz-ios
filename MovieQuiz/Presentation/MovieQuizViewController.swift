import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    private var presenter: MovieQuizPresenter?
    private var statisticService: StatisticServiceProtocol?
    private var alertPresenter: AlertPresenter?

    func didRecieveNextQuestion(question: QuizQuestion?) {
        presenter?.didRecieveNextQuestion(question: question)
    }

    func didLoadDataFromServer() {
        showLoadingIndicator(isLoad: false)
        presenter?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
        loadMoviesData()
    }

    func show(quiz step: QuizStepViewModel) {
        configureImageLayer(thickness: 0, color: UIColor.ypWhite)
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
    }

    func showFinalResult() {
        guard let presenter = presenter else { return }
        if let stat = statisticService {
            stat.store(
                correct: presenter.correctAnswers,
                total: presenter.questionsAmount)
        }
        alertPresenter?.show(
            model: presenter.createAlertModel(stat: statisticService),
            controller: self)
        presenter.restartGame()
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
        loadMoviesData()
        presenter?.requestNextQuestion()
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
        statisticService = StatisticServiceUserDefaults()
        alertPresenter = AlertPresenter()
    }

    private func loadMoviesData() {
        showLoadingIndicator(isLoad: true)
        presenter?.startGame()
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

    private func showNetworkError(message: String) {
        showLoadingIndicator(isLoad: false)
        guard let presenter = presenter else { return }
        alertPresenter?.show(
            model: presenter.createAlertModel(message: message),
            controller: self)
    }

}
