//
//  MusiceTableViewController.swift
//  ituneAPIPractice
//
//  Created by 羅以捷 on 2022/10/26.
//

import UIKit
import AVKit

class MusiceTableViewController: UITableViewController {
    
    var items: [storeItem] = []
    var singer: String = ""
    var player : AVPlayer?
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func readUrl(){
        singer = searchBar.text!
        let urlString = URLComponents(string: "https://itunes.apple.com/search?media=music&term=\(singer)")
        if let url = urlString?.url {
            URLSession.shared.dataTask(with: url){ data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let searchResponse = try decoder.decode(ituneMusic.self, from: data)
                        self.items = searchResponse.results
                        DispatchQueue.main.async { self.tableView.reloadData() }
                        for _ in self.items.indices {
                        }
                    } catch {
                        print(error as Any)
                    }
                } else {
                    print(error as Any)
                }
            }.resume()
        }
    }
    


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ituneMusic", for: indexPath) as! MusicTableViewCell
        
        cell.albumLabel.text = items[indexPath.row].collectionName
        cell.singerLabel.text = items[indexPath.row].artistName
        cell.songLabel.text = items[indexPath.row].trackName
        if let imageUrl = items[indexPath.row].artworkUrl100 {
            let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.albumImage.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var previewViewController = AVPlayerViewController()
        if let previewUrl = items[indexPath.row].previewUrl {
            player = AVPlayer(url: previewUrl)
//            previewViewController.player = player
        }
        player?.play()

//        present(previewViewController, animated: true){
//            previewViewController.player?.play()
//        }
        tableView.deselectRow(at: indexPath, animated: false)

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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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


extension MusiceTableViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        readUrl()
        searchBar.resignFirstResponder()
    }
}
