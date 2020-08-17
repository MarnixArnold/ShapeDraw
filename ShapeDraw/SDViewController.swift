//
//  SDViewController.swift
//  ShapeDraw
//
//  Created by Marnix Arnold on 17/08/2020.
//  Copyright © 2020 Marnix Arnold. All rights reserved.
//

import UIKit

class SDViewController: UIViewController {

    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var shapeTableView: UITableView!
    
    @IBOutlet weak var newShapeButton: UIButton!
    
    var shapeViews: [SDShapeView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shapeTableView.dataSource = self
        shapeTableView.delegate = self
        
        canvasView.backgroundColor = UIColor.lightGray

        // Do any additional setup after loading the view.
        let shapes = SDShapeFactory.fillDebugShapes()
        shapes.forEach { (shape) in
            addShape(shape: shape)
        }
    }
    
    @IBAction func didTapNewShapeButton(_ sender: Any) {
        // If any row is selected (editing), end that now
        if let selectedRow = shapeTableView.indexPathForSelectedRow {
            shapeTableView.deselectRow(at: selectedRow, animated: false)
            tableView(shapeTableView, didDeselectRowAt: selectedRow)
        }
        
        let alertController = UIAlertController(title: "New Shape", message: "Pick the type of shape that you want to create from the list below:", preferredStyle: .actionSheet)
        
        let supportedShapes = SDShapeFactory.supportedShapeTypes()
        let defaultWidth: CGFloat = 120
        let defaultHeight: CGFloat = 120
        let defaultRect = CGRect(x: canvasView.center.x - 0.5 * defaultWidth,
                                 y: canvasView.center.y - 0.5 * defaultHeight,
                                 width: defaultWidth,
                                 height: defaultHeight)
        supportedShapes.forEach { (shapeType) in
            let shapeAction = UIAlertAction(title: shapeType.rawValue, style: .default, handler: { (alert: UIAlertAction!) -> Void in
                if let shape = SDShapeFactory.create(as: shapeType, rect: defaultRect) {
                    self.askForShapeName(newShape: shape)
                }
            })
            alertController.addAction(shapeAction)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        

        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = []
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Using this weak ref to enable/disable the submit button based on the user input
    weak var submitNameAction: UIAlertAction?
    weak var nameAlertController: UIAlertController?

    private func askForShapeName(newShape: SDShape) {
        // Ask the user to select a name, check against the current names to see if it is unique
        let alertController = UIAlertController(title: "Almost there!", message: "Now choose a unique name", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = newShape.name
            textField.addTarget(self, action: #selector(self.nameTextChanged(_:)), for: .editingChanged)
        }
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { [weak alertController] (_) in
            guard let textField = alertController?.textFields?[0],
                let inputText = textField.text else { return }
            if !inputText.isEmpty {
                newShape.name = inputText
            }
            self.addShape(shape: newShape)
        })
        alertController.addAction(submitAction)
        submitNameAction = submitAction
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        nameAlertController = alertController
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = []
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc
    private func nameTextChanged(_ sender: UITextField) {
        guard let inputText = sender.text else {
            submitNameAction?.isEnabled = false
            return
        }
        let isUnique = isUniqueName(name: inputText)
        submitNameAction?.isEnabled = isUnique
        nameAlertController?.title = (isUnique ? "Awesome!" : "Oh noes...")
        nameAlertController?.message = (isUnique ? "This name is unique! Hit submit to continue." : "This name is alreay in use, please choose another.")
    }
    
    private func isUniqueName(name: String) -> Bool {
        shapeViews.filter { (shapeView) -> Bool in
            return shapeView.shape.name == name
        }.isEmpty
    }
    
    private func addShape(shape: SDShape) {
        let shapeView = SDShapeView(shape: shape)
        shapeViews.append(shapeView)
        canvasView.addSubview(shapeView)
        shapeTableView.reloadData()
    }
}

extension SDViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shapeViews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = shapeViews[indexPath.row].shape.name
        
        // Add a switch to control the visibility of the shape
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(true, animated: false)
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(self.didChangeSwitch(_:)), for: .valueChanged)
        cell.accessoryView = switchView
        
        return cell
    }
    
    @objc
    private func didChangeSwitch(_ sender : UISwitch!){
        let row = sender.tag
        guard row < shapeViews.count else {
            return
        }
        let view = shapeViews[row]
        view.isHidden = !sender.isOn
    }
}

extension SDViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shapeView = shapeViews[indexPath.row]
        shapeView.isEditing = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let shapeView = shapeViews[indexPath.row]
        shapeView.isEditing = false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let shapeView = shapeViews[indexPath.row]
            shapeView.removeFromSuperview()
            shapeViews.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
