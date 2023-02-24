import UIKit

protocol ImageChangeLvlDelegate: AnyObject {
    func imageChange()
}

final class GameLvl1ViewController: UIViewController {
    weak var imageChangeDelegate: ImageChangeLvlDelegate!
    @IBOutlet weak var viewOfCollection: UIView!
    @IBOutlet weak var finalImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    var finalData: [UIImage] = []
    var shuffledData: [UIImage] = []
    var seconds = 180
    var timer = Timer()
    var isTimerRunning = true
    var resumeTapped = false
    var counter: IndexPath?
    var selectedIndexPath: IndexPath?
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(GameLvl1ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        timerLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributes: [NSAttributedString.Key : Any] = [.strokeWidth: -12.0, .strokeColor: UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1), .foregroundColor: UIColor.white]
        timerLabel.attributedText = NSAttributedString(string: timeString(time: TimeInterval(seconds)), attributes: attributes)
        timerLabel.font = UIFont(name: "Knewave-Regular", size: 24)
        timerLabel.backgroundColor = .white
        timerLabel.layer.borderWidth = 5
        timerLabel.layer.borderColor = UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1).cgColor
        timerLabel.layer.cornerRadius = 20
        timerLabel.layer.masksToBounds = true
        runTimer()
        
        viewOfCollection.layer.borderColor = UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1).cgColor
        viewOfCollection.layer.masksToBounds = true
        viewOfCollection.layer.borderWidth = 12
        viewOfCollection.layer.cornerRadius = 20
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        for i in 0...15 {
            let image = UIImage(named: "g1_\(i)")!
            finalData.append(image)
        }
        shuffledData = finalData.shuffled()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func restartButtonPressed(_ sender: Any) {
        shuffledData = finalData.shuffled()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        timer.invalidate()
        seconds = 180
        runTimer()
        timerLabel.text = timeString(time: TimeInterval(seconds))
    }
}

extension GameLvl1ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        shuffledData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameLvl1", for: indexPath) as! GameLvl1Cell
        cell.imagesOfLvl1.image = shuffledData[indexPath.row]
        return cell
    }
}

extension GameLvl1ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if seconds == 0 {
            timer.invalidate()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LevelEndLoseViewController") as! LvlEndLoseViewController
            self.timer.invalidate()
            vc.time = self.timeString(time: TimeInterval(self.seconds))
            vc.isModalInPresentation = true
            self.navigationController?.present(vc, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            if self.selectedIndexPath == nil {
                self.selectedIndexPath = indexPath
            } else {
                let cell1 = collectionView.cellForItem(at: self.selectedIndexPath!)
                let cell2 = collectionView.cellForItem(at: indexPath)
                cell1?.layer.borderWidth = 0
                cell2?.layer.borderWidth = 0
                
                self.shuffledData.swapAt(indexPath.row, self.selectedIndexPath!.row)
                self.collectionView.reloadData()
                
                self.selectedIndexPath = nil
                if (self.shuffledData == self.finalData) {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LvlEndWinViewController") as! LvlEndWinViewController
                    self.timer.invalidate()
                    vc.homeButtonDelegate = self
                    vc.nextButtonDelegate = self
                    vc.restartButtonDelegate = self
                    vc.time = self.timeString(time: TimeInterval(self.seconds))
                    vc.isModalInPresentation = true
                    self.navigationController?.present(vc, animated: true)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.masksToBounds = true
        cell?.layer.borderWidth = 3
        cell?.layer.cornerRadius = 5
        cell?.layer.borderColor = UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1).cgColor
        return true
    }
}

extension GameLvl1ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width / 4 - 8 , height: self.collectionView.frame.height / 4 - 8 )
    }
}

extension GameLvl1ViewController: LevelEndWinHomeButtonDelegate {
    func homeButtonPressedLvlEndWin() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension GameLvl1ViewController: LevelEndWinNextButtonDelegate {
    func nextButtonPressedLvlEndWin() {
        self.imageChangeDelegate.imageChange()
        self.navigationController?.popViewController(animated: true)
    }
}

extension GameLvl1ViewController: LevelEndWinRestartButtonDelegate {
    func restartButtonPressedLvlEndWin() {
        seconds = 180
        runTimer()
        self.shuffledData = self.finalData.shuffled()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
