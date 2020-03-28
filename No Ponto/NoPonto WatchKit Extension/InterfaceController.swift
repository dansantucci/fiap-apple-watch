//
//  InterfaceController.swift
//  NoPonto WatchKit Extension
//
//  Created by Danilo S Nascimento on 27/03/20.
//  Copyright © 2020 FIAP. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    // MARK: OUTLETS
    @IBOutlet weak var timer: WKInterfaceTimer!
    @IBOutlet weak var timerButton: WKInterfaceButton!
    @IBOutlet weak var lbWeight: WKInterfaceLabel!
    @IBOutlet weak var textGroup: WKInterfaceGroup!
    @IBOutlet weak var lbCook: WKInterfaceLabel!
    @IBOutlet weak var slider: WKInterfaceSlider!
    @IBOutlet weak var imageGroup: WKInterfaceGroup!
    @IBOutlet weak var weightPicker: WKInterfacePicker!
    @IBOutlet weak var lbTemperature: WKInterfaceLabel!
    @IBOutlet weak var temperaturePicker: WKInterfacePicker!
    
    
    
    // MARK: PROPERTIES
    var timerRunning = false
    var kg = 0.1
    var increment = 0.1
    var cookTemp: MeatTemperature = .rare
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        imageGroup.setHidden(true)
        setupPickers()
        updateConfiguration()
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    // Equivalente ao prepareForSegue no iOs.
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        return "Olá"
    }

    // MARK: - IBACTIONS
    @IBAction func timerPressed() {
        if timerRunning {
            timer.stop()
            timerButton.setTitle("Iniciar Timer")
        } else {
            let countdown = cookTemp.cookTimeForKg(kg)
            let date = Date(timeIntervalSinceNow: countdown)
            timer.setDate(date)
            timer.start()
            timerButton.setTitle("Interromper Timer")
        }
        timerRunning.toggle()
    }

    @IBAction func onMinusPressed() {
        if kg > 0.1 {
            kg -= increment
            updateConfiguration()
        }
    }
    
    @IBAction func onPlusPressed() {
        if kg < 1.0 {
            kg += increment
            updateConfiguration()
        }
    }
    
    @IBAction func onSliderTempChange(_ value: Float) {
        if let temp = MeatTemperature(rawValue: Int(value)) {
            cookTemp = temp
            updateConfiguration()
        }
    }
    
    @IBAction func onWeightChange(_ value: Int) {
        kg = Double(value+1) * increment
        updateConfiguration()
    }
    
    @IBAction func onPickerTempChange(_ value: Int) {
        cookTemp = MeatTemperature(rawValue: value)!
        updateConfiguration()
        slider.setValue(Float(value))
    }
    
    @IBAction func onModeChange(_ value: Bool) {
        imageGroup.setHidden(!value)
        textGroup.setHidden(value)
        updateConfiguration()
        
        let weightPickerIndex = Int(round(kg/increment) - 1)
    weightPicker.setSelectedItemIndex(weightPickerIndex)
    }
    
    
    // MARK: - METHODS
    func updateConfiguration(){
        kg = get2DecimalPlaces(for: kg)
        lbWeight.setText("Total: \(kg)kg")
        lbCook.setText(cookTemp.stringValue)
        lbTemperature.setText(cookTemp.stringValue)
        temperaturePicker.setSelectedItemIndex(cookTemp.rawValue)
    }

    func get2DecimalPlaces(for number:Double) -> Double {
        return round(number * 100) / 100
    }

    func setupPickers(){
        // Picker de quantidade
        var range = stride(from: 0.1, through: 1.0, by: increment)
        setDataForPicker(weightPicker, within: range) { (item, index) in
            item.title = "\(get2DecimalPlaces(for: index))"
        }

        // Picker ponto da carne
        range = stride(from: 1.0, through: 4.0, by: 1.0)
        setDataForPicker(temperaturePicker, within: range) { (item, index) in
            item.contentImage = WKImage(imageName: "temp-\(Int(index))")
        }
    }
    
    func setDataForPicker(_ picker: WKInterfacePicker, within range: StrideThrough<Double>, configureItem: (WKPickerItem, Double) -> Void){
        var pickerItems: [WKPickerItem] = []
        for index in range {
            let item = WKPickerItem()
            configureItem(item,index)
            pickerItems.append(item)
        }
        picker.setItems(pickerItems)
        picker.setSelectedItemIndex(0)
    }
    
    
}
