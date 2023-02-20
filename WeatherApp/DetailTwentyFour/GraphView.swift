//
//  GraphView.swift
//  WeatherApp
//
//  Created by ROMAN VRONSKY on 13.02.2023.
//

import UIKit


class GraphView: UIView {
  // 1
   var temp = [Int]()
    
   
    private enum Constants {
      static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
        static let sizeLabel = CGSize(width: 50.0, height: 30.0)
      static let margin: CGFloat = 20.0
      static let topBorder: CGFloat = 60
      static let bottomBorder: CGFloat = 50
      static let colorAlpha: CGFloat = 0.3
      static let circleDiameter: CGFloat = 5.0
    }
   var startColor: UIColor = #colorLiteral(red: 0.7152544856, green: 0.7761872411, blue: 0.9439151287, alpha: 1)
   var endColor: UIColor = #colorLiteral(red: 0.9141461849, green: 0.9332635999, blue: 0.9784278274, alpha: 1)

  override func draw(_ rect: CGRect) {
      let graphPoints = temp.prefix(7)

    // 2
//      let path = UIBezierPath(
//        roundedRect: rect,
//        byRoundingCorners: .allCorners,
//        cornerRadii: Constants.cornerRadiusSize
//      )
//      path.addClip()
      let width = rect.width
      let height = rect.height
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    let colors = [startColor.cgColor, endColor.cgColor]
    
    // 3
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    
    // 4
    let colorLocations: [CGFloat] = [0.0, 1.0]
    
    // 5
    guard let gradient = CGGradient(
      colorsSpace: colorSpace,
      colors: colors as CFArray,
      locations: colorLocations
    ) else {
      return
    }
    
    // 6
    let startPoint = CGPoint.zero
    let endPoint = CGPoint(x: 0, y: bounds.height)
    context.drawLinearGradient(
      gradient,
      start: startPoint,
      end: endPoint,
      options: []
    )
      
      let margin = Constants.margin
      let graphWidth = width - margin * 2
      let columnXPoint = { (column: Int) -> CGFloat in
        // Calculate the gap between points
        let spacing = graphWidth / CGFloat(graphPoints.count - 1)
        return CGFloat(column) * spacing + margin + 2
      }
      // Calculate the y point
          
      let topBorder = Constants.topBorder
      print("🍎 topBorder =  \(topBorder)")
      let bottomBorder = Constants.bottomBorder
      print("🍎 bottomBorder =  \(bottomBorder)")
      let graphHeight = height - topBorder - bottomBorder
      print("🍎 graphHeight =  \(graphHeight)")
      print("🍎 height =  \(height)")
      guard let maxValue = graphPoints.max() else {
        return
      }
      let columnYPoint = { (graphPoint: Int) -> CGFloat in
        let yPoint = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
          let point = yPoint - (graphHeight - topBorder)
         let mimusPoint = graphHeight + topBorder - yPoint // Переворот графика
          if graphPoint < 0 {
              return mimusPoint
          } else {
              return point
          }
        
      }
      // Отрисовка линии графика

      UIColor.white.setFill()
      UIColor.white.setStroke()
          
      // Задание точек графика
      let graphPath = UIBezierPath()

      // Идем на начало линии графика
      graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
          
      // Добавляем точки для каждого элемента в массиве graphPointsAdd
      // в соответсвующие точки (x, y)
      for i in 1 ..< graphPoints.count {
        let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
        graphPath.addLine(to: nextPoint)
      }
      
      context.saveGState()

      guard let clippingPath = graphPath.copy() as? UIBezierPath else {
        return
      }
      clippingPath.addLine(to: CGPoint(
        x: columnXPoint(graphPoints.count - 1),
        y: height))
      clippingPath.addLine(to: CGPoint(x: columnXPoint(0), y: height))
      clippingPath.close()
          
      // 4 - Добавляем обрезающую кривую в контекст
      clippingPath.addClip()
          
      // 5 - Проверяем обрезающую кривую - Временный код
      let highestYPoint = columnYPoint(maxValue)
      let graphStartPoint = CGPoint(x: margin, y: highestYPoint)
      let graphEndPoint = CGPoint(x: margin, y: bounds.height)
              
      context.drawLinearGradient(
        gradient,
        start: graphStartPoint,
        end: graphEndPoint,
        options: [])
      context.restoreGState()
      graphPath.lineWidth = 1.0
      graphPath.stroke()
      
      // Draw the circles on top of the graph stroke
      for i in 0 ..< graphPoints.count {
        var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
        point.x -= Constants.circleDiameter / 2
        point.y -= Constants.circleDiameter / 2
            
        let circle = UIBezierPath(
          ovalIn: CGRect(
            origin: point,
            size: CGSize(
              width: Constants.circleDiameter,
              height: Constants.circleDiameter)
          )
        )
        circle.fill()
      }
//      var point = CGPoint(x: columnXPoint(0), y: columnYPoint(-50))
      let tempLabels = WeatherLabels(size: 12, weight: .regular, color: .black)
      let arrayLabels = [UILabel](repeatElement(tempLabels, count: graphPoints.count))
      for i in 0 ..< graphPoints.count {
          let point = CGPoint(x: columnXPoint(i)-10, y: columnYPoint(graphPoints[i])-30)
          var label = arrayLabels[i] as UILabel
          label = UILabel(frame: CGRect(origin: point, size: Constants.sizeLabel))
          label.text = "\(graphPoints[i])˚"
          self.addSubview(label)
      }
      
  }
    
}
