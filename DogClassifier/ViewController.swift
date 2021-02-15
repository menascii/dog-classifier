import UIKit
import CoreML
import Vision
import Social

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var classificationResults : [VNClassificationObservation] = []
    let imagePicker = UIImagePickerController()
    
    let dogArray = ["afghan hound",
                    "airedale terrier",
                    "akita",
                    "alaskan malamute",
                    "american staffordshire terrier",
                    "american water spaniel",
                    "australian cattle dog",
                    "australian shepherd",
                    "australian terrier",
                    "bedlington terrier",
                    "bernese mountain dog",
                    "boston terrier",
                    "brittany",
                    "brussels griffon",
                    "canaan dog",
                    "chesapeake bay retriever",
                    "chihuahua",
                    "chinese crested",
                    "chinese shar-pei",
                    "clumber spaniel",
                    "dalmatian",
                    "doberman pinscher",
                    "english cocker spaniel",
                    "english setter",
                    "english springer spaniel",
                    "english toy spaniel",
                    "eskimo dog",
                    "finnish spitz",
                    "french bulldog",
                    "german shepherd",
                    "german shorthaired pointer",
                    "german wirehaired pointer",
                    "gordon setter",
                    "great dane",
                    "irish setter",
                    "irish water spaniel",
                    "irish wolfhound",
                    "jack russell terrier",
                    "japanese spaniel",
                    "kerry blue terrier",
                    "labrador retriever",
                    "lakeland terrier",
                    "lhasa apso",
                    "maltese",
                    "manchester terrier",
                    "mexican hairless",
                    "newfoundland",
                    "norwegian elkhound",
                    "norwich terrier",
                    "pekingese",
                    "pomeranian",
                    "rhodesian ridgeback",
                    "rottweiler",
                    "saint bernard",
                    "samoyed",
                    "scottish deerhound",
                    "scottish terrier",
                    "sealyham terrier",
                    "shetland sheepdog",
                    "siberian husky",
                    "skye terrier",
                    "staffordshire bull terrier",
                    "sussex spaniel",
                    "tibetan terrier",
                    "weimaraner",
                    "welsh terrier",
                    "west highland white terrier",
                    "yorkshire terrier",
                    "affenpinscher",
                    "basenji",
                    "basset hound",
                    "beagle",
                    "bearded collie",
                    "bichon frise",
                    "black and tan coonhound",
                    "bloodhound",
                    "border collie",
                    "border terrier",
                    "borzoi",
                    "bouvier des flandres",
                    "boxer",
                    "briard",
                    "bull terrier",
                    "bulldog",
                    "bullmastiff",
                    "cairn terrier",
                    "chow chow",
                    "cocker spaniel",
                    "collie",
                    "curly-coated retriever",
                    "dachshund",
                    "flat-coated retriever",
                    "fox terrier",
                    "foxhound",
                    "golden retriever",
                    "greyhound",
                    "keeshond",
                    "komondor",
                    "kuvasz",
                    "mastiff",
                    "otterhound",
                    "papillon",
                    "pointer",
                    "poodle",
                    "pug",
                    "puli",
                    "saluki",
                    "schipperke",
                    "schnauzer",
                    "shih tzu",
                    "silky terrier",
                    "soft-coated wheaten terrier",
                    "spitz",
                    "vizsla",
                    "whippet"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            
            imageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
            guard let ciImage = CIImage(image: image) else {
                fatalError("couldn't convert uiimage to CIImage")
            }
            detect(image: ciImage)
        }
    }
    
    func detect(image: CIImage) {
        // Load the ML model through its generated class
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("can't load ML model")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first,
                let resultsCount = results.count as Optional
                else {
                    fatalError("unexpected result type from VNCoreMLRequest")
                }
            
            if self.dogArray.contains(where: topResult.identifier.description.lowercased().contains) {
                DispatchQueue.main.async {
                    self.navigationItem.title =  topResult.identifier.description
                    self.navigationController?.navigationBar.barTintColor = UIColor.green
                    self.navigationController?.navigationBar.isTranslucent = false
                }
            }
            else {
                DispatchQueue.main.async {
                    self.navigationItem.title = topResult.identifier.description
                    self.navigationController?.navigationBar.barTintColor = UIColor.red
                    self.navigationController?.navigationBar.isTranslucent = false
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
