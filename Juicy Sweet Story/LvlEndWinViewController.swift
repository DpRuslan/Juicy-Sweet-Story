import UIKit

protocol LevelEndWinRestartButtonDelegate: AnyObject {
    func restartButtonPressedLvlEndWin()
}
protocol LevelEndWinHomeButtonDelegate: AnyObject {
    func homeButtonPressedLvlEndWin()
}
protocol LevelEndWinNextButtonDelegate: AnyObject {
    func nextButtonPressedLvlEndWin()
}

final class LvlEndWinViewController: UIViewController {
    weak var homeButtonDelegate: LevelEndWinHomeButtonDelegate?
    weak var nextButtonDelegate: LevelEndWinNextButtonDelegate?
    weak var restartButtonDelegate: LevelEndWinRestartButtonDelegate?
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var bestTimeLabel: UILabel!
    var time: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        let attributes: [NSAttributedString.Key : Any] = [.strokeWidth: -10.0, .strokeColor: UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1), .foregroundColor: UIColor.white]
        timeLabel.attributedText = NSAttributedString(string: "TIME: \(time!)", attributes: attributes)
        timeLabel.font = UIFont(name: "Knewave-Regular", size: 34)
        timeLabel.backgroundColor = .white
        timeLabel.layer.borderWidth = 5
        timeLabel.layer.cornerRadius = 20
        timeLabel.layer.masksToBounds = true
        timeLabel.layer.borderColor = UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1).cgColor
        
        bestTimeLabel.attributedText = NSAttributedString(string: "BEST TIME: 01:02", attributes: attributes)
        bestTimeLabel.font = UIFont(name: "Knewave-Regular", size: 34)
        bestTimeLabel.layer.borderColor = UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1).cgColor
        bestTimeLabel.backgroundColor = .white
        bestTimeLabel.layer.borderWidth = 5
        bestTimeLabel.layer.cornerRadius = 20
        bestTimeLabel.layer.masksToBounds = true
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        dismiss(animated: true) {
            self.nextButtonDelegate?.nextButtonPressedLvlEndWin()
        }
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        dismiss(animated: true) {
            self.homeButtonDelegate?.homeButtonPressedLvlEndWin()
        }
    }
    
    @IBAction func restartButtonPressed(_ sender: Any) {
        dismiss(animated: true) {
            self.restartButtonDelegate?.restartButtonPressedLvlEndWin()
        }
    }
}
