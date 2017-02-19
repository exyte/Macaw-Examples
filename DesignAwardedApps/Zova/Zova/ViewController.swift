import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var customizeButton: UIButton!
    @IBOutlet weak var activityView: ActivityView!
    
    @IBAction func customize(_ sender: Any) {
        customizeButton.alpha = 0.0
        doneButton.alpha = 1.0
        activityView.customize()
    }
    
    @IBAction func done(_ sender: Any) {
        doneButton.alpha = 0.0
        customizeButton.alpha = 1.0
        activityView.done()
    }

}

