//
//  ViewController.swift
//  DemoApi
//
//  Created by MAC on 13/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
	
	var details = [Details]()
	var placephoto = [String?]()
	var imageArray = [UIImage?]()
	
	@IBOutlet weak var searchTextField: UITextField!
	@IBOutlet weak var placesTableView: UITableView!
	override func viewDidLoad() {
		
		
		self.placesTableView.delegate = self
		self.placesTableView.dataSource = self
		self.searchTextField.clearButtonMode = .always
		
	}
	func delayForimage(afterDelay delayTime: TimeInterval=5) -> Void {
	self.perform(#selector(self.jasonimage), with: nil, afterDelay: delayTime)

	}
	
	
	@IBAction func searchButton(_ sender: UIButton) {
		if searchTextField.text!.isEmpty == true{
			toDisplayAlert(messageToDisplay: "Enter something to search")
			details.removeAll()
			
		}
		else
		{
			
			details.removeAll()
			placephoto.removeAll()
			imageArray.removeAll()
			let typedQuery : String = searchTextField.text!.replacingOccurrences(of: " ", with: "+")
			
			let request = NSMutableURLRequest(url: NSURL(string: "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(typedQuery)&key=AIzaSyDVZ-U3ESUGKNVPeGT7A9r5HP2AIHu-QDQ")! as URL,cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
			request.httpMethod = "GET"
			let session = URLSession.shared
			
			let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
				if (error != nil) {
					print(error!)
				}
					
				else {
					let _ = response as? HTTPURLResponse
					// print(httpResponse!)
					guard let dataObject = data else {return}
					let dataFetched =  try! JSONSerialization.jsonObject(with: dataObject, options: .mutableContainers) as! NSDictionary
					//print(dataFetched)
					
					let array = dataFetched ["results"] as? [[String:Any]]
					
					for object in array! {
						let name = object["name"] ?? ""
						let address = object["formatted_address"] ?? ""
						guard let placeimage = object["photos"] as? [[String:Any]] else{return}
						for obj in placeimage{
							let refr = obj["photo_reference"] ?? ""
							self.placephoto.append((refr as! String))
							print(self.placephoto)
//							print("message")
						}
						self.details.append(Details(name: name as! String , address: address as! String))
					}
				}
			})
			dataTask.resume()

			placesTableView.tableFooterView = UIView()
			placesTableView.reloadData1()
          	     self.delayForimage()
			
		}
	}
	
	func toDisplayAlert(messageToDisplay: String)
	{
		let alertController = UIAlertController(title: "Error Message!", message: messageToDisplay, preferredStyle: .alert)
		let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
		}
		alertController.addAction(OKAction)
		self.present(alertController, animated: true, completion:nil)
	}
	
	//*********
	@objc func jasonimage()
	{
		for currentimage in placephoto
		{

			let request = NSMutableURLRequest(url: NSURL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(String(describing: currentimage!))&key=AIzaSyDVZ-U3ESUGKNVPeGT7A9r5HP2AIHu-QDQ")! as URL,cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
			request.httpMethod = "GET"

			let session = URLSession.shared
			let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
				if (error != nil) {
					print(error!)
				} else {
					let _ = response as? HTTPURLResponse

					guard let imagedata = data else {return}
					let image = UIImage(data: imagedata)
					self.imageArray.append(image)
					DispatchQueue.main.async{
						self.placesTableView.reloadData1()
					}
//					print(self.imageArray)
					print("message")
				}
			})

			dataTask.resume()
		}
	}
}


extension UITableView {
func reloadData1(afterDelay delayTime: TimeInterval=15) -> Void {
	self.perform(#selector(self.reloadData), with: nil, afterDelay: delayTime)
}
//	func delayForimage(afterDelay delayTime: TimeInterval=4) -> Void {
//				self.perform(#selector(self.jasonimage), with: nil, afterDelay: delayTime)}
	}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return details.count
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = placesTableView.dequeueReusableCell(withIdentifier: "placescell", for: indexPath) as! placesCell
		
		cell.nameLabel?.text = details[indexPath.row].name
		cell.adressLabel?.text = details[indexPath.row].address
		cell.placeImageview.image = imageArray[indexPath.row]
		self.placesTableView.reloadData1()
//		let imgref = self.placephoto[indexPath.row]
//
//		let strUrl = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(String(describing: imgref))&key=AIzaSyDVZ-U3ESUGKNVPeGT7A9r5HP2AIHu-QDQ"
//
//		if let url = URL(string:strUrl){
//			if let data = NSData(contentsOf: url as URL)
//			{
//				if let image = UIImage(data: data as Data)
//				{
//					cell.placeImageview.image = image
//				}
//			}
//		}
		
		return cell
		
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 150
	}
}

