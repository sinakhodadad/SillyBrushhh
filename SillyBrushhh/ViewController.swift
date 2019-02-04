//
//  ViewController.swift
//  SillyBrushhh
//
//  Created by sinahk on 2/3/19.
//  Copyright © 2019 sinakhodadad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var alpha: CGFloat = 1.0
    
    var brushWidth: CGFloat = 10.0
    
    var isDrawing = false
    var lastPoint = CGPoint.zero
    
    var blendMode = CGBlendMode.normal
    
    let colors : [(CGFloat, CGFloat, CGFloat)] = [
        (0,0,0), // BLACK
        (1.0, 51/255, 51/255), //RED BEAUTIFUL
        (255/255, 255/255, 0), // YELLOW
        (33/255, 116/255, 56/255), //CLOVER
        (255/255, 165/255, 0), //TANGERINE
        (111/255, 45/255, 168/255), //GRAPE
        (0, 255, 255), //AQUA
        (1.0,1.0,1.0) // WHITE
        
    ]
    
    func rnd() -> CGFloat{
        return CGFloat(Float(arc4random())/Float(UINT32_MAX))
    }
    
    func drawLine( fromPoint: CGPoint, toPoint: CGPoint){
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        mainImageView.image?.draw(in: CGRect(x:0, y:0, width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
        
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: alpha)
        
        context?.move(to: CGPoint(x:fromPoint.x, y:fromPoint.y))
        context?.addLine(to: CGPoint(x:toPoint.x, y:toPoint.y))
        context?.setLineWidth(brushWidth)
        // change between round and square
        context?.setLineCap(CGLineCap.round)
        // change the style how your line draws
        context?.setBlendMode(blendMode)
        context?.strokePath()
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDrawing = false
        if let touch = touches.first as UITouch!{
            lastPoint = touch.location(in: self.view)
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDrawing = true
        if let touch = touches.first as UITouch!{
            let currentPoint = touch.location(in: mainImageView)
            drawLine(fromPoint: lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (isDrawing == false){
            drawLine(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }
    
    
    @IBAction func changeStyle(_ sender: Any) {
        switch (sender as AnyObject).tag {
        case 11:
            blendMode = CGBlendMode.plusLighter
        case 12:
            blendMode = CGBlendMode.overlay
        case 13:
            blendMode = CGBlendMode.normal
        default:
            blendMode = CGBlendMode.normal
        }
    }
    
    
    
    
    
    @IBAction func shareButton(_ sender: Any) {
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: CGRect(x:0, y:0, width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let shareActivity = UIActivityViewController(activityItems: [image as Any], applicationActivities: nil)
        present(shareActivity, animated: true, completion: nil)
    }
    
    @IBOutlet weak var sizeLabel: UILabel!
    @IBAction func clearButton(_ sender: Any) {
        mainImageView.image = nil
    }
    
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBAction func colorButton(_ sender: Any) {
        print("hello")
        var index = (sender as AnyObject).tag ?? 0
        print(index)

        if (index < 0 || index >= colors.count) && (index != 20){
            index = 0
            (red, green, blue) = colors[index]

        }
        else if (index < 0 || index >= colors.count) && (index == 20) {
            red = rnd()
            green = rnd()
            blue = rnd()
        }
        
        
    }
    
    @IBOutlet weak var textLabel: UILabel!

    @IBOutlet weak var brushSlider: UISlider!
    
    @IBAction func sizeSlider(_ sender: UISlider) {
        if sender == brushSlider {
            brushWidth = CGFloat(sender.value)
            sizeLabel.text = NSString(format: "%.1f", brushWidth.native) as String
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sizeLabel.text = NSString(format: "%.1f", brushSlider.value) as String
        // Do any additional setup after loading the view, typically from a nib.
    }


}

