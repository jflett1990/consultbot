import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var promptTextField: UITextField!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white

        // Set up the button action
        generateButton.addTarget(self, action: #selector(generateButtonTapped), for: .touchUpInside)
    }

    @objc func generateButtonTapped() {
        guard let prompt = promptTextField.text, !prompt.isEmpty else {
            // Handle the case where the user didn't enter a prompt
            return
        }

        // Call the DALLEManager to generate the image
        DALLEManager.shared.generateImage(from: prompt) { result in
            switch result {
            case .success(let image):
                // Display the image in the image view
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            case .failure(let error):
                // Handle the error
                print("Error generating image: \(error)")
            }
        }
    }
}
