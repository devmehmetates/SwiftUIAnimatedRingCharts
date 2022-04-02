import SwiftUI

@available(iOS 15.0, *)
private struct RingChartView: View {
    @State var value: CGFloat
    var ringMaxValue: CGFloat
    var colors: [Color]
    
    var body: some View {
        ZStack{
            Circle()
                .stroke(lineWidth: 10)
                .foregroundStyle(LinearGradient(colors: colors, startPoint: .trailing, endPoint: .leading))
                .opacity(0.5)
            Circle()
                .trim(from: 0, to: ( self.value / ringMaxValue))
                .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round))
                .rotation(Angle.degrees(270))
                .foregroundStyle(LinearGradient(colors: colors, startPoint: .trailing, endPoint: .leading))
        }.onAppear{
            let brancValue = self.value
            self.value = 0
            withAnimation(.easeInOut(duration: 2)) {
                self.value = brancValue
            }
        }
    }
}

@available(iOS 15.0, *)
struct RingChartsView: View {
    var values: [CGFloat]
    var colors: Array<Array<Color>>
    var ringsMaxValue: CGFloat
    var body: some View {
        GeometryReader{ proxy in
            ZStack{
                ForEach(0..<self.values.count, id: \.self) {
                    RingChartView(value: self.values[$0], ringMaxValue: ringsMaxValue, colors: (colors.count - 1) >= $0 ? (colors[$0]) : [.blue])
                        .frame(width: ((proxy.size.height) - ((proxy.size.height / 4) * CGFloat($0))), height:((proxy.size.height / 1) - ((proxy.size.height / 4) * CGFloat($0))), alignment: .center)
                }
            }
        }
    }
}

#if DEBUG
struct SwiftUIPercentChart_Previews : PreviewProvider {
    @available(iOS 13.0, *)
    static var previews: some View {
        
        if #available(iOS 15.0, *) {
            VStack{
                RingChartsView(values: [90,50], colors: [[.orange, .red]], ringsMaxValue: 400)
            }.frame(width: 200, height: 200, alignment: .center)
            
        } else {
            // Fallback on earlier versions
        }
    }
}
#endif
