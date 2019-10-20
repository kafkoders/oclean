//
//  NewsTVC.swift
//  InnoDoc
//
//  Created by Carlos Martin de Arribas on 19/10/2019.
//  Copyright © 2019 Carlos. All rights reserved.
//

import UIKit
import AlamofireImage

class NewsTVC: UITableViewController {
    var news = [Notice]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib.init(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "noticeCell")
        self.tableView.tableHeaderView = createHeader()
        
        getNews()
        
    }
    
    func createHeader() -> UIView {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 180))
        
        let tLabel = UILabel(frame: CGRect(x: 0, y: 0, width: headerView.frame.width, height: 80))
        tLabel.text = "Noticias"
        tLabel.textAlignment = .center
        tLabel.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        headerView.addSubview(tLabel)
        
        let descLabel = UILabel(frame: CGRect(x: 0, y: 80, width: headerView.frame.width, height: 100))
        descLabel.text = "Aquí podrás ver las últimas noticias que afectan al mundo ecológico."
        descLabel.numberOfLines = 0
        descLabel.textAlignment = .center
        descLabel.font = UIFont.systemFont(ofSize: 20, weight: .light)
        headerView.addSubview(descLabel)
        
        
        return headerView
    }
    
    func getNews() {
        WebRequest.getNews { (news, success) in
            guard success else {
                print("Error parsing")
                return
            }
            
            self.news = news
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticeCell", for: indexPath) as! NewsCell

        let currentNew = news[indexPath.row]
        cell.titleLabelV.text      = currentNew.title
        cell.descriptionLabel.text = currentNew.description
        cell.dateLabel.text        = currentNew.publicationDate
        cell.newspaperLabel.text   = currentNew.newspaper
        
        let imgUrl = currentNew.image
        print(imgUrl)
        
        cell.noticeImage.af_setImage(withURL: URL(string: imgUrl ?? "")!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 137
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
