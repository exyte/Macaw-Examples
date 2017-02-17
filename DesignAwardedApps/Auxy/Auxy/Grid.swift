import Foundation
import Macaw

class Grid: Group {
    
    init(dimension: (Int,Int), cell: Size, size: Size) {
        let stroke = Stroke(fill: Color.black, width: 1.0)
        
        let columns = Array(0..<dimension.0).map { column in
            let x = cell.w * Double(column)
            return Shape(
                form: Line(x1: x, y1: 0, x2: x, y2: size.h),
                stroke: stroke,
                opacity: 0.2
            )
        }.group()
        
        let rows = Array(0..<dimension.1).map { row in
            let y = cell.h * Double(row)
            return Shape(
                form: Line(x1: 0, y1: y, x2: size.w, y2: y),
                stroke: stroke,
                opacity: row % 4 == 0 ? 1 : 0.2
            )
        }.group()
        
        super.init(contents: [columns, rows], opaque: false)
    }
}
