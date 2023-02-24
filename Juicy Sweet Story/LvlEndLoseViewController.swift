import UIKit

final class LvlEndLoseViewController: UIViewController {
    var time: String!
    @IBOutlet weak var timeLabel: UILabel!
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
    }
}
