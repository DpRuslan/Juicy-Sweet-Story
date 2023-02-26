import UIKit

protocol GameLvl1ViewControllerDelegate: AnyObject {
    func imageChange()
}

final class GameLvl1ViewController: UIViewController {
    weak var delegate: GameLvl1ViewControllerDelegate?
    @IBOutlet private weak var viewOfCollection: UIView!
    @IBOutlet private weak var finalImage: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var timerLabel: UILabel!
    private var finalData: [UIImage] = []
    private var shuffledData: [UIImage] = []
    private var seconds = 180
    private var timer: Timer?
    private var selectedIndexPath: IndexPath?
    private var myStoryboard: UIStoryboard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myStoryboard = UIStoryboard(name: "Main", bundle: nil)
        runTimer()
        setImages()
        shuffledData = finalData.shuffled()
        
        setTimerLabel(label: timerLabel, title: timeString(time: TimeInterval(seconds)))
        setViewOfCollection(viewOfCollection: viewOfCollection)
       
        collectionView.collectionViewLayout = createLayout()
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: (#selector(GameLvl1ViewController.updateTimer)),
                                     userInfo: nil, repeats: true
        )
    }
    
    @objc func updateTimer() {
        if seconds == 0 {
            timer?.invalidate()
            let vc = myStoryboard?.instantiateViewController(withIdentifier: "LvlEndViewController") as! LvlEndViewController
            timer?.invalidate()
            vc.delegate = self
            vc.success = false
            vc.time = timeString(time: TimeInterval(seconds))
            vc.isModalInPresentation = true
            navigationController?.present(vc, animated: true)
        } else {
        seconds -= 1
        timerLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
   
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func restartButtonPressed(_ sender: Any) {
        shuffledData = finalData.shuffled()
        collectionView.reloadData()
        timer?.invalidate()
        seconds = 180
        runTimer()
        timerLabel.text = timeString(time: TimeInterval(seconds))
    }
}

// MARK: UICollectionViewDataSource
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

// MARK: UICollectionViewDelegate
extension GameLvl1ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
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
                self.checkShuffledData()
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
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.selectedIndexPath = nil
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.layer.borderWidth = 0
        }
        return true
    }
    
}

// MARK: checkShuffledData
extension GameLvl1ViewController {
    private func checkShuffledData() {
        if shuffledData == finalData {
            let vc = myStoryboard?.instantiateViewController(withIdentifier: "LvlEndViewController") as! LvlEndViewController
            timer?.invalidate()
            vc.success = true
            vc.delegate = self
            vc.time = self.timeString(time: TimeInterval(self.seconds))
            vc.isModalInPresentation = true
            navigationController?.present(vc, animated: true)
        }
    }
}

// MARK: createLayout
extension GameLvl1ViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2, bottom: 4, trailing: 2)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.24)),
            subitem: item,count: 4
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: LvlEndWinViewControllerDelegate
extension GameLvl1ViewController: LvlEndWinViewControllerDelegate {
    func nextButtonPressedLvlEndWin() {
        delegate?.imageChange()
        navigationController?.popViewController(animated: true)
    }
    
    func restartButtonPressedLvlEndWin() {
        seconds = 180
        runTimer()
        shuffledData = finalData.shuffled()
        collectionView.reloadData()
    }
    
    func homeButtonPressedLvlEndWin() {
            navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: setTimerLabel
extension GameLvl1ViewController {
    func setTimerLabel(label: UILabel, title: String) {
        let attributes: [NSAttributedString.Key : Any] = [
            .strokeWidth: -12.0,
            .strokeColor: UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1),
            .foregroundColor: UIColor.white
        ]
        
        label.attributedText = NSAttributedString(string: title, attributes: attributes)
        label.font = UIFont(name: "Knewave-Regular", size: 24)
        label.backgroundColor = .white
        label.layer.borderWidth = 5
        label.layer.borderColor = UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1).cgColor
        label.layer.cornerRadius = 20
        label.layer.masksToBounds = true
    }
}

// MARK: setViewOfCollection
extension GameLvl1ViewController {
    func setViewOfCollection(viewOfCollection: UIView) {
        viewOfCollection.layer.borderColor = UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1).cgColor
        viewOfCollection.layer.masksToBounds = true
        viewOfCollection.layer.borderWidth = 15
        viewOfCollection.layer.cornerRadius = 50
    }
}

// MARK: setImages
extension GameLvl1ViewController {
    func setImages() {
        for i in 0...15 {
            let image = UIImage(named: "g1_\(i)")!
            finalData.append(image)
        }
    }
}
