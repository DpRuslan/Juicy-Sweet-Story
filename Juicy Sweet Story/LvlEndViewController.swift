import UIKit

protocol LvlEndWinViewControllerDelegate: AnyObject {
    func restartButtonPressedLvlEndWin()
    func homeButtonPressedLvlEndWin()
    func nextButtonPressedLvlEndWin()
}

extension LvlEndWinViewControllerDelegate {
    func restartButtonPressedLvlEndWin() {}
    func homeButtonPressedLvlEndWin() {}
    func nextButtonPressedLvlEndWin() {}
}

final class LvlEndViewController: UIViewController {
    weak var delegate: LvlEndWinViewControllerDelegate?
    @IBOutlet private weak var imageViewWinLose: UIImageView!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var bestTimeLabel: UILabel!
    @IBOutlet private weak var levelComFail: UILabel!
    var success: Bool!
    var bestTime: String!
    var time: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        if success == true {
            setFontTitleForLvlCompFail(label: levelComFail, title: " LEVEL \n COMPLETED ")
            imageViewWinLose.image = UIImage(named: "image 16")
            setFontTitle(label: timeLabel, title: "TIME: \(time!)")
            setFontTitle(label: bestTimeLabel, title: " BEST TIME: \(bestTime!) ")
        } else {
            setFontTitleForLvlCompFail(label: levelComFail, title: " LEVEL \n FAILED ")
            imageViewWinLose.image = UIImage(named: "image 15-4")
            bestTimeLabel.isHidden = true
            setFontTitle(label: timeLabel, title: " TIME: \(time!) ")
            nextButton.isEnabled = false
            nextButton.setImage(UIImage(named: "Group 3-4"), for: .normal)
        }
        
       
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.nextButtonPressedLvlEndWin()
        }
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.homeButtonPressedLvlEndWin()
        }
    }
    
    @IBAction func restartButtonPressed(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.restartButtonPressedLvlEndWin()
        }
    }
}

extension LvlEndViewController {
    func setFontTitle(label: UILabel, title: String) {
        let attributes: [NSAttributedString.Key : Any] = [
            .strokeWidth: -10.0,
            .strokeColor: UIColor(red: 173/255,green: 27/255, blue: 141/255, alpha: 1),
            .foregroundColor: UIColor.white
        ]
        
        label.attributedText = NSAttributedString(string: title, attributes: attributes)
        label.font = UIFont(name: "Knewave-Regular", size: 34)
        label.backgroundColor = .white
        label.layer.borderWidth = 5
        label.layer.cornerRadius = 20
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1).cgColor
    }
}

extension LvlEndViewController {
    func setFontTitleForLvlCompFail(label: UILabel, title: String) {
        let attributes: [NSAttributedString.Key : Any] = [
            .strokeWidth: -10.0,
            .strokeColor: UIColor(red: 173/255,green: 27/255, blue: 141/255, alpha: 1),
            .foregroundColor: UIColor.white
        ]
        
        label.attributedText = NSAttributedString(string: title, attributes: attributes)
        label.font = UIFont(name: "Knewave-Regular", size: 64)
        label.numberOfLines = 2
    }
}
