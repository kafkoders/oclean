//
//  QuestionDetailVC.swift
//  InnoDoc
//
//  Created by Carlos on 12/03/2019.
//  Copyright © 2019 Carlos. All rights reserved.
//

import UIKit

class QuestionDetailVC: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerText: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var pin: Pin?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Respuesta"
        
        let okButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(goBack))
        self.navigationItem.setRightBarButton(okButton, animated: true)
        
        if let pin = pin {
            questionLabel.text = pin.question
            answerText.text = pin.answer
            categoryLabel.text = pin.category
            
            questionLabel.sizeToFit()
        }
    }
    
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
