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
                .trim(from: 0, to: (self.value / ringMaxValue))
                .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
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
public struct RingChartsView: View {
    private var pageHelper = Pagehelper()
    private var values: [CGFloat]
    private var colors: Array<Array<Color>>
    private var ringsMaxValue: CGFloat
    
    public init(values: [CGFloat], colors: Array<Array<Color>>?, ringsMaxValue: CGFloat){
        self.values = values
        self.colors = colors ?? []
        self.ringsMaxValue = ringsMaxValue
    }
    public var body: some View {
        GeometryReader{ proxy in
            ZStack{
                ForEach(0..<self.values.count, id: \.self) {
                    RingChartView(value: self.values[$0], ringMaxValue: ringsMaxValue, colors: self.pageHelper.trueColor(for: colors, count: $0))
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
                RingChartsView(values: [1000,500,458,455,33], colors: [[.orange, .red]], ringsMaxValue: 500)
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
        
        return [.blue]
    }
    
    func setSpace(_ proxy: GeometryProxy, count: Int) -> CGFloat{
        return ((proxy.size.height) - (proxy.size.width / (proxy.size.width / 40) * CGFloat(count)))
    }
}
