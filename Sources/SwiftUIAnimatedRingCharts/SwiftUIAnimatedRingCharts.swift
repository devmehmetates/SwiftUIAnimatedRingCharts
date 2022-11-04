import SwiftUI

@available(iOS 15.0, *)
private struct RingChartView: View {
    @State private var overloadXOffset: CGFloat = 0
    @State private var overloadYOffset: CGFloat = -5
    @State private var animateValue: CGFloat = 0
    let value: CGFloat
    var ringMaxValue: CGFloat
    var lineWidth: CGFloat
    var colors: [Color]
    var isAnimated: Bool
    var overloadColors: [[Color]] {
        var lastColor: Color = colors.last ?? .blue
        var branchArray: [Color] = []
        var colorArray: [[Color]] = []
        
        for constant in 1...Int((self.value / ringMaxValue).rounded(.up)) {
            let firstAppendColor = lastColor.adjust(hue: 0.0 * CGFloat(constant), saturation: 0, brightness: 0, opacity: 0)
            let secondAppendColor = firstAppendColor.adjust(hue: 0.001 * CGFloat(constant), saturation: 0, brightness: 0.08, opacity: 0)
            
            branchArray.append(firstAppendColor)
            branchArray.append(secondAppendColor)
            colorArray.append(branchArray)
            lastColor = branchArray.last ?? .blue
            branchArray.removeAll()
        }
        return colorArray
    }
    
    
    var body: some View {
        ZStack{
            Circle()
                .stroke(lineWidth: lineWidth)
                .foregroundStyle(LinearGradient(colors: colors, startPoint: .trailing, endPoint: .leading))
                .opacity(0.5)
            ZStack(alignment: .top) {
                
                Circle()
                    .trim(from: 0, to: (self.animateValue / ringMaxValue))
                    .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                    .rotation(Angle.degrees(-90))
                    .foregroundStyle(LinearGradient(colors: colors, startPoint: .bottom, endPoint: .top))
                
                let count: Int = Int((self.value / ringMaxValue).rounded(.up))
                
                if count > 1 {
                    ForEach (1..<count, id: \.self) { circleValue in
                        Circle()
                            .trim(from: 0, to: ((self.animateValue - ringMaxValue * CGFloat(circleValue)) / ringMaxValue))
                            .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                            .rotation(Angle.degrees(-90))
                            .foregroundStyle(LinearGradient(colors: circleValue < overloadColors.count ? overloadColors[circleValue] : colors, startPoint: .bottom, endPoint: .top))
                    }
                    
                }
            }
                
            
        }.onAppear{
            self.animateValue = 0
            
            if isAnimated {
                withAnimation(.easeInOut(duration: 2)) {
                    self.animateValue = value
                }
            } else {
                self.animateValue = value
            }
        }
    }
}

@available(iOS 15.0, *)
public struct RingChartsView: View {
    private var pageHelper = Pagehelper()
    private var values: [CGFloat]
    private var colors: Array<Array<Color>>? = []
    private var ringsMaxValue: CGFloat
    private var lineWidth: CGFloat
    private var isAnimated: Bool
    
    public init(values: [CGFloat], colors: Array<Array<Color>>?, ringsMaxValue: CGFloat, lineWidth: CGFloat? = nil, isAnimated: Bool? = nil){
        self.values = values
        self.colors = colors ?? []
        self.ringsMaxValue = ringsMaxValue
        self.lineWidth = lineWidth ?? 10.0
        self.isAnimated = isAnimated ?? false
    }
    public var body: some View {
        GeometryReader{ proxy in
            ZStack{
                ForEach(0..<self.values.count, id: \.self) {
                    RingChartView(value: self.values[$0], ringMaxValue: ringsMaxValue, lineWidth: lineWidth, colors: self.pageHelper.trueColor(for: colors!, count: $0), isAnimated: isAnimated)
                        .frame(width: self.pageHelper.setSpace(proxy, count: $0), height: self.pageHelper.setSpace(proxy, count: $0), alignment: .center)
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
                RingChartsView(values: [100, 950, 70, 10], colors: [[.purple, .orange], [.red, .indigo]], ringsMaxValue: 100)
            }.frame(width: 200, height: 200, alignment: .center)
            
        } else {
            // Fallback on earlier versions
        }
    }
}
#endif

@available(iOS 15.0, *)
private struct Pagehelper{
    func trueColor(for colorList: Array<Array<Color>>, count: Int) -> Array<Color>{
        if (colorList.count - 1) >= count{
            return colorList[count]
        }
        
        return [.blue, .blue]
    }
    
    func setSpace(_ proxy: GeometryProxy, count: Int) -> CGFloat{
        return ((proxy.size.height) - (proxy.size.width / (proxy.size.width / 30) * CGFloat(count)))
    }
}

@available(iOS 13.0, *)
extension Color {
    @available(iOS 14.0, *)
    func adjust(hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, opacity: CGFloat = 1) -> Color {
        let color = UIColor(self)
        var currentHue: CGFloat = 0
        var currentSaturation: CGFloat = 0
        var currentBrigthness: CGFloat = 0
        var currentOpacity: CGFloat = 0

        if color.getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentOpacity) {
            return Color(hue: currentHue + hue, saturation: currentSaturation + saturation, brightness: currentBrigthness + brightness, opacity: currentOpacity + opacity)
        }
        return self
    }
}
