//
//  FourViewController.swift
//  abc
//
//  Created by Trần Nhất Thống on 3/23/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore


class ReportViewController: UIViewController, UITextViewDelegate {
  
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var titleField: UITextField!
  @IBOutlet weak var contentField: UITextView!
  
  let db = Firestore.firestore()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    contentField.delegate = self
  }
  
  @IBAction func submitPressed(_ sender: UIButton) {
    contentField.endEditing(true)
  }
  func textViewShouldReturn(_ textView: UITextView) -> Bool {
    contentField.endEditing(true)
    return true
  }
  
  func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
    if textView.text != "" {
      return true
    } else {
      let alert = UIAlertController(title: "Input somthing pls", message: "", preferredStyle: .alert)
      let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
      return false
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if let content = contentField.text, let contentSender = Auth.auth().currentUser?.email, let title = titleField.text {
      db.collection("Report").addDocument(data: [
        "sender": contentSender,
        "title": title,
        "content": content,
        "date": Date().timeIntervalSince1970
      ]) { (error) in
        if let err = error {
          print(err)
        } else {
          let alert = UIAlertController(title: "Submitted", message: "Thank you for the submition, ありがとうございます。", preferredStyle: .alert)
          let action = UIAlertAction(title: "Done", style: .default) { (action) in
          }
          alert.addAction(action)
          self.present(alert, animated: true, completion: nil)
        }
      }
    }
  }
}
