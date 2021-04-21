//
//  NBA.swift
//  NBA
//
//  Created by Kazim Walji on 4/21/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct NBAEntryView : View {
    var entry: Provider.Entry
    let game = NbaData.bestGame() ?? nil
    @Environment(\.widgetFamily) var family
    var body: some View {
        switch family {
        case .systemSmall:
            if game != nil {
                ZStack {
                    RadialGradient(gradient: Gradient(colors: [.black, .gray]), center: .center, startRadius: 12, endRadius: 200)
            VStack {
                VStack(spacing: 12) {
                    HStack(spacing: 20) {
                        Image(uiImage: game!.homeImage).resizable()
                            .frame(width: 40.0, height: 40.0)
                        Text(String(game!.homeScore)).font(.system(size: 25.0)).foregroundColor(Color.white)
                    }
                    HStack(spacing: 20) {
                        Image(uiImage: game!.awayImage).resizable()
                            .frame(width: 40.0, height: 40.0)
                        Text(String(game!.awayScore)).font(.system(size: 25.0)).foregroundColor(Color.white)
                    }
                }
                if (game!.inProgress) {
                    VStack(spacing: 0) {
                        Text(game!.clock).font(.system(size: 15.0))
                        Text("Quarter  \(game!.quarter)").font(.system(size: 20.0)).foregroundColor(Color.white)
                    }
                } else {
                    VStack(spacing: 10) {
                        Text(game!.description).font(.system(size: 20.0)).foregroundColor(Color.white)
                    }
                }
            }
                
            }
            }
            else {
                ZStack {
                    RadialGradient(gradient: Gradient(colors: [.black, .gray]), center: .center, startRadius: 5, endRadius: 200)
                Text("No Connection").font(.system(size: 20.0)).foregroundColor(Color.white)
                }
            }
            
            
        default:
            Text("n/a")
        }
    }
}

@main
struct NBA: Widget {
    let kind: String = "NBA"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            NBAEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct NBA_Previews: PreviewProvider {
    static var previews: some View {
        NBAEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
