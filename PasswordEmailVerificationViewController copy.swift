

import UIKit

class PasswordEmailVerificationViewController: UIViewController {
    
    let apiService = ApiService()
    
    
    
    @IBOutlet var inputemail: UITextField!
    
    
    @IBAction func SendEmailButton(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let email = self.inputemail?.text {
            if email.isEmpty {
                showAlert(title: "Error", msg: "fill te email input")
            }else{
                if isValidEmail(email: email) {
                    DataSignleton.shared.email = email
                    apiService.forgotPassword(email: email)
                    if let viewController = storyboard.instantiateViewController(withIdentifier: "PasswordVerificationCodeVC") as? PasswordVerificationCodeViewController {self.navigationController?.pushViewController(viewController, animated: true)}
                }else{
                    showAlert(title: "Error", msg: "invalid email")
                }
                
            }
        }
        
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func showAlert(title: String ,msg : String) {
        
        var dialogMessage = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
         })
        
        //Add OK button to a dialog message
        dialogMessage.addAction(ok)
        // Present Alert to
        self.present(dialogMessage, animated: true, completion: nil)
    }
    

}


