import UIKit

open class ActivityMonitorViewController: UIViewController {
    
    @IBOutlet weak var bestScoreView: BestScoreView!
    @IBOutlet weak var totalStepsView: TotalOfStepsView!
    @IBOutlet weak var runningLevelView: RunningLevelView!
    @IBOutlet weak var dailySummaryView: DailySummaryView!
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.perform(#selector(play), with: .none, afterDelay: 1)
    }
    
    open func play() {
        bestScoreView.play()
        totalStepsView.play()
        runningLevelView.play()
        dailySummaryView.play()
    }
    
}
