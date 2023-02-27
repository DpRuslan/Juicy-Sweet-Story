import UIKit
import CoreData

final class GameLvlViewController: UIViewController {
    @IBOutlet private weak var viewOfCollection: UIView!
    @IBOutlet private weak var finalImage: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var lvlImage: UIImageView!
    private var finalData: [UIImage] = []
    private var shuffledData: [UIImage] = []
    private var seconds = 180
    private var timer: Timer?
    private var selectedIndexPath: IndexPath?
    private var myStoryboard: UIStoryboard?
    var lvlID: NSManagedObjectID!
    var level: Int!
    private var dataSource: LevelEnum?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLvl()
        myStoryboard = UIStoryboard(name: "Main", bundle: nil)
        runTimer()
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
                                     selector: (#selector(GameLvlViewController.updateTimer)),
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
        checkLvlForTime()
        runTimer()
        timerLabel.text = timeString(time: TimeInterval(seconds))
    }
}

// MARK: UICollectionViewDataSource
extension GameLvlViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        shuffledData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameLvl", for: indexPath) as! GameLvlCell
        cell.imagesOfLvl1.image = shuffledData[indexPath.row]
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension GameLvlViewController: UICollectionViewDelegate {
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
extension GameLvlViewController {
    private func checkShuffledData() {
        if shuffledData == finalData {
            let lvl = AppDelegate.coreDataStack.managedContext.object(with: lvlID) as! Level
            lvl.levelLockUnlock = true
            try! AppDelegate.coreDataStack.managedContext.save()
    
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
extension GameLvlViewController {
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
extension GameLvlViewController: LvlEndWinViewControllerDelegate {
    func nextButtonPressedLvlEndWin() {
        navigationController?.popViewController(animated: true)
    }
    
    func restartButtonPressedLvlEndWin() {
        checkLvlForTime()
        runTimer()
        shuffledData = finalData.shuffled()
        collectionView.reloadData()
    }
    
    func homeButtonPressedLvlEndWin() {
            navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: setTimerLabel
extension GameLvlViewController {
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
extension GameLvlViewController {
    func setViewOfCollection(viewOfCollection: UIView) {
        viewOfCollection.layer.borderColor = UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1).cgColor
        viewOfCollection.layer.masksToBounds = true
        viewOfCollection.layer.borderWidth = 15
        viewOfCollection.layer.cornerRadius = 50
    }
}

// MARK: checkLvl
extension GameLvlViewController {
    func checkLvl() {
        if  level == 0 {
            dataSource = .lvl1
            finalImage.image = dataSource!.finalLvlImage
            finalData = dataSource!.puzzleImages
            lvlImage.image = dataSource!.lvlImage
        } else if level == 1 {
            seconds -= 10
            dataSource = .lvl2
            finalImage.image = dataSource!.finalLvlImage
            finalData = dataSource!.puzzleImages
            lvlImage.image = dataSource!.lvlImage
        } else {
            seconds -= 20
            dataSource = .lvl3
            finalImage.image = dataSource!.finalLvlImage
            finalData = dataSource!.puzzleImages
            lvlImage.image = dataSource!.lvlImage
        }
    }
}

// MARK: checkLvlForTime
extension GameLvlViewController {
    func checkLvlForTime() {
        if level == 0 {
            seconds = 180
        } else if level == 1 {
            seconds = 170
        } else {
            seconds = 150
        }
    }
}

// MARK: LevelEnum
extension GameLvlViewController {
    private enum LevelEnum: Equatable {
        case lvl1
        case lvl2
        case lvl3
        
        var lvlImage: UIImage {
            switch self {
            case .lvl1:
                return (UIImage(named: "time-1")!)
            case .lvl2:
                return (UIImage(named: "time-6")!)
            case .lvl3:
                return (UIImage(named: "time-9")!)
            }
        }
        
        var finalLvlImage: UIImage {
            switch self {
            case .lvl1:
                return (UIImage(named: "needed image-49")!)
            case .lvl2:
                return (UIImage(named: "needed image-54")!)
            case .lvl3:
                return (UIImage(named: "needed image-57")!)
            }
        }
        
        var puzzleImages: [UIImage] {
            switch self {
            case .lvl1:
                var dataArr: [UIImage] = []
                for i in 0...15 {
                    let image = UIImage(named: "g1_\(i)")!
                    dataArr.append(image)
                }
                return dataArr
            case .lvl2:
                var dataArr: [UIImage] = []
                for i in 0...15 {
                    let image = UIImage(named: "g2_\(i)")!
                    dataArr.append(image)
                }
                return dataArr
            case .lvl3:
                var dataArr: [UIImage] = []
                for i in 0...15 {
                    let image = UIImage(named: "g3_\(i)")!
                    dataArr.append(image)
                }
                return dataArr
            }
        }
    }
}
